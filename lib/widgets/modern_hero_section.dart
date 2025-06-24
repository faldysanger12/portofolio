import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class ModernHeroSection extends StatefulWidget {
  const ModernHeroSection({super.key});

  @override
  State<ModernHeroSection> createState() => _ModernHeroSectionState();
}

class _ModernHeroSectionState extends State<ModernHeroSection>
    with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _fadeController;
  late Animation<double> _floatingAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _floatingAnimation = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;
    final isMobile = size.width < 600;

    return Container(
      height: size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF000000),
            Color(0xFF1a1a1a),
            Color(0xFF000000),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Animated background particles
          ...List.generate(30, (index) => _AnimatedParticle(index)),

          // Grid pattern overlay
          _buildGridPattern(),

          // Main content
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20 : 40,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile avatar with glow effect
                    AnimatedBuilder(
                      animation: _floatingAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _floatingAnimation.value),
                          child: Container(
                            width: isMobile ? 120 : 150,
                            height: isMobile ? 120 : 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF00FF00),
                                  Color(0xFF00DD00),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF00FF00).withOpacity(0.6),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/profilePicture.jpg',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.person,
                                    size: 80,
                                    color: Colors.black,
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: isMobile ? 30 : 40),

                    // Animated name
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF00FF00),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00FF00).withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Text(
                        'FALDY SANGER',
                        style: GoogleFonts.orbitron(
                          fontSize: isMobile ? 28 : (isDesktop ? 48 : 36),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF00FF00),
                          letterSpacing: 2,
                        ),
                      ),
                    ),

                    SizedBox(height: isMobile ? 20 : 30),

                    // Animated text kit for titles
                    SizedBox(
                      height: isMobile ? 60 : 80,
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            '🚀 Flutter Developer',
                            textStyle: GoogleFonts.orbitron(
                              fontSize: isMobile ? 16 : (isDesktop ? 24 : 20),
                              color: const Color(0xFFFFFF00),
                              fontWeight: FontWeight.w600,
                            ),
                            speed: const Duration(milliseconds: 100),
                          ),
                          TypewriterAnimatedText(
                            '🎮 Game Creator',
                            textStyle: GoogleFonts.orbitron(
                              fontSize: isMobile ? 16 : (isDesktop ? 24 : 20),
                              color: const Color(0xFFFFFF00),
                              fontWeight: FontWeight.w600,
                            ),
                            speed: const Duration(milliseconds: 100),
                          ),
                          TypewriterAnimatedText(
                            '⚡ Speed Coder',
                            textStyle: GoogleFonts.orbitron(
                              fontSize: isMobile ? 16 : (isDesktop ? 24 : 20),
                              color: const Color(0xFFFFFF00),
                              fontWeight: FontWeight.w600,
                            ),
                            speed: const Duration(milliseconds: 100),
                          ),
                        ],
                        totalRepeatCount: 3,
                        pause: const Duration(milliseconds: 1000),
                        displayFullTextOnTap: true,
                        stopPauseOnTap: true,
                      ),
                    ),

                    SizedBox(height: isMobile ? 20 : 30),

                    // Description with cool effect
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: isMobile ? size.width - 40 : 600,
                      ),
                      child: Text(
                        '💫 Crafting digital experiences that push boundaries. Building lightning-fast mobile apps, interactive web platforms, and mind-blowing mini-games that captivate users worldwide.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: isMobile ? 14 : 16,
                          color: Colors.grey[300],
                          height: 1.8,
                        ),
                      ),
                    ),

                    SizedBox(height: isMobile ? 40 : 60),

                    // CTA Buttons
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: [
                        _ModernButton(
                          '� PLAY GAMES',
                          const Color(0xFF00FF00),
                          () {},
                        ),
                        _ModernButton(
                          '🎮 PLAY GAMES',
                          Colors.transparent,
                          () {},
                          outlined: true,
                        ),
                        _ModernButton(
                          '📧 CONTACT',
                          const Color(0xFFFF6B00),
                          () {},
                        ),
                      ],
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

  Widget _buildGridPattern() {
    return Positioned.fill(
      child: CustomPaint(
        painter: GridPainter(),
      ),
    );
  }
}

class _AnimatedParticle extends StatefulWidget {
  final int index;

  const _AnimatedParticle(this.index);

  @override
  State<_AnimatedParticle> createState() => _AnimatedParticleState();
}

class _AnimatedParticleState extends State<_AnimatedParticle>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double left;
  late double top;
  late double size;
  late Color color;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 2000 + (widget.index * 100)),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    left = (widget.index * 47.0) % 100;
    top = (widget.index * 31.0) % 100;
    size = 2.0 + (widget.index % 3);

    final colors = [
      const Color(0xFF00FF00),
      const Color(0xFFFFFF00),
      const Color(0xFF00FFFF),
      const Color(0xFFFF00FF),
    ];
    color = colors[widget.index % colors.length];
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
          left: screenSize.width * left / 100,
          top: screenSize.height * top / 100,
          child: Opacity(
            opacity: 0.3 + (_animation.value * 0.7),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 6,
                    spreadRadius: 1,
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

class _ModernButton extends StatefulWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;
  final bool outlined;

  const _ModernButton(
    this.text,
    this.color,
    this.onPressed, {
    this.outlined = false,
  });

  @override
  State<_ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<_ModernButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return MouseRegion(
      onEnter: (_) {
        setState(() => isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => isHovered = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: isHovered
                    ? [
                        BoxShadow(
                          color: widget.outlined
                              ? const Color(0xFFFFFF00).withOpacity(0.5)
                              : widget.color.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ]
                    : null,
              ),
              child: ElevatedButton(
                onPressed: widget.onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      widget.outlined ? Colors.transparent : widget.color,
                  foregroundColor:
                      widget.outlined ? const Color(0xFFFFFF00) : Colors.black,
                  side: widget.outlined
                      ? const BorderSide(color: Color(0xFFFFFF00), width: 2)
                      : BorderSide(color: widget.color, width: 2),
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 24 : 32,
                    vertical: isMobile ? 16 : 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  widget.text,
                  style: GoogleFonts.orbitron(
                    fontSize: isMobile ? 12 : 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00FF00).withOpacity(0.1)
      ..strokeWidth = 1;

    const gridSize = 50.0;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
