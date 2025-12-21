import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/admin_panel.dart';

class AdminWelcomePage extends StatefulWidget {
  @override
  _AdminWelcomePageState createState() => _AdminWelcomePageState();
}

class _AdminWelcomePageState extends State<AdminWelcomePage> {
  bool _isFirstVisible = false;
  bool _isSecondVisible = false;
  bool _isFormVisible = false;
  bool _isLoginButtonVisible = false;
// Giriş başarılı olduğunda gösterilecek

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _adminCodeController = TextEditingController();

  // Kullanıcı bilgileri koleksiyonu
  final Map<String, dynamic> userData = {
    'Mail': 'muzikmarket@glbl.com',
    'Password': 'muzikmarketadmin',
    'Admin_Password': 'admincode',
    'isAdmin': 'true',
  };

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isFirstVisible = true;
      });
    });
    Future.delayed(Duration(milliseconds: 1500), () {
      setState(() {
        _isSecondVisible = true;
      });
    });
    Future.delayed(Duration(milliseconds: 2500), () {
      setState(() {
        _isFormVisible = true;
      });
    });
    Future.delayed(Duration(milliseconds: 3000), () {
      setState(() {
        _isLoginButtonVisible = true;
      });
    });
  }

  // Kullanıcının girdiği bilgileri kontrol eden fonksiyon
  bool checkCredentials(String email, String password, String adminCode) {
    if (userData['Mail'] == email &&
        userData['Password'] == password &&
        userData['Admin_Password'] == adminCode) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arka plan resmi
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'lib/resimler/slide3.png'), // Resim yolunu buraya girin
                fit: BoxFit.cover, // Resmin boyutunu ayarlamak için kullanılır
              ),
            ),
          ),
          // Gri arka plan overlay
          Container(
            color: Colors.black.withOpacity(0.5), // Gri ekran overlay
          ),
          // İçerik
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SlideInText(
                    isVisible: _isFirstVisible,
                    text: 'Sevgili Yönetici,',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  SlideInText(
                    isVisible: _isSecondVisible,
                    text: 'Hoş Geldiniz!',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 40),
                  if (_isFormVisible) ...[
                    SlideInFormField(
                      isVisible: _isFormVisible,
                      controller: _emailController,
                      hintText: 'E-posta',
                      obscureText: false,
                    ),
                    SizedBox(height: 20),
                    SlideInFormField(
                      isVisible: _isFormVisible,
                      controller: _passwordController,
                      hintText: 'Şifre',
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    SlideInFormField(
                      isVisible: _isFormVisible,
                      controller: _adminCodeController,
                      hintText: 'Yönetici Parolası',
                      obscureText: true,
                    ),
                  ],
                  SizedBox(height: 40),
                  if (_isLoginButtonVisible) ...[
                    SlideInButton(
                      isVisible: _isLoginButtonVisible,
                      onPressed: () async {
                        // Giriş butonuna basıldığında yapılacak işlemler
                        String email = _emailController.text;
                        String password = _passwordController.text;
                        String adminCode = _adminCodeController.text;

                        // Kullanıcı bilgilerini kontrol et
                        bool loginSuccess =
                            checkCredentials(email, password, adminCode);

                        // Giriş başarılı ise AdminPanel sayfasına yönlendir
                        if (loginSuccess) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminPanel()),
                          );
                        }
                      },
                      buttonText: 'Giriş Yap',
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SlideInText extends StatefulWidget {
  final bool isVisible;
  final String text;
  final TextStyle style;

  SlideInText({
    required this.isVisible,
    required this.text,
    required this.style,
  });

  @override
  _SlideInTextState createState() => _SlideInTextState();
}

class _SlideInTextState extends State<SlideInText>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    if (widget.isVisible) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant SlideInText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible) {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: _slideAnimation.value,
          child: Opacity(
            opacity: _animationController.value,
            child: child,
          ),
        );
      },
      child: Text(
        widget.text,
        style: widget.style,
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class SlideInFormField extends StatefulWidget {
  final bool isVisible;
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  SlideInFormField({
    required this.isVisible,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  _SlideInFormFieldState createState() => _SlideInFormFieldState();
}

class _SlideInFormFieldState extends State<SlideInFormField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    if (widget.isVisible) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant SlideInFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible) {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: _slideAnimation.value,
          child: Opacity(
            opacity: _animationController.value,
            child: child,
          ),
        );
      },
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.black.withOpacity(0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class SlideInButton extends StatefulWidget {
  final bool isVisible;
  final VoidCallback onPressed;
  final String buttonText;

  SlideInButton({
    required this.isVisible,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  _SlideInButtonState createState() => _SlideInButtonState();
}

class _SlideInButtonState extends State<SlideInButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    if (widget.isVisible) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant SlideInButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible) {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: _slideAnimation.value,
          child: Opacity(
            opacity: _animationController.value,
            child: child,
          ),
        );
      },
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: Colors.blue,
        ),
        child: Text(
          widget.buttonText,
          style: TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
