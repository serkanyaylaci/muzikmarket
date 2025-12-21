import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  late String _selectedImagePath;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _selectedImagePath = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Fotoğraf Seç'),
            ),
            SizedBox(height: 10),
            _buildImagePreview(),
            SizedBox(height: 20),
            Text(
              'Ürün Ekle',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            _buildTextField(_brandController, 'Marka'),
            _buildTextField(_nameController, 'İsim'),
            _buildTextField(_descriptionController, 'Açıklama'),
            _buildTextField(_priceController, 'Fiyat'),
            _buildTextField(_categoryController, 'Kategori'),
            SizedBox(height: 10),
            if (_isUploading) CircularProgressIndicator(),
            ElevatedButton(
              onPressed: () {
                _addProductToFirestore({
                  'brand': _brandController.text,
                  'name': _nameController.text,
                  'description': _descriptionController.text,
                  'price': _priceController.text,
                  'category': _categoryController.text,
                  'imageUrl': _selectedImagePath,
                });
              },
              child: Text('Ekle'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
    );
  }

  Widget _buildImagePreview() {
    if (_selectedImagePath.isNotEmpty) {
      return Image.file(
        File(_selectedImagePath),
        width: 200,
        height: 200,
      );
    } else {
      return SizedBox(height: 10);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImagePath = pickedImage.path;
      });
    }
  }

  Future<void> _addProductToFirestore(Map<String, dynamic> productData) async {
    setState(() {
      _isUploading = true;
    });

    try {
      final file = File(_selectedImagePath);
      final fileName = file.path.split('/').last;

      final storageRef =
          FirebaseStorage.instance.ref().child('product_images/$fileName');

      final uploadTask = storageRef.putFile(file);
      await uploadTask.whenComplete(() => null);
      final downloadUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('Products').add({
        'brand': productData['brand'],
        'name': productData['name'],
        'description': productData['description'],
        'price': productData['price'],
        'category': productData['category'],
        'imageUrl': downloadUrl,
      });

      setState(() {
        _isUploading = false;
      });

      _brandController.clear();
      _nameController.clear();
      _descriptionController.clear();
      _priceController.clear();
      _categoryController.clear();
      setState(() {
        _selectedImagePath = '';
      });
    } catch (error) {
      print('Hata: $error');
      setState(() {
        _isUploading = false;
      });
    }
  }
}
