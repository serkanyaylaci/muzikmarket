import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/first_page.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LogoAnimation(),
    );
  }
}

class LogoAnimation extends StatefulWidget {
  @override
  _LogoAnimationState createState() => _LogoAnimationState();
}

class _LogoAnimationState extends State<LogoAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late SequenceAnimation sequenceAnimation;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 4000),
    );

    final double initialScale = 0.5;
    final double maxScale = 0.8;

    sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
          animatable: Tween<double>(begin: 0.0, end: initialScale),
          from: Duration.zero,
          to: Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
          tag: "scale",
        )
        .addAnimatable(
          animatable: Tween<double>(begin: initialScale, end: maxScale),
          from: Duration(milliseconds: 1000),
          to: Duration(milliseconds: 2000),
          curve: Curves.easeInOut,
          tag: "scaleUp",
        )
        .addAnimatable(
          animatable: Tween<double>(begin: 0.0, end: 2 * 3.141592653589793),
          from: Duration(milliseconds: 2000),
          to: Duration(milliseconds: 3000),
          curve: Curves.easeInOut,
          tag: "rotation",
        )
        .addAnimatable(
          animatable: Tween<double>(begin: maxScale, end: 0.0),
          from: Duration(milliseconds: 3000),
          to: Duration(milliseconds: 4000),
          curve: Curves.easeInOut,
          tag: "scaleDown",
        )
        .animate(controller);

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          loading = true;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FirstPage()),
        );
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          loading = false;
        });
      }
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return Opacity(
                  opacity: loading ? 0.0 : 1.0,
                  child: Transform.scale(
                    scale: sequenceAnimation['scaleUp'].value,
                    child: Transform.rotate(
                      angle: sequenceAnimation['rotation'].value,
                      child: Transform.scale(
                        scale: sequenceAnimation['scaleDown'].value,
                        child: child,
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                child: Image.asset('lib/resimler/logo2.png'),
              ),
            ),
            Visibility(
              visible: loading,
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
