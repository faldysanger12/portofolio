import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ModernAboutSection extends StatelessWidget {
  const ModernAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;
    final isMobile = size.width < 600;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: isMobile ? 60 : 100,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF111111),
            Color(0xFF1a1a1a),
            Color(0xFF111111),
          ],
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: AnimationLimiter(
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 600),
                childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(child: widget),
                ),
                children: [
                  // Section title
                  Text(
                    'ABOUT ME',
                    style: GoogleFonts.orbitron(
                      fontSize: isMobile ? 32 : (isDesktop ? 48 : 40),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF00FF00),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    width: 80,
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00FF00), Color(0xFF00AA00)],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  SizedBox(height: isMobile ? 40 : 60),

                  // Content
                  isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side - Image and stats
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildProfileImage(),
              const SizedBox(height: 30),
              _buildStatsGrid(),
            ],
          ),
        ),

        const SizedBox(width: 60),

        // Right side - About content
        Expanded(
          flex: 3,
          child: _buildAboutContent(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildProfileImage(),
        const SizedBox(height: 30),
        _buildAboutContent(),
        const SizedBox(height: 30),
        _buildStatsGrid(),
      ],
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [
            Color(0xFF00FF00),
            Color(0xFF00AA00),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00FF00).withOpacity(0.4),
            blurRadius: 30,
            spreadRadius: 10,
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: ClipOval(
        child: Image.asset(
          'assets/images/profilePicture.jpg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              child: const Icon(
                Icons.person,
                size: 100,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAboutContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '👋 Hello World!',
          style: GoogleFonts.orbitron(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFFFF00),
          ),
        ),

        const SizedBox(height: 20),

        Text(
          'I\'m Faldy Sanger, a passionate Flutter developer who transforms ideas into stunning digital experiences. With a love for clean code and innovative design, I specialize in creating high-performance mobile applications and interactive web platforms.',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: Colors.grey[300],
            height: 1.8,
          ),
        ),

        const SizedBox(height: 25),

        // Personal Info
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1a1a1a),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color(0xFF00FF00).withOpacity(0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📝 Personal Info:',
                style: GoogleFonts.orbitron(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF00FF00),
                ),
              ),
              const SizedBox(height: 15),
              _buildInfoRow('👤 Nama', 'Faldy Sanger'),
              _buildInfoRow('📅 Lahir', 'Manado, 14 Juni 2002 (23 Tahun)'),
              _buildInfoRow(
                  '📍 Alamat', 'Jalan 17 Agustus, Bumi Beringin, Lingkungan 5'),
              _buildInfoRow('🎯 Hobi', 'Otomotif'),
              _buildInfoRow('📧 Email', 'faldysanger1@gmail.com'),
              _buildInfoRow('📱 Phone', '+62 895-6328-68733'),
            ],
          ),
        ),

        const SizedBox(height: 20),

        Text(
          '🚀 What I Do:',
          style: GoogleFonts.orbitron(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF00FF00),
          ),
        ),

        const SizedBox(height: 15),

        ...[
          '📱 Cross-platform mobile app development',
          '🌐 Responsive web applications',
          '🎮 Interactive mini-games and animations',
          '⚡ Performance optimization',
          '🎨 UI/UX design implementation',
        ].map((skill) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Color(0xFF00FF00),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      skill,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                ],
              ),
            )),

        const SizedBox(height: 30),

        // Tech stack
        Text(
          '🛠️ Tech Stack:',
          style: GoogleFonts.orbitron(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF00FF00),
          ),
        ),

        const SizedBox(height: 15),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            'Flutter',
            'Dart',
            'Firebase',
            'Node.js',
            'MongoDB',
            'Git',
            'Figma',
            'VS Code'
          ].map((tech) => _TechChip(tech)).toList(),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.orbitron(
                fontSize: 14,
                color: const Color(0xFF00FF00),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Text(
            ': ',
            style: TextStyle(color: Colors.grey),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[300],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 1.5,
      children: [
        _StatCard('50+', 'Projects', Icons.code),
        _StatCard('3+', 'Years Exp', Icons.timeline),
        _StatCard('100%', 'Success Rate', Icons.star),
        _StatCard('24/7', 'Available', Icons.access_time),
      ],
    );
  }
}

class _TechChip extends StatelessWidget {
  final String technology;

  const _TechChip(this.technology);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF00FF00).withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF00FF00).withOpacity(0.5),
        ),
      ),
      child: Text(
        technology,
        style: GoogleFonts.orbitron(
          fontSize: 12,
          color: const Color(0xFF00FF00),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String number;
  final String label;
  final IconData icon;

  const _StatCard(this.number, this.label, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a1a),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF00FF00).withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00FF00).withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: const Color(0xFF00FF00),
            size: 30,
          ),
          const SizedBox(height: 10),
          Text(
            number,
            style: GoogleFonts.orbitron(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF00FF00),
            ),
          ),
          Text(
            label,
            style: GoogleFonts.orbitron(
              fontSize: 12,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}
