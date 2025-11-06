import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class OnBoadingScreen extends StatefulWidget {
  const OnBoadingScreen({super.key});

  @override
  State<OnBoadingScreen> createState() => _OnBoadingScreenState();
}

class _OnBoadingScreenState extends State<OnBoadingScreen> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _advancePage();
    });
  }

  void _advancePage() {
    if (_currentPage == 2) {
      _navigateToHome();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _navigateToHome() {
    _timer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });

    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              _buildOnboardingPage(
                color: const Color.fromARGB(255, 7, 110, 26),
                title: 'Disease Detection',
                subtitle: 'Spot the issue before it spread',
                imageAsset:
                    'Assets/Images/Spider Plant (Chlorophytum comosum)_ 1.png',
                description:
                    'Agrisense uses AI powered images\n to detect the disease',
                // icon: Icons.eco,
              ),
              _buildOnboardingPage(
                color: const Color.fromARGB(255, 7, 110, 26),
                title: 'Yield ForeCasting',
                subtitle: 'forecasts your yield per hectare.',
                imageAsset:
                    'Assets/Images/Gemini_Generated_Image_rhrdxwrhrdxwrhrd.png',
                //icon: Icons.bar_chart,
                description:
                    'Our LSTM based product model will predeict the yield',
              ),
              _buildOnboardingPage(
                color: const Color.fromARGB(255, 7, 110, 26),
                title: 'Field segmentation',
                subtitle: 'dggjh',
                imageAsset: 'Assets/Images/screenshot.png',
                description: 'jhhk',
              ),
            ],
          ),

          Positioned(
            top: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: _navigateToHome, 
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.3),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Skip'),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildDots(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage({
    required Color color,
    required String title,
    required String subtitle,
    required String imageAsset,
    required String description,
  }) {
    return Container(
      color: color,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 48),
            Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.white70),
              ),
            ),
            SizedBox(height: 20),
            Container(child: Image.asset(imageAsset)),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDots() {
    List<Widget> dots = [];
    for (int i = 0; i < 3; i++) {
      dots.add(
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: 10,
          width: _currentPage == i ? 20 : 10, // Active dot is wider
          decoration: BoxDecoration(
            color: _currentPage == i
                ? Colors.white
                : Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      );
    }
    return dots;
  }
}
