import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  User? _user;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          if (_user != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    _user!.photoURL ??
                        'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?f=y&d=mp',
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Hoş geldiniz,',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
                Text(
                  _user!.email ?? 'Email bulunamadı',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Hesap Bilgileri'),
            onTap: () {
              if (_user == null) {
                _showInfoDialog(
                  context,
                  'Hesap Bilgileri',
                  'Lütfen giriş yapın.',
                );
              } else {
                _showInfoDialog(
                  context,
                  'Hesap Bilgileri',
                  'Email: ${_user!.email}\nGoogle Fotoğraf: ${_user!.photoURL ?? 'Bulunamadı'}',
                );
              }
            },
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Uygulama Hakkında'),
            onTap: () {
              _showInfoDialog(
                context,
                'Uygulama Hakkında',
                'Mükemmel!İşlem tamamlandı.Bizi tercih ettiğiniz için teşekkür eder iyi günler dileriz!',
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Bizim Hakkımızda'),
            onTap: () {
              _showInfoDialog(
                context,
                'Bizim Hakkımızda',
                'Müzik Market, müzik tutkunlarının vazgeçilmez durağıdır. Enstrümanlarımızla müziği keşfedin, ritminizi bulun ve kendi melodinizi oluşturun. Kalite ve tutkuyla dolu bir müzik deneyimi için bizi tercih edin.',
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.update),
            title: const Text('Uygulama Sürümü'),
            subtitle: const Text('1.0.0'),
          ),
          const SizedBox(height: 20),
          if (_user != null)
            ElevatedButton(
              onPressed: _signOut,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Colors.red,
              ),
              child: const Text('Çıkış Yap', style: TextStyle(fontSize: 18)),
            ),
        ],
      ),
    );
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void _showInfoDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: const Text('Kapat'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
