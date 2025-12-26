import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const ProductDetailPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data['name'] ?? 'Bilgi yok'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: data['image'] != null
                  ? Image.network(
                      data['image'],
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.image, size: 100),
            ),
            const SizedBox(height: 16),
            Text(
              'Marka: ${data['brand'] ?? 'Bilgi yok'}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Ürün Adı: ${data['name'] ?? 'Bilgi yok'}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Açıklama: ${data['description'] ?? 'Bilgi yok'}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Fiyat: ${data['price'] ?? 0} TL',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Sepete ekleme işlemi
              },
              child: const Text('Sepete ekle'),
            ),
            const SizedBox(height: 16),
            FavoritesManager(productData: data),
          ],
        ),
      ),
    );
  }
}

class FavoritesManager extends StatelessWidget {
  final Map<String, dynamic> productData;

  const FavoritesManager({Key? key, required this.productData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        addToFavorites(productData);
      },
      icon: const Icon(Icons.favorite_border),
      color: Colors.red,
    );
  }

  static Future<void> addToFavorites(Map<String, dynamic> productData) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('Favorites')
            .where('userId', isEqualTo: user.uid)
            .where('name', isEqualTo: productData['name'])
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Ürün zaten favorilerde
          print('Bu ürün zaten favorilerinizde.');
        } else {
          // Ürün favoriye ekleniyor
          await FirebaseFirestore.instance.collection('Favorites').add({
            'name': productData['name'],
            'description': productData['description'],
            'brand': productData['brand'],
            'price': productData['price'],
            'image': productData['image'],
            'userId': user.uid,
          });
        }
      } catch (error) {
        print('Hata: $error');
      }
    } else {
      print('Kullanıcı kimliği doğrulanmamış.');
    }
  }
}
