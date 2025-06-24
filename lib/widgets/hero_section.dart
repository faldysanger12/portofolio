import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback? onViewProjectsTap;

  const HeroSection({super.key, this.onViewProjectsTap});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;
    final isMobile = size.width < 600;

    return Container(
      height: size.height,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : (isDesktop ? 32 : 24),
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF000000),
            Color(0xFF111111),
            Color(0xFF000000),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Racing stripes effect
          ...List.generate(
              10,
              (index) => Positioned(
                    left: index * (size.width / 10),
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            const Color(0xFF00FF00).withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  )),

          // Animated neon particles
          ...List.generate(isMobile ? 15 : 30, (index) => _NeonParticle(index)),

          // Main content
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Helmet/Motor icon with neon effect
                    Container(
                      width: isMobile ? 120 : 150,
                      height: isMobile ? 120 : 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00FF00), Color(0xFF00DD00)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00FF00).withOpacity(0.5),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.motorcycle,
                        size: isMobile ? 60 : 80,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(height: isMobile ? 24 : 32),

                    // Name with neon effect
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xFF00FF00), width: 2),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00FF00).withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: Text(
                        '⚡ FALDY ⚡',
                        style: GoogleFonts.orbitron(
                          fontSize: isMobile ? 36 : (isDesktop ? 56 : 48),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF00FF00),
                        ),
                      ),
                    ),

                    SizedBox(height: isMobile ? 12 : 16),

                    // Title with racing theme
                    Text(
                      '🏍️ STREET CODER & SPEED DEMON 🏍️',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.orbitron(
                        fontSize: isMobile ? 16 : (isDesktop ? 20 : 18),
                        color: const Color(0xFFFFFF00), // Yellow neon
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: isMobile ? 16 : 24),

                    // Description with motor theme
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: isMobile ? size.width - 32 : 600,
                      ),
                      child: Text(
                        '💨 Coding at full throttle! Building lightning-fast mobile apps and web experiences with Flutter. When I\'m not burning rubber on code, I\'m crafting high-octane mini-games that\'ll blow your mind! 💨',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.orbitron(
                          fontSize: isMobile ? 14 : 16,
                          color: Colors.grey[300],
                          height: 1.6,
                        ),
                      ),
                    ),

                    SizedBox(height: isMobile ? 32 : 48),

                    // CTA Button - only View Projects
                    Center(
                      child: _CTAButton(
                        '🏁 VIEW PROJECTS',
                        const Color(0xFF00FF00),
                        widget.onViewProjectsTap ?? () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NeonParticle extends StatefulWidget {
  final int index;

  const _NeonParticle(this.index);

  @override
  State<_NeonParticle> createState() => _NeonParticleState();
}

class _NeonParticleState extends State<_NeonParticle>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double left;
  late double top;
  late double size;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500 + (widget.index * 100)),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(_controller);

    left = (widget.index * 37.0) % 100;
    top = (widget.index * 23.0) % 100;
    size = 3.0 + (widget.index % 4);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          left: (screenSize.width * left / 100) + (_animation.value * 30),
          top: (screenSize.height * top / 100) + (_animation.value * 40),
          child: Opacity(
            opacity: 0.4 + (_animation.value * 0.6),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: const Color(0xFF00FF00),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00FF00).withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CTAButton extends StatefulWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const _CTAButton(
    this.text,
    this.color,
    this.onPressed,
  );

  @override
  State<_CTAButton> createState() => _CTAButtonState();
}

class _CTAButtonState extends State<_CTAButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(isHovered ? 1.05 : 1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: isHovered
              ? [
                  BoxShadow(
                    color: widget.color.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 3,
                  ),
                ]
              : null,
        ),
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.color,
            foregroundColor: Colors.black,
            side: BorderSide(color: widget.color, width: 2),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 28,
              vertical: isMobile ? 12 : 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          child: Text(
            widget.text,
            style: GoogleFonts.orbitron(
              fontSize: isMobile ? 12 : 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
