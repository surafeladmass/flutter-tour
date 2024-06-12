import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

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
  final TextEditingController _imageUrlController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  double _uploadProgress = 0;

  Future<void> _addItem() async {
    if (_nameController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        (_imageFile != null || _imageUrlController.text.isNotEmpty)) {
      setState(() {
        _isUploading = true;
      });

      String imageUrl = _imageUrlController.text.isNotEmpty
          ? _imageUrlController.text
          : await _uploadImage();

      await FirebaseFirestore.instance.collection(widget.collection).add({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'image': imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.title} successfully added')));

      _nameController.clear();
      _descriptionController.clear();
      _imageUrlController.clear();
      setState(() {
        _imageFile = null;
        _isUploading = false;
        _uploadProgress = 0;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Please fill all fields and select an image or provide an image URL')));
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
      String imageUrl = doc.data() != null &&
              (doc.data() as Map<String, dynamic>).containsKey('image')
          ? doc['image']
          : '';
      _showEditDialog(context, doc.id, imageUrl);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No such data found')));
    }
  }

  Future<String> _uploadImage() async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('images/${DateTime.now().toIso8601String()}');
    final uploadTask = ref.putFile(_imageFile!);

    uploadTask.snapshotEvents.listen((event) {
      setState(() {
        _uploadProgress =
            event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
      });
    });

    await uploadTask;
    return await ref.getDownloadURL();
  }

  void _showEditDialog(BuildContext context, String id, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit ${widget.title}'),
          content: SingleChildScrollView(
            child: Column(
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
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            SizedBox(height: 10),
            _imageFile != null
                ? kIsWeb
                    ? Image.network(_imageFile!.path, height: 100)
                    : Image.file(_imageFile!, height: 100)
                : (_imageUrlController.text.isNotEmpty
                    ? Image.network(_imageUrlController.text, height: 100)
                    : Container()),
            TextButton(
              onPressed: _pickImage,
              child: Text('Select Image'),
            ),
            SizedBox(height: 20),
            _isUploading
                ? Column(
                    children: [
                      CircularProgressIndicator(value: _uploadProgress),
                      SizedBox(height: 10),
                      Text(
                          '${(_uploadProgress * 100).toStringAsFixed(2)}% uploaded'),
                    ],
                  )
                : ElevatedButton(
                    onPressed: _addItem,
                    child: Text('Add ${widget.title}'),
                  ),
            ElevatedButton(
              onPressed: () => _searchItem(context),
              child: Text('Search ${widget.title}'),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(widget.collection)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      return ListTile(
                        title: Text(doc['name']),
                        subtitle: Text(doc['description']),
                        leading: (doc.data() as Map<String, dynamic>)
                                    .containsKey('image') &&
                                doc['image'] != null
                            ? Image.network(doc['image'], width: 50)
                            : null,
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _nameController.text = doc['name'];
                            _descriptionController.text = doc['description'];
                            String imageUrl =
                                (doc.data() as Map<String, dynamic>)
                                        .containsKey('image')
                                    ? doc['image']
                                    : '';
                            _showEditDialog(context, doc.id, imageUrl);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminHomePage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text('Admin Home'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/ethio.jpeg'),
            ),
            SizedBox(height: 20),
            Text(
              user?.displayName ?? 'Admin Name',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              user?.email ?? 'admin@example.com',
              style: TextStyle(fontSize: 16, color: Colors.grey[200]),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              alignment: WrapAlignment.center,
              children: [
                _buildAdminOption(
                    context, 'Tourist Destinations', 'tourist_destinations'),
                _buildAdminOption(context, 'Hotels', 'hotels'),
                _buildAdminOption(context, 'Cities', 'cities'),
                _buildAdminOption(
                    context, 'Cultural Festivals', 'cultural_festivals'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminOption(
      BuildContext context, String title, String collection) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                AdminCategoryPage(title: title, collection: collection),
          ),
        );
      },
      child: Text(title),
    );
  }
}
