import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MarqueeText extends StatefulWidget {
  final String text;
  final double fontSize;
  final Color color;
  final Duration duration;

  const MarqueeText({
    super.key,
    required this.text,
    this.fontSize = 18,
    this.color = const Color(0xFF00FF00),
    this.duration = const Duration(seconds: 10),
  });

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: const Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: const Color(0xFF000000),
      child: ClipRect(
        child: SlideTransition(
          position: _animation,
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.text,
              style: GoogleFonts.orbitron(
                fontSize: widget.fontSize,
                color: widget.color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
