import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../games/tetris_game.dart';
import '../games/snake_game.dart';
import '../games/flappy_game.dart';
import '../games/pong_game.dart';
import '../games/game_2048.dart';
import '../games/memory_game.dart';

class ModernProjectsSection extends StatelessWidget {
  const ModernProjectsSection({super.key});

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
            Color(0xFF0a0a0a),
            Color(0xFF1a1a1a),
            Color(0xFF0a0a0a),
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
                'MINI GAMES',
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

              // Projects grid
              AnimationLimiter(
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: isMobile ? 1 : (isDesktop ? 3 : 2),
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 30,
                  childAspectRatio: isMobile ? 0.8 : 0.75,
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 600),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(child: widget),
                    ),
                    children: [
                      const _ProjectCard(
                        title: 'Tetris Game',
                        description:
                            'Classic Tetris game built with Flutter. Features smooth controls, scoring system, and increasing difficulty levels.',
                        technologies: ['Flutter', 'CustomPainter', 'Animation'],
                        gradientColors: [
                          Color(0xFF9C27B0),
                          Color(0xFF673AB7),
                        ],
                        icon: Icons.games,
                        isGame: true,
                        gameType: 'tetris',
                        codeUrl: 'https://github.com/faldysanger12/portofolio',
                      ),
                      const _ProjectCard(
                        title: 'Snake Game',
                        description:
                            'Classic Snake game with retro graphics. Eat food to grow longer and avoid hitting walls or yourself.',
                        technologies: ['Flutter', 'GameLogic', 'Timer'],
                        gradientColors: [
                          Color(0xFF00FF00),
                          Color(0xFF00AA00),
                        ],
                        icon: Icons.gamepad,
                        isGame: true,
                        gameType: 'snake',
                        codeUrl: 'https://github.com/faldysanger12/portofolio',
                      ),
                      const _ProjectCard(
                        title: 'Flappy Bird Game',
                        description:
                            'Addictive mobile game inspired by Flappy Bird. Tap to fly and avoid obstacles in this endless runner.',
                        technologies: ['Flutter', 'Physics', 'Animation'],
                        gradientColors: [
                          Color(0xFF00FFFF),
                          Color(0xFF0088FF),
                        ],
                        icon: Icons.flight,
                        isGame: true,
                        gameType: 'flappy',
                        codeUrl: 'https://github.com/faldysanger12/portofolio',
                      ),
                      const _ProjectCard(
                        title: 'Pong Game',
                        description:
                            'Classic Pong arcade game. Control your paddle and try to score against the AI opponent.',
                        technologies: ['Flutter', 'AI', 'Physics'],
                        gradientColors: [
                          Color(0xFFFF6B00),
                          Color(0xFFFF4400),
                        ],
                        icon: Icons.sports_tennis,
                        isGame: true,
                        gameType: 'pong',
                        codeUrl: 'https://github.com/faldysanger12/portofolio',
                      ),
                      const _ProjectCard(
                        title: '2048 Game',
                        description:
                            'Popular puzzle game where you combine tiles to reach 2048. Simple rules but challenging gameplay.',
                        technologies: ['Flutter', 'Logic', 'Gestures'],
                        gradientColors: [
                          Color(0xFFFFFF00),
                          Color(0xFFFFAA00),
                        ],
                        icon: Icons.grid_4x4,
                        isGame: true,
                        gameType: '2048',
                        codeUrl: 'https://github.com/faldysanger12/portofolio',
                      ),
                      const _ProjectCard(
                        title: 'Memory Game',
                        description:
                            'Test your memory with this card matching game. Flip cards and find matching pairs to win.',
                        technologies: ['Flutter', 'Memory', 'Cards'],
                        gradientColors: [
                          Color(0xFFFF00FF),
                          Color(0xFFAA00FF),
                        ],
                        icon: Icons.psychology,
                        isGame: true,
                        gameType: 'memory',
                        codeUrl: 'https://github.com/faldysanger12/portofolio',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final List<String> technologies;
  final List<Color> gradientColors;
  final IconData icon;
  final String codeUrl;
  final bool isGame;
  final String? gameType;

  const _ProjectCard({
    required this.title,
    required this.description,
    required this.technologies,
    required this.gradientColors,
    required this.icon,
    required this.codeUrl,
    this.isGame = false,
    this.gameType,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.03,
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

  void _showGameDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black87,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.gradientColors.first,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.gradientColors.first.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: widget.gradientColors.first,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: GoogleFonts.orbitron(
                        color: widget.gradientColors.first,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        color: widget.gradientColors.first,
                      ),
                    ),
                  ],
                ),
              ),
              // Game content
              Expanded(
                child: widget.gameType == 'tetris'
                    ? const TetrisGame()
                    : widget.gameType == 'snake'
                        ? const SnakeGame()
                        : widget.gameType == 'flappy'
                            ? const FlappyGame()
                            : widget.gameType == 'pong'
                                ? const PongGame()
                                : widget.gameType == '2048'
                                    ? const Game2048()
                                    : widget.gameType == 'memory'
                                        ? const MemoryGame()
                                        : Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  widget.icon,
                                                  size: 100,
                                                  color: widget
                                                      .gradientColors.first,
                                                ),
                                                const SizedBox(height: 20),
                                                Text(
                                                  'Game Demo',
                                                  style: GoogleFonts.orbitron(
                                                    fontSize: 28,
                                                    fontWeight: FontWeight.bold,
                                                    color: widget
                                                        .gradientColors.first,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  'Interactive demo coming soon!',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 16,
                                                    color: Colors.grey[400],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
              ),
            ],
          ),
        ),
      ),
    );
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
                color: const Color(0xFF1a1a1a),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isHovered
                      ? widget.gradientColors.first
                      : Colors.transparent,
                  width: 2,
                ),
                boxShadow: [
                  if (isHovered)
                    BoxShadow(
                      color: widget.gradientColors.first.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Project header with icon
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: widget.gradientColors,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        widget.icon,
                        size: 60,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  // Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: GoogleFonts.orbitron(
                              fontSize: isMobile ? 18 : 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Expanded(
                            child: Text(
                              widget.description,
                              style: GoogleFonts.inter(
                                fontSize: isMobile ? 12 : 14,
                                color: Colors.grey[400],
                                height: 1.5,
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Technologies
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.technologies
                                .map((tech) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: widget.gradientColors.first
                                            .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: widget.gradientColors.first
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                      child: Text(
                                        tech,
                                        style: GoogleFonts.orbitron(
                                          fontSize: 10,
                                          color: widget.gradientColors.first,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),

                          const SizedBox(height: 20),

                          // Action buttons
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: widget.isGame
                                      ? _showGameDialog
                                      : () => _launchURL(widget.codeUrl),
                                  icon: Icon(
                                    widget.isGame
                                        ? Icons.play_arrow
                                        : Icons.launch,
                                    size: 16,
                                  ),
                                  label: Text(
                                    widget.isGame ? 'PLAY' : 'DEMO',
                                    style: GoogleFonts.orbitron(
                                      fontSize: isMobile ? 10 : 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        widget.gradientColors.first,
                                    foregroundColor: Colors.black,
                                    padding: EdgeInsets.symmetric(
                                      vertical: isMobile ? 8 : 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => _launchURL(widget.codeUrl),
                                  icon: const Icon(Icons.code, size: 16),
                                  label: Text(
                                    'CODE',
                                    style: GoogleFonts.orbitron(
                                      fontSize: isMobile ? 10 : 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor:
                                        widget.gradientColors.first,
                                    side: BorderSide(
                                      color: widget.gradientColors.first,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: isMobile ? 8 : 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
