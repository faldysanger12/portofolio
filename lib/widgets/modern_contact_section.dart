import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ModernContactSection extends StatelessWidget {
  const ModernContactSection({super.key});

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
            Color(0xFF000000),
          ],
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // Section title
              Text(
                'GET IN TOUCH',
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

              SizedBox(height: isMobile ? 20 : 30),

              Text(
                '💬 Ready to bring your ideas to life? Let\'s collaborate!',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 16 : 18,
                  color: Colors.grey[300],
                ),
              ),

              SizedBox(height: isMobile ? 40 : 60),

              // Contact methods
              isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),

              SizedBox(height: isMobile ? 40 : 60),

              // Footer
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF00FF00).withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Text(
                      '🚀 FALDY SANGER',
                      style: GoogleFonts.orbitron(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF00FF00),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Flutter Developer • Game Creator • Tech Enthusiast',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      '© 2024 All rights reserved',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Contact info
        Expanded(
          child: _buildContactInfo(),
        ),

        const SizedBox(width: 60),

        // Contact form
        Expanded(
          child: _buildContactForm(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildContactInfo(),
        const SizedBox(height: 40),
        _buildContactForm(),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📞 Contact Information',
          style: GoogleFonts.orbitron(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFFFF00),
          ),
        ),

        const SizedBox(height: 30),

        // Contact methods
        _ContactItem(
          icon: Icons.email,
          title: 'Email',
          value: 'faldysanger1@gmail.com',
          onTap: () => _launchURL('mailto:faldysanger1@gmail.com'),
        ),

        _ContactItem(
          icon: Icons.phone,
          title: 'Phone',
          value: '+62 895-6328-68733',
          onTap: () => _launchURL('tel:+6289563286733'),
        ),

        _ContactItem(
          icon: Icons.location_on,
          title: 'Location',
          value: 'Indonesia',
          onTap: null,
        ),

        const SizedBox(height: 30),

        // Social media
        Text(
          '🌐 Follow Me',
          style: GoogleFonts.orbitron(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF00FF00),
          ),
        ),

        const SizedBox(height: 20),

        Row(
          children: [
            _SocialButton(
              icon: Icons.code,
              label: 'GitHub',
              color: const Color(0xFF333333),
              onTap: () => _launchURL('https://github.com/faldysanger12'),
            ),
            const SizedBox(width: 15),
            _SocialButton(
              icon: Icons.work,
              label: 'LinkedIn',
              color: const Color(0xFF0077B5),
              onTap: () => _launchURL('https://linkedin.com/in/valdi-sanger'),
            ),
            const SizedBox(width: 15),
            _SocialButton(
              icon: Icons.alternate_email,
              label: 'Twitter',
              color: const Color(0xFF1DA1F2),
              onTap: () => _launchURL('https://twitter.com/valdi_sanger'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactForm() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a1a),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF00FF00).withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00FF00).withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💌 Send Message',
            style: GoogleFonts.orbitron(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFFFF00),
            ),
          ),

          const SizedBox(height: 30),

          // Form fields
          _CustomTextField(
            label: 'Name',
            icon: Icons.person,
          ),

          const SizedBox(height: 20),

          _CustomTextField(
            label: 'Email',
            icon: Icons.email,
          ),

          const SizedBox(height: 20),

          _CustomTextField(
            label: 'Subject',
            icon: Icons.subject,
          ),

          const SizedBox(height: 20),

          _CustomTextField(
            label: 'Message',
            icon: Icons.message,
            maxLines: 4,
          ),

          const SizedBox(height: 30),

          // Send button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Handle form submission
                _showThankYouDialog();
              },
              icon: const Icon(Icons.send),
              label: Text(
                'SEND MESSAGE',
                style: GoogleFonts.orbitron(
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00FF00),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Could not launch $url: $e');
    }
  }

  void _showThankYouDialog() {
    // This would typically be implemented in the widget tree
    // For now, just print a message
    debugPrint('Thank you message would be shown here');
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  const _ContactItem({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF1a1a1a),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFF00FF00).withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF00FF00).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF00FF00),
                size: 20,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.orbitron(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF00FF00),
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.orbitron(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final int maxLines;

  const _CustomTextField({
    required this.label,
    required this.icon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      style: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(
          color: Colors.grey[400],
        ),
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF00FF00),
          size: 20,
        ),
        filled: true,
        fillColor: const Color(0xFF0a0a0a),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: const Color(0xFF00FF00).withOpacity(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: const Color(0xFF00FF00).withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFF00FF00),
            width: 2,
          ),
        ),
      ),
    );
  }
}
