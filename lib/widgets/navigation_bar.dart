import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomNavigationBar extends StatelessWidget {
  final Function(double) onSectionTap;

  const CustomNavigationBar({
    super.key,
    required this.onSectionTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 768;

    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 32 : 16,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF00FF00).withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo with neon effect
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF00FF00), width: 2),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00FF00).withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Text(
              '⚡ FALDY',
              style: GoogleFonts.orbitron(
                fontSize: isDesktop ? 24 : 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF00FF00),
              ),
            ),
          ),

          // Navigation Items for Desktop
          if (isDesktop)
            Row(
              children: [
                _NavItem('🏠 HOME', () => onSectionTap(0)),
                _NavItem('👤 ABOUT', () => onSectionTap(800)),
                _NavItem('🎮 PROJECTS', () => onSectionTap(1600)),
              ],
            )
          else
            // Mobile menu button
            _MobileMenuButton(onSectionTap: onSectionTap),
        ],
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const _NavItem(this.title, this.onTap);

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          margin: const EdgeInsets.only(left: 8),
          decoration: BoxDecoration(
            color: isHovered ? const Color(0xFF00FF00).withOpacity(0.1) : null,
            border: isHovered
                ? Border.all(color: const Color(0xFF00FF00), width: 1)
                : null,
            borderRadius: BorderRadius.circular(6),
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: const Color(0xFF00FF00).withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Text(
            widget.title,
            style: GoogleFonts.orbitron(
              fontSize: 14,
              color: isHovered ? const Color(0xFF00FF00) : Colors.white,
              fontWeight: isHovered ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileMenuButton extends StatefulWidget {
  final Function(double) onSectionTap;

  const _MobileMenuButton({required this.onSectionTap});

  @override
  State<_MobileMenuButton> createState() => _MobileMenuButtonState();
}

class _MobileMenuButtonState extends State<_MobileMenuButton> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.menu,
        color: Colors.white,
        size: 28,
      ),
      color: const Color(0xFF1A1A3A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onSelected: (value) {
        switch (value) {
          case 'Home':
            widget.onSectionTap(0);
            break;
          case 'About':
            widget.onSectionTap(800);
            break;
          case 'Projects':
            widget.onSectionTap(1600);
            break;
        }
      },
      itemBuilder: (context) => [
        'Home',
        'About',
        'Projects',
      ].map((String item) {
        return PopupMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }
}
