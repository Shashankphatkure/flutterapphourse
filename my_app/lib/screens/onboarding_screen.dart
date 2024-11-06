import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../utils/page_transitions.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              _buildHeader(),
              const SizedBox(height: 40),
              _buildTitle(),
              const SizedBox(height: 16),
              _buildDescription(),
              const Spacer(),
              _buildButtons(context),
              const SizedBox(height: 16),
              _buildPageIndicator(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Container(
          height: 300,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -20,
                left: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7FF4B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              Positioned(
                bottom: 40,
                right: -30,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Center(
                child: _buildProfileCircles(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCircles() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 20,
                left: 20,
                child: _buildProfileCircle('https://picsum.photos/100/100?random=1', true),
              ),
              Positioned(
                top: 100,
                right: 20,
                child: _buildProfileCircle('https://picsum.photos/100/100?random=2', false),
              ),
              Positioned(
                bottom: 30,
                left: 50,
                child: _buildProfileCircle('https://picsum.photos/100/100?random=3', false),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFE7FF4B),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Follow',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCircle(String imageUrl, bool hasButton) {
    return Stack(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
            border: Border.all(
              color: Colors.white,
              width: 3,
            ),
          ),
        ),
        if (hasButton)
          Positioned(
            bottom: -5,
            right: -5,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFFE7FF4B),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                size: 16,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Best Social App to\nMake New Friends',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      'With Pipel you will find new friends from various countries and regions of the world',
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey[600],
        height: 1.5,
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        FilledButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              FadePageRoute(page: const LoginScreen()),
            );
          },
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFE7FF4B),
            foregroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            'Get Started',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              SlidePageRoute(page: const LoginScreen()),
            );
          },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            side: const BorderSide(color: Colors.grey),
          ),
          child: const Text('Login'),
        ),
      ],
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) => Container(
          width: index == 0 ? 24 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: index == 0 ? const Color(0xFFE7FF4B) : Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
} 