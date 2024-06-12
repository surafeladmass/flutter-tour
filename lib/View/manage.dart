import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AdminCategoryPage extends StatefulWidget {
  final String title;
  final String collection;

  AdminCategoryPage({required this.title, required this.collection});

  @override
  _AdminCategoryPageState createState() => _AdminCategoryPageState();
}

class _AdminCategoryPageState extends State<AdminCategoryPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _addItem() async {
    if (_nameController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _imageFile != null) {
      // Upload image to Firebase Storage and get the URL
      String imageUrl = await _uploadImage();

      await FirebaseFirestore.instance.collection(widget.collection).add({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'image': imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.title} successfully added')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please fill all fields and select an image')));
    }
  }

  Future<void> _deleteItem(String id) async {
    await FirebaseFirestore.instance
        .collection(widget.collection)
        .doc(id)
        .delete();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.title} successfully deleted')));
  }

  Future<void> _editItem(String id) async {
    String imageUrl = _imageFile != null ? await _uploadImage() : '';

    Map<String, dynamic> updatedData = {
      'name': _nameController.text,
      'description': _descriptionController.text,
    };

    if (imageUrl.isNotEmpty) {
      updatedData['image'] = imageUrl;
    }

    await FirebaseFirestore.instance
        .collection(widget.collection)
        .doc(id)
        .update(updatedData);

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.title} successfully edited')));
  }

  Future<void> _searchItem(BuildContext context) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(widget.collection)
        .where('name', isEqualTo: _nameController.text)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot doc = querySnapshot.docs.first;
      _nameController.text = doc['name'];
      _descriptionController.text = doc['description'];
      _showEditDialog(context, doc.id, doc['image']);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No such data found')));
    }
  }

  Future<String> _uploadImage() async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('images/${DateTime.now().toIso8601String()}');
    await ref.putFile(_imageFile!);
    return await ref.getDownloadURL();
  }

  void _showEditDialog(BuildContext context, String id, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit ${widget.title}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 10),
              imageUrl.isNotEmpty
                  ? Image.network(imageUrl, height: 100)
                  : Container(),
              TextButton(
                onPressed: _pickImage,
                child: Text('Change Image'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _editItem(id);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                _deleteItem(id);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 10),
            _imageFile != null
                ? Image.file(_imageFile!, height: 100)
                : Container(),
            TextButton(
              onPressed: _pickImage,
              child: Text('Select Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addItem,
              child: Text('Add ${widget.title}'),
            ),
            ElevatedButton(
              onPressed: () => _searchItem(context),
              child: Text('Search ${widget.title}'),
            ),
          ],
        ),
      ),
    );
  }
}
