import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/first_page.dart';
import 'package:flutter_application_2/pages/home_page.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool _isEmailVerified = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _checkEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    setState(() {
      _isEmailVerified = user?.emailVerified ?? false;
    });

    if (_isEmailVerified) {
      _timer.cancel();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  Future<void> _sendVerificationEmail() async {
    try {
      setState(() {
        _isEmailVerified = false;
      });
      final user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();
      _showVerificationDialog();
    } catch (e) {
      _showErrorDialog('Doğrulama E-Postası Gönderilemedi');
    }
  }

  void _showVerificationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Neredeyse Bitti..."),
          content: const Text(
              "E-postanıza bir doğrulama bağlantısı gönderdik. Lütfen e-postanızı kontrol edin ve doğrulama işlemini tamamlamak için bağlantıya tıklayın."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Hata"),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _checkEmailVerification();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 95, 193, 232),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildImage(),
        _buildTitle(),
        _buildDescription(),
        _buildButtons(),
      ],
    );
  }

  Widget _buildImage() {
    return const Image(
      image: AssetImage('lib/resimler/Designer-removebg-preview.png'),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Hesabını Doğrula',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDescription() {
    return const Text(
      "Lütfen tıkla ve e-postana gönderdğimiz talimatlar ile hesabını doğrula",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 15,
        fontFamily: 'Comic Sans MS',
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        TextButton(
          onPressed: _sendVerificationEmail,
          child: const Text('Doğrulama E-Postasını Gönder'),
        ),
        TextButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const FirstPage()));
          },
          child: const Text('Vazgeç', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
