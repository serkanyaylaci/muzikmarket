import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/login_page.dart';
import 'package:flutter_application_2/pages/register_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({
    super.key,
  });

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  //başlangıçta giriş sayfasını göster
  bool showLoginPage = true;

  //geçiş yapmak giriş ekranı veya kayıt ekranı arasında
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTap:
            togglePages, // Butona tıklandığında togglePages fonksiyonunu çağırın
      );
    } else {
      return RegisterPage(
        onTap:
            togglePages, // Butona tıklandığında togglePages fonksiyonunu çağırın
      );
    }
  }
}
