import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;
    final isMobile = size.width < 600;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : (isDesktop ? 32 : 24),
        vertical: isMobile ? 60 : 100,
      ),
      color: const Color(0xFF1A1A3A),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // Section title
              Text(
                'Tentang Saya',
                style: GoogleFonts.orbitron(
                  fontSize: isMobile ? 32 : (isDesktop ? 48 : 40),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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

              // Content - Responsive layout
              isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left side - Profile photo
                        Expanded(
                          flex: 1,
                          child: _buildProfileColumn(context),
                        ),
                        const SizedBox(width: 60),
                        // Right side - Bio
                        Expanded(
                          flex: 2,
                          child: _buildBioColumn(context),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        _buildProfileColumn(context),
                        SizedBox(height: isMobile ? 40 : 60),
                        _buildBioColumn(context),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileColumn(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Column(
      children: [
        // Placeholder for photo - you can add your photo here
        Container(
          width: isMobile ? 200 : 250,
          height: isMobile ? 200 : 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF00FF00),
              width: 3,
            ),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1A1A3A),
                Color(0xFF2A2A4A),
              ],
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(17),
            child: Image.asset(
              'assets/images/profilePicture.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.person,
                  size: 100,
                  color: Color(0xFF00FF00),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 24),

        Text(
          'Faldy Sanger',
          style: GoogleFonts.orbitron(
            fontSize: isMobile ? 24 : 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF00FF00),
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Flutter Developer',
          style: GoogleFonts.orbitron(
            fontSize: isMobile ? 16 : 18,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildBioColumn(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profil Saya',
          style: GoogleFonts.orbitron(
            fontSize: isMobile ? 24 : 32,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF00FF00),
          ),
        ),
        const SizedBox(height: 24),
        _buildBioItem('Nama', 'Faldy Sanger', context),
        _buildBioItem('Tempat, Tanggal Lahir',
            'Manado, 14 Juni 2002 (23 Tahun)', context),
        _buildBioItem(
            'Alamat', 'Jalan 17 Agustus, Bumi Beringin, Lingkungan 5', context),
        _buildBioItem('Hobi', 'Otomotif', context),
        const SizedBox(height: 32),
        Text(
          'Tentang Saya',
          style: GoogleFonts.orbitron(
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF00FF00),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Saya adalah seorang developer Flutter yang bersemangat dengan minat besar dalam dunia otomotif. Dengan usia 23 tahun, saya menggabungkan passion teknologi dan otomotif untuk menciptakan aplikasi yang inovatif dan menarik. Saya senang belajar teknologi baru dan mengembangkan solusi kreatif untuk berbagai tantangan.',
          style: GoogleFonts.inter(
            fontSize: isMobile ? 14 : 16,
            height: 1.6,
            color: Colors.white.withOpacity(0.9),
          ),
        ),

        const SizedBox(height: 32),

        // Gallery Section
        Text(
          'Gallery',
          style: GoogleFonts.orbitron(
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF00FF00),
          ),
        ),

        const SizedBox(height: 16),

        _buildGallery(context),
      ],
    );
  }

  Widget _buildBioItem(String label, String value, BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: isMobile ? 80 : 120,
            child: Text(
              '$label:',
              style: GoogleFonts.orbitron(
                fontSize: isMobile ? 12 : 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF00FF00),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: isMobile ? 12 : 14,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGallery(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isMobile ? 2 : 3,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildGalleryItem('assets/images/1.jpg', context),
        _buildGalleryItem('assets/images/2.jpg', context),
        _buildGalleryItem('assets/images/3.jpg', context),
      ],
    );
  }

  Widget _buildGalleryItem(String imagePath, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF00FF00).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: const Color(0xFF2A2A4A),
              child: const Icon(
                Icons.image,
                color: Color(0xFF00FF00),
                size: 50,
              ),
            );
          },
        ),
      ),
    );
  }
}
