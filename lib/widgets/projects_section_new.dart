import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

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
      color: const Color(0xFF0F0F23),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // Section title
              Text(
                'Featured Projects - Mini Games',
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

              // Projects grid - Responsive
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isMobile ? 1 : (isDesktop ? 2 : 1),
                crossAxisSpacing: isDesktop ? 30 : 20,
                mainAxisSpacing: isMobile ? 20 : 30,
                childAspectRatio: isMobile ? 0.7 : (isDesktop ? 1.0 : 0.8),
                children: [
                  _ProjectCard(
                    title: 'Snake Game',
                    description:
                        'Classic snake game with modern UI, high score tracking, and responsive controls.',
                    technologies: ['Flutter', 'Flame Engine', 'Game Logic'],
                    imageColor: const Color(0xFF00FF00),
                    gameIcon: Icons.sports_esports,
                    onPlayTap: () => Navigator.pushNamed(context, '/snake'),
                    onGithubTap: () =>
                        _launchURL('https://github.com/faldysanger/snake-game'),
                  ),
                  _ProjectCard(
                    title: 'Flappy Bird',
                    description:
                        'Fun flappy bird clone with physics, animations, and addictive gameplay.',
                    technologies: ['Flutter', 'Flame Engine', 'Physics'],
                    imageColor: const Color(0xFFFFFF00),
                    gameIcon: Icons.flight,
                    onPlayTap: () => Navigator.pushNamed(context, '/flappy'),
                    onGithubTap: () => _launchURL(
                        'https://github.com/faldysanger/flappy-game'),
                  ),
                  _ProjectCard(
                    title: 'Pong Game',
                    description:
                        'Classic pong game with AI opponent, score system, and smooth animations.',
                    technologies: ['Flutter', 'Flame Engine', 'AI'],
                    imageColor: const Color(0xFF00FFFF),
                    gameIcon: Icons.sports_tennis,
                    onPlayTap: () => Navigator.pushNamed(context, '/pong'),
                    onGithubTap: () =>
                        _launchURL('https://github.com/faldysanger/pong-game'),
                  ),
                  _ProjectCard(
                    title: 'Tetris Game',
                    description:
                        'Full-featured tetris with line clearing, levels, and classic tetris experience.',
                    technologies: ['Flutter', 'Flame Engine', 'Grid System'],
                    imageColor: const Color(0xFFFF00FF),
                    gameIcon: Icons.view_module,
                    onPlayTap: () => Navigator.pushNamed(context, '/tetris'),
                    onGithubTap: () => _launchURL(
                        'https://github.com/faldysanger/tetris-game'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}

class _ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final List<String> technologies;
  final Color imageColor;
  final IconData gameIcon;
  final VoidCallback? onPlayTap;
  final VoidCallback? onGithubTap;

  const _ProjectCard({
    required this.title,
    required this.description,
    required this.technologies,
    required this.imageColor,
    required this.gameIcon,
    this.onPlayTap,
    this.onGithubTap,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard>
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
      end: 1.02,
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
                color: const Color(0xFF1A1A3A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      isHovered ? const Color(0xFF00FF00) : Colors.transparent,
                  width: 2,
                ),
                boxShadow: [
                  if (isHovered)
                    BoxShadow(
                      color: const Color(0xFF00FF00).withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Game image placeholder
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.imageColor,
                          widget.imageColor.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        widget.gameIcon,
                        size: 50,
                        color: Colors.white,
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

                          const SizedBox(height: 8),

                          Expanded(
                            child: Text(
                              widget.description,
                              style: GoogleFonts.inter(
                                fontSize: isMobile ? 12 : 14,
                                color: Colors.grey[400],
                                height: 1.4,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Technologies
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: widget.technologies
                                .map((tech) => _TechChip(tech))
                                .toList(),
                          ),

                          const SizedBox(height: 16),

                          // Action buttons
                          Row(
                            children: [
                              if (widget.onPlayTap != null)
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: widget.onPlayTap,
                                    icon:
                                        const Icon(Icons.play_arrow, size: 18),
                                    label: Text(
                                      'Play Now',
                                      style: GoogleFonts.orbitron(
                                        fontSize: isMobile ? 12 : 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF00FF00),
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
                              if (widget.onPlayTap != null &&
                                  widget.onGithubTap != null)
                                const SizedBox(width: 8),
                              if (widget.onGithubTap != null)
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: widget.onGithubTap,
                                    icon: const Icon(Icons.code, size: 18),
                                    label: Text(
                                      'GitHub',
                                      style: GoogleFonts.orbitron(
                                        fontSize: isMobile ? 12 : 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: const Color(0xFF00FF00),
                                      side: const BorderSide(
                                        color: Color(0xFF00FF00),
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

class _TechChip extends StatelessWidget {
  final String technology;

  const _TechChip(this.technology);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF00FF00).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF00FF00).withOpacity(0.3),
        ),
      ),
      child: Text(
        technology,
        style: GoogleFonts.orbitron(
          fontSize: 12,
          color: const Color(0xFF00FF00),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
