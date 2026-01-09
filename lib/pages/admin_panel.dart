import 'dart:io'; // Dosya işlemleri için (File sınıfı)

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // NoSQL Veritabanı işlemleri için
import 'package:firebase_storage/firebase_storage.dart'; // Görsel dosyalarını saklamak için
import 'package:image_picker/image_picker.dart'; // Galeriden fotoğraf seçmek için

/// AdminPanel: Uygulamaya yeni ürün eklenmesini sağlayan yönetim ekranı.
class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  // TextField'lardaki verileri kontrol etmek ve okumak için Controller nesneleri
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  // Seçilen resmin cihazdaki yerel yolunu tutar
  late String _selectedImagePath;
  // İşlem devam ederken kullanıcıya geri bildirim (loading) vermek için kullanılan değişken
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _selectedImagePath = ''; // Başlangıçta seçili resim yok
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel - Ürün Yönetimi'),
        centerTitle: true,
      ),
      // Klavye açıldığında taşma hatası almamak için SingleChildScrollView kullanıldı
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resim Seçme Butonu
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.image),
              label: Text('Ürün Fotoğrafı Seç'),
            ),
            SizedBox(height: 10),
            // Seçilen resmin önizlemesi
            _buildImagePreview(),
            SizedBox(height: 20),
            Text(
              'Yeni Ürün Bilgileri',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Form Alanları
            _buildTextField(_brandController, 'Marka (Örn: Apple)'),
            _buildTextField(_nameController, 'Ürün Adı'),
            _buildTextField(_descriptionController, 'Açıklama'),
            _buildTextField(_priceController, 'Fiyat', keyboardType: TextInputType.number),
            _buildTextField(_categoryController, 'Kategori'),
            SizedBox(height: 20),
            
            // Eğer yükleme işlemi sürüyorsa göstergeyi, sürmüyorsa butonu göster
            _isUploading 
                ? Center(child: CircularProgressIndicator()) 
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: _validateAndUpload,
                      child: Text('Ürünü Sisteme Ekle', style: TextStyle(color: Colors.white)),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  /// TextField oluşturmak için kullanılan yardımcı metod (Kod tekrarını önler)
  Widget _buildTextField(TextEditingController controller, String labelText, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(), // Daha profesyonel görünüm için çerçeve
        ),
      ),
    );
  }

  /// Seçilen görselin ekranda önizlemesini yapar
  Widget _buildImagePreview() {
    if (_selectedImagePath.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(_selectedImagePath),
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Text("Henüz bir görsel seçilmedi.", style: TextStyle(color: Colors.grey));
    }
  }

  /// Cihazın galerisinden görsel seçmeyi sağlayan metod
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    // image_picker kütüphanesi ile galeriden resim çekilir
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImagePath = pickedImage.path;
      });
    }
  }

  /// Veri doğrulama ve Firebase yükleme sürecini başlatan köprü metod
  void _validateAndUpload() {
    if (_selectedImagePath.isEmpty || _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lütfen görsel ve ürün adı alanlarını doldurun!")),
      );
      return;
    }

    _addProductToFirestore({
      'brand': _brandController.text,
      'name': _nameController.text,
      'description': _descriptionController.text,
      'price': _priceController.text,
      'category': _categoryController.text,
    });
  }

  /// Görseli Firebase Storage'a yükler, URL'sini alır ve tüm veriyi Firestore'a kaydeder
  Future<void> _addProductToFirestore(Map<String, dynamic> productData) async {
    setState(() {
      _isUploading = true; // Yükleme animasyonunu başlat
    });

    try {
      // 1. ADIM: Görseli Firebase Storage'a yükleme
      final file = File(_selectedImagePath);
      final fileName = DateTime.now().millisecondsSinceEpoch.toString(); // Çakışma olmaması için benzersiz isim

      final storageRef = FirebaseStorage.instance.ref().child('product_images/$fileName');

      // Dosyayı asenkron olarak yükle
      final uploadTask = storageRef.putFile(file);
      await uploadTask.whenComplete(() => null);
      
      // Yüklenen dosyanın indirme URL'sini (Public URL) al
      final downloadUrl = await storageRef.getDownloadURL();

      // 2. ADIM: Firestore veritabanına kayıt ekleme
      await FirebaseFirestore.instance.collection('Products').add({
        'brand': productData['brand'],
        'name': productData['name'],
        'description': productData['description'],
        'price': productData['price'],
        'category': productData['category'],
        'imageUrl': downloadUrl, // Storage'dan gelen URL buraya kaydedilir
        'createdAt': FieldValue.serverTimestamp(), // Sıralama için zaman damgası
      });

      // 3. ADIM: Başarılı işlem sonrası formu temizle
      _clearForm();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ürün başarıyla eklendi!")),
      );

    } catch (error) {
      print('Hata oluştu: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Bir hata oluştu: $error")),
      );
    } finally {
      setState(() {
        _isUploading = false; // Her durumda yükleme animasyonunu durdur
      });
    }
  }

  /// Form alanlarını sıfırlayan yardımcı metod
  void _clearForm() {
    _brandController.clear();
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _categoryController.clear();
    setState(() {
      _selectedImagePath = '';
    });
  }
}