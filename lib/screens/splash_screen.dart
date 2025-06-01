import 'dart:async';
import 'package:flutter/material.dart';
import 'search_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  final String title = "MOVIES";

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      title.length,
      (i) => AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      ),
    );

    _animations =
        _controllers
            .map((c) => CurvedAnimation(parent: c, curve: Curves.easeOut))
            .toList();

    _startAnimations();

    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SearchPage()),
      );
    });
  }

  void _startAnimations() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 300), () {
        _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(title.length, (index) {
            return FadeTransition(
              opacity: _animations[index],
              child: ScaleTransition(
                scale: _animations[index],
                child: Text(
                  title[index],
                  style: const TextStyle(
                    color: Color(0xFFE50914),
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
