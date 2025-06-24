import 'package:flutter/material.dart';
import '../widgets/modern_hero_section.dart';
import '../widgets/modern_about_section.dart';
import '../widgets/modern_projects_section.dart';
import '../widgets/modern_contact_section.dart';
import '../widgets/modern_navigation_bar.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  void _scrollToSection(String section) {
    GlobalKey? targetKey;

    switch (section) {
      case 'home':
        targetKey = _heroKey;
        break;
      case 'about':
        targetKey = _aboutKey;
        break;
      case 'projects':
        targetKey = _projectsKey;
        break;
      case 'contact':
        targetKey = _contactKey;
        break;
    }

    if (targetKey?.currentContext != null) {
      Scrollable.ensureVisible(
        targetKey!.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Hero Section
                Container(
                  key: _heroKey,
                  child: const ModernHeroSection(),
                ),

                // About Section
                Container(
                  key: _aboutKey,
                  child: const ModernAboutSection(),
                ),

                // Projects Section
                Container(
                  key: _projectsKey,
                  child: const ModernProjectsSection(),
                ),

                // Contact Section
                Container(
                  key: _contactKey,
                  child: const ModernContactSection(),
                ),
              ],
            ),
          ),

          // Navigation Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ModernNavigationBar(
              onNavigate: _scrollToSection,
            ),
          ),
        ],
      ),
    );
  }
}
