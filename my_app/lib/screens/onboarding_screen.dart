import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import '../utils/page_transitions.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Connect with Horse Lovers',
      description: 'Join a vibrant community of equestrians, share experiences, and make lasting connections with fellow horse enthusiasts.',
      image: 'assets/images/onboarding1.jpg',
      color: const Color(0xFFE7FF4B),
    ),
    OnboardingPage(
      title: 'Share Your Journey',
      description: 'Document your equestrian adventures, showcase your achievements, and inspire others with your unique story.',
      image: 'assets/images/onboarding2.jpg',
      color: const Color(0xFF7ED957),
    ),
    OnboardingPage(
      title: 'Discover & Learn',
      description: 'Access expert tips, training resources, and connect with professional trainers to enhance your horsemanship.',
      image: 'assets/images/onboarding3.jpg',
      color: const Color(0xFF4BB3FF),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const Spacer(),
          Container(
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: page.color.withOpacity(0.1),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Decorative elements
                Positioned(
                  top: -20,
                  left: -20,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: page.color.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                // Main image or illustration
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    'https://picsum.photos/400/300', // Replace with actual image
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            page.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPageIndicator(),
          const SizedBox(height: 32),
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => Container(
          width: _currentPage == index ? 24 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: _currentPage == index 
                ? _pages[_currentPage].color 
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        FilledButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              FadePageRoute(page: const RegisterScreen()),
            );
          },
          style: FilledButton.styleFrom(
            backgroundColor: _pages[_currentPage].color,
            foregroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            'Create Account',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Already have an account? ',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  SlidePageRoute(page: const LoginScreen()),
                );
              },
              child: Text(
                'Login',
                style: TextStyle(
                  color: _pages[_currentPage].color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String image;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.image,
    required this.color,
  });
} 