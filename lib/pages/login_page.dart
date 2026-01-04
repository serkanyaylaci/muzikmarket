import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/components/my_signbuttton.dart';
import 'package:flutter_application_2/components/my_textfield.dart';
import 'package:flutter_application_2/components/square_tile.dart';
import 'package:flutter_application_2/pages/admin_welcome_page.dart';
import 'package:flutter_application_2/pages/forgot_password_page.dart';
import 'package:flutter_application_2/services/auth_service.dart';

// Login (Giriş) Sayfası
class LoginPage extends StatefulWidget {
  // Kayıt ol sayfasına geçiş için kullanılan callback
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// LoginPage state sınıfı
class _LoginPageState extends State<LoginPage> {
  // Kullanıcının e-posta bilgisi için controller
  final emailController = TextEditingController();

  // Kullanıcının şifre bilgisi için controller
  final passwordController = TextEditingController();

  // Kullanıcıyı Firebase Authentication ile giriş yaptıran fonksiyon
  void signUserIn() async {
    // Giriş işlemi sırasında kullanıcıya loading göstergesi gösterilir
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Firebase Authentication üzerinden e-posta ve şifre ile giriş
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Giriş başarılıysa loading dialog kapatılır
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Giriş sırasında hata oluşursa loading dialog kapatılır
      // ignore: use_build_context_synchronously
      Navigator.pop(context);

      // Firebase hata kodu kullanıcıya gösterilir
      showErrorMessage(e.code);
    }
  }

  // Kullanıcıya hata mesajı gösteren dialog
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Login sayfası arka plan rengi
      backgroundColor: const Color(0xFF55aacc),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              // Sayfa içeriğini dikeyde ortalar
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // Uygulama logosu
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/resimler/musico
