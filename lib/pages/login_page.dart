import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/components/my_signbuttton.dart';
import 'package:flutter_application_2/components/my_textfield.dart';
import 'package:flutter_application_2/components/square_tile.dart';
import 'package:flutter_application_2/pages/admin_welcome_page.dart';
import 'package:flutter_application_2/pages/forgot_password_page.dart';
import 'package:flutter_application_2/services/auth_service.dart';

// ignore: implementation_import

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text editing controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //sign in user method
  void signUserIn() async {
    // Loading circle'ı göster
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Firebase Authentication ile giriş yapma işlemi
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Giriş işlemi başarılıysa loading circle'ı kapat
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Giriş işlemi sırasında bir hata oluştuğunda loading circle'ı kapat
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      //show error message
      showErrorMessage(e.code);
    }
  }

  //error message to user
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
      backgroundColor: const Color(0xFF55aacc),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                //logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/resimler/musicotes.png',
                      width: 100,
                      height: 100,
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                //welcome back, you've been missed
                const Text(
                  "Tekrar hoşgeldin, seni özledik",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                //kullanıcı adı textfieldd
                MyTextField(
                  controller: emailController,
                  hintText: 'E-Posta Adresi',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                //şifre textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Şifre',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                //şifremi unuttum
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const ForgotPasswordPage();
                              },
                            ),
                          );
                        },
                        child: const Text(
                          'Parolanızı mı unuttunuz?',
                          style: TextStyle(
                            color: Color.fromARGB(255, 8, 8, 8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                //giriş yap tuşu
                MySignButton(
                  text: "Giriş Yap",
                  onTap: signUserIn,
                ),
                const SizedBox(height: 35),
                //şununla devam et
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Veya bununla devam et',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 8, 8, 8)),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                //google button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(
                      onTap: () => AuthService().signInWithGoogle(),
                      imagePath:
                          'lib/resimler/google-logo-png-google-icon-logo-png-transparent-svg-vector-bie-supply-14.png',
                    ),
                    const SizedBox(
                      width: 10,
                    ), // Araya bir boşluk ekleyelim
                    SquareTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminWelcomePage(),
                          ),
                        );
                      },
                      imagePath: 'lib/resimler/Admin Panel.png',
                    ),
                  ],
                ),

                //üye değil misin hemen şimdi ol
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Üye değilmisin?',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 8, 8, 8),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Şimdi üye ol',
                        style: TextStyle(
                          color: Color.fromARGB(255, 252, 252, 251),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                // Satıcı paneli butonu
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
