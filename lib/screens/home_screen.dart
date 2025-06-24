import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/hero_section.dart';
import '../widgets/about_section.dart';
import '../widgets/projects_section.dart';
import '../widgets/navigation_bar.dart';
import '../widgets/marquee_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(double offset) {
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF000000), // Pure black background
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Custom Navigation Bar
          SliverAppBar(
            backgroundColor: const Color(0xFF000000).withOpacity(0.95),
            floating: true,
            pinned: true,
            elevation: 0,
            flexibleSpace: CustomNavigationBar(
              onSectionTap: _scrollToSection,
            ),
          ),

          // Content
          SliverList(
            delegate: SliverChildListDelegate([
              // Marquee Text
              const MarqueeText(
                text:
                    '   Halo saya Faldy Sanger   •   Selamat datang di portfolio saya   •   Flutter Developer & Automotive Enthusiast   •   ',
                fontSize: 16,
                color: Color(0xFF00FF00),
                duration: Duration(seconds: 15),
              ),
              HeroSection(
                onViewProjectsTap: () => _scrollToSection(1600),
              ),
              const AboutSection(),
              const ProjectsSection(),

              // Footer
              Container(
                padding: const EdgeInsets.all(32),
                color: const Color(0xFF000000),
                child: Center(
                  child: Text(
                    '© 2025 Faldy - Street Coder. Built with Flutter & Speed.',
                    style: GoogleFonts.orbitron(
                      color: const Color(0xFF00FF00),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
