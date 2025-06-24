import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModernNavigationBar extends StatefulWidget {
  final Function(String) onNavigate;

  const ModernNavigationBar({
    super.key,
    required this.onNavigate,
  });

  @override
  State<ModernNavigationBar> createState() => _ModernNavigationBarState();
}

class _ModernNavigationBarState extends State<ModernNavigationBar> {
  String _selectedSection = 'home';

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color(0xFF00FF00).withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00FF00).withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: isMobile ? _buildMobileNav() : _buildDesktopNav(),
    );
  }

  Widget _buildDesktopNav() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo
        Text(
          'FALDY',
          style: GoogleFonts.orbitron(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF00FF00),
          ),
        ),

        // Navigation items
        Row(
          children: [
            _NavItem('HOME', 'home'),
            _NavItem('ABOUT', 'about'),
            _NavItem('GAMES', 'projects'),
            _NavItem('CONTACT', 'contact'),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileNav() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo
        Text(
          'FALDY',
          style: GoogleFonts.orbitron(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF00FF00),
          ),
        ),

        // Menu button
        PopupMenuButton<String>(
          icon: const Icon(
            Icons.menu,
            color: Color(0xFF00FF00),
          ),
          color: Colors.black,
          onSelected: (value) {
            setState(() => _selectedSection = value);
            widget.onNavigate(value);
          },
          itemBuilder: (context) => [
            _buildMenuItem('HOME', 'home'),
            _buildMenuItem('ABOUT', 'about'),
            _buildMenuItem('GAMES', 'projects'),
            _buildMenuItem('CONTACT', 'contact'),
          ],
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(String title, String value) {
    return PopupMenuItem<String>(
      value: value,
      child: Text(
        title,
        style: GoogleFonts.orbitron(
          color: _selectedSection == value
              ? const Color(0xFF00FF00)
              : Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _NavItem(String title, String section) {
    final isSelected = _selectedSection == section;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedSection = section);
        widget.onNavigate(section);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF00FF00).withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: const Color(0xFF00FF00), width: 1)
              : null,
        ),
        child: Text(
          title,
          style: GoogleFonts.orbitron(
            color: isSelected ? const Color(0xFF00FF00) : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
