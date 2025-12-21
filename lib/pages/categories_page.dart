import 'package:flutter/material.dart';
import 'products_page.dart';

class CategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Örnek kategoriler listesi ve resim yolları
    final List<Map<String, String>> categories = [
      {'name': 'Yaylı Çalgılar', 'image': 'lib/resimler/Yaylı Çalgı.jpg'},
      {'name': 'Vurmalı Çalgılar', 'image': 'lib/resimler/Vurmalı Çalgı.png'},
      {'name': 'Nefesli Çalgılar', 'image': 'lib/resimler/Üflemeli Çalgı.jpg'},
      {'name': 'Tuşlu Çalgılar', 'image': 'lib/resimler/Tuşlu Çalgı.jpg'},
      {'name': 'Telli Çalgılar', 'image': 'lib/resimler/Telli Çalgı.png'}
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Her satırda 2 kare olacak
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Material(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductsPage(
                        category: categories[index]['name']!,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(
                          categories[index]['image']!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                Colors.black54, // Yarı saydam siyah arka plan
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                            ),
                          ),
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            categories[index]['name']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
