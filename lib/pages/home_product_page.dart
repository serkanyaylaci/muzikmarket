import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';

class HomeProductPage extends StatefulWidget {
  @override
  _HomeProductPageState createState() => _HomeProductPageState();

  void searchProducts(String query) {}
}

class _HomeProductPageState extends State<HomeProductPage> {
  late TextEditingController _searchController;
  late Query _query;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _query = FirebaseFirestore.instance.collection('Products');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchProducts(String query) {
    setState(() {
      _query = FirebaseFirestore.instance
          .collection('Products')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + 'z');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(85, 170, 204, 1),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  // Bildirim ikonuna basıldığında yapılacak işlemler
                },
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.grey, // Bildirim ikonunun rengi
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: _searchProducts,
                  decoration: const InputDecoration(
                    hintText: 'Ürün ara...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                    suffixIcon: Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _query.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Veriler alınırken bir hata oluştu.'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Herhangi bir ürün bulunamadı.'),
            );
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 3,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return ProductCard(
                name: data['name'] ?? '',
                description: data['description'] ?? '',
                price: data['price'] ?? 0,
                imageUrl: data['image'] ?? '',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(data: data),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String description;
  final int price;
  final String imageUrl;
  final VoidCallback onTap;

  const ProductCard({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.image, size: 100),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$price TL',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const ProductDetailPage({required this.data});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool favoriDurumu = false;

  // Paylaşma işlemi metodu
  Future<void> _shareProduct() async {
    try {
      final String productName = widget.data['name'] ?? 'Ürün';
      final String shareText = 'Bu ürünü beğendim: $productName';

      // FlutterShare kütüphanesi ile paylaşma işlemi
      await Share.share(shareText, subject: 'Ürünü Paylaş');
    } catch (e) {
      print('Paylaşma işlemi sırasında bir hata oluştu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: widget.data['image'] != null
                      ? Image.network(
                          widget.data['image'],
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image, size: 100),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Marka: ${widget.data['brand'] ?? 'Bilgi yok'}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ürün Adı: ${widget.data['name'] ?? 'Bilgi yok'}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Açıklama: ${widget.data['description'] ?? 'Bilgi yok'}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Fiyat: ${widget.data['price'] ?? 0} TL',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Sepete ekleme işlemi
                      },
                      child: const Text('Sepete Ekle'),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              favoriDurumu = !favoriDurumu;
                              if (favoriDurumu) {
                                // Favoriye ekleme işlemi
                              } else {
                                // Favoriden kaldırma işlemi
                              }
                            });
                          },
                          icon: Icon(
                            Icons.favorite_border,
                            color: favoriDurumu ? Colors.red : null,
                          ),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: _shareProduct, // Paylaşma butonu
                          icon: Icon(Icons.share),
                          label: Text('Paylaş'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Diğer Ürünler',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    // Benzer ürünleri önermek için bir Widget eklenebilir
                    // Örneğin: SimilarProductsWidget(data: benzerUrunler),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
