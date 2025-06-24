import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../games/tetris_game.dart';
import '../games/pong_game.dart';
import '../games/flappy_game.dart';

class GamesSection extends StatelessWidget {
  const GamesSection({super.key});

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
                'Mini Games',
                style: GoogleFonts.inter(
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
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'Built with Flutter & Flame Engine',
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 16 : 18,
                  color: Colors.grey[400],
                ),
              ),

              SizedBox(height: isMobile ? 40 : 60),

              // Games grid - Responsive
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isMobile ? 1 : (isDesktop ? 3 : 2),
                crossAxisSpacing: isMobile ? 0 : 24,
                mainAxisSpacing: 24,
                childAspectRatio: isMobile ? 1.2 : 0.8,
                children: [
                  _GameCard(
                    title: 'Tetris',
                    description:
                        'Classic block-stacking puzzle game with increasing difficulty.',
                    icon: Icons.view_module,
                    color: const Color(0xFF10B981),
                    onPlay: () =>
                        _navigateToGame(context, const TetrisGameScreen()),
                  ),
                  _GameCard(
                    title: 'Pong',
                    description:
                        'Retro ping-pong game with AI opponent and power-ups.',
                    icon: Icons.sports_tennis,
                    color: const Color(0xFF6366F1),
                    onPlay: () =>
                        _navigateToGame(context, const PongGameScreen()),
                  ),
                  _GameCard(
                    title: 'Flappy Bird',
                    description:
                        'Navigate through pipes in this challenging side-scroller.',
                    icon: Icons.flight,
                    color: const Color(0xFFF59E0B),
                    onPlay: () =>
                        _navigateToGame(context, const FlappyGameScreen()),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Game stats
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A4A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF6366F1).withOpacity(0.2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _GameStat('3', 'Games Available'),
                    _GameStat('60 FPS', 'Smooth Performance'),
                    _GameStat('100%', 'Flutter & Flame'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToGame(BuildContext context, Widget gameScreen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => gameScreen),
    );
  }
}

class _GameCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onPlay;

  const _GameCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onPlay,
  });

  @override
  State<_GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<_GameCard>
    with SingleTickerProviderStateMixin {
  bool isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
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
                color: const Color(0xFF0F0F23),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isHovered ? widget.color : Colors.transparent,
                  width: 2,
                ),
                boxShadow: [
                  if (isHovered)
                    BoxShadow(
                      color: widget.color.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: Column(
                children: [
                  // Game icon
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.color,
                            widget.color.withOpacity(0.7),
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          widget.icon,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  // Content
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            widget.title,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Expanded(
                            child: Text(
                              widget.description,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.grey[400],
                                height: 1.3,
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Play button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: widget.onPlay,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: widget.color,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Play Now',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
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

class _GameStat extends StatelessWidget {
  final String value;
  final String label;

  const _GameStat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF6366F1),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }
}
