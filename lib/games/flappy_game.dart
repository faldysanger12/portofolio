import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:async';

class FlappyGame extends StatefulWidget {
  const FlappyGame({super.key});

  @override
  State<FlappyGame> createState() => _FlappyGameState();
}

class _FlappyGameState extends State<FlappyGame> with TickerProviderStateMixin {
  static const double gravity = 0.4;
  static const double jumpPower = -8;
  static const double pipeWidth = 80;
  static const double pipeGap = 160;
  static const double groundHeight = 100;

  late AnimationController _controller;
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;
  Timer? gameTimer;

  double birdY = 0;
  double birdVelocity = 0;
  bool isGameRunning = false;
  bool isGameStarted = false;
  int score = 0;
  int bestScore = 0;

  List<Map<String, double>> pipes = [];
  double pipeX = 400;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _backgroundAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_backgroundController);

    _resetGame();
  }

  @override
  void dispose() {
    _controller.dispose();
    _backgroundController.dispose();
    gameTimer?.cancel();
    super.dispose();
  }

  void _resetGame() {
    setState(() {
      birdY = 0;
      birdVelocity = 0;
      isGameRunning = false;
      isGameStarted = false;
      score = 0;
      pipes.clear();
      pipeX = 400;
    });
    _generatePipes();
  }

  void _generatePipes() {
    pipes.clear();
    for (int i = 0; i < 3; i++) {
      double centerY = Random().nextDouble() * 200 - 100;
      pipes.add({
        'x': 400.0 + (i * 300),
        'centerY': centerY,
        'scored': 0.0, // 0 = not scored, 1 = scored
      });
    }
  }

  void _startGame() {
    if (!isGameRunning) {
      setState(() {
        isGameRunning = true;
        isGameStarted = true;
      });

      gameTimer = Timer.periodic(const Duration(milliseconds: 12), (timer) {
        _updateGame();
      });
    }
  }

  void _jump() {
    if (!isGameStarted) {
      _startGame();
    }

    if (isGameRunning) {
      setState(() {
        birdVelocity = jumpPower;
      });

      // Wing flap animation
      _controller.forward().then((_) {
        _controller.reverse();
      });
    }
  }

  void _updateGame() {
    setState(() {
      // Update bird physics
      birdVelocity += gravity;
      birdY += birdVelocity;

      // Move pipes
      for (var pipe in pipes) {
        pipe['x'] = pipe['x']! - 3;
      }

      // Remove pipes that are off screen and add new ones
      pipes.removeWhere((pipe) => pipe['x']! < -pipeWidth);

      if (pipes.isNotEmpty && pipes.last['x']! < 100) {
        double centerY = Random().nextDouble() * 200 - 100;
        pipes.add({
          'x': pipes.last['x']! + 300,
          'centerY': centerY,
          'scored': 0.0,
        });
      }

      // Check scoring
      for (var pipe in pipes) {
        if (pipe['scored'] == 0 && pipe['x']! < -40) {
          pipe['scored'] = 1;
          score++;
        }
      }

      // Check collisions
      _checkCollisions();
    });
  }

  void _checkCollisions() {
    // Ground and ceiling collision
    if (birdY > 150 || birdY < -200) {
      _gameOver();
      return;
    }

    // Pipe collision
    for (var pipe in pipes) {
      double pipeLeft = pipe['x']!;
      double pipeRight = pipe['x']! + pipeWidth;
      double pipeCenterY = pipe['centerY']!;
      double pipeTop = pipeCenterY - pipeGap / 2;
      double pipeBottom = pipeCenterY + pipeGap / 2;

      // Check if bird is in pipe's X range
      if (pipeLeft < 40 && pipeRight > -40) {
        // Check if bird is not in the gap
        if (birdY < pipeTop || birdY > pipeBottom) {
          _gameOver();
          return;
        }
      }
    }
  }

  void _gameOver() {
    gameTimer?.cancel();
    setState(() {
      isGameRunning = false;
      if (score > bestScore) {
        bestScore = score;
      }
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.orange, width: 2),
        ),
        title: const Text(
          '💥 GAME OVER',
          style: TextStyle(
            color: Colors.orange,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.flight, size: 50, color: Colors.orange),
            const SizedBox(height: 10),
            Text(
              'Score: $score',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            Text(
              'Best: $bestScore',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _resetGame();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('RETRY'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.orange),
                    foregroundColor: Colors.orange,
                  ),
                  child: const Text('EXIT'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0B),
      appBar: AppBar(
        title: const Text('Flappy Bird',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1A1A1D),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: _jump,
        child: KeyboardListener(
          focusNode: FocusNode()..requestFocus(),
          onKeyEvent: (event) {
            if (event is KeyDownEvent &&
                (event.logicalKey == LogicalKeyboardKey.space ||
                    event.logicalKey == LogicalKeyboardKey.arrowUp)) {
              _jump();
            }
          },
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0A0A0B),
                  Color(0xFF1A1A1D),
                  Color(0xFF0F2027),
                  Color(0xFF203A43),
                ],
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Stack(
                      children: [
                        // Background
                        _buildBackground(),

                        // Pipes
                        ..._buildPipes(),

                        // Ground
                        _buildGround(),

                        // Bird
                        _buildBird(),

                        // UI
                        _buildUI(),

                        // Instructions
                        if (!isGameStarted) _buildInstructions(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF203A43), // Dark blue-green
                Color(0xFF2C5F77), // Medium blue
                Color(0xFF0F2027), // Very dark
              ],
            ),
          ),
          child: CustomPaint(
            size: Size.infinite,
            painter: CloudPainter(animation: _backgroundAnimation.value),
          ),
        );
      },
    );
  }

  List<Widget> _buildPipes() {
    return pipes.map((pipe) {
      return Positioned(
        left: pipe['x'],
        child: Column(
          children: [
            // Top pipe
            Container(
              width: pipeWidth,
              height: 200 + pipe['centerY']! - pipeGap / 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.teal[400]!,
                    Colors.teal[600]!,
                    Colors.teal[800]!,
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
                border: Border.all(color: Colors.teal[900]!, width: 3),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 15,
                    offset: const Offset(4, 4),
                  ),
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(-2, -2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Pipe cap
                  Positioned(
                    bottom: 0,
                    left: -5,
                    right: -5,
                    child: Container(
                      height: 25,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.teal[300]!, Colors.teal[600]!],
                        ),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.teal[900]!, width: 2),
                      ),
                    ),
                  ),
                  // Highlight
                  Positioned(
                    left: 8,
                    top: 10,
                    child: Container(
                      width: 8,
                      height: (200 + pipe['centerY']! - pipeGap / 2) - 40,
                      decoration: BoxDecoration(
                        color: Colors.teal[200]!.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Gap
            SizedBox(height: pipeGap),

            // Bottom pipe
            Container(
              width: pipeWidth,
              height: 200 - pipe['centerY']! - pipeGap / 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.teal[400]!,
                    Colors.teal[600]!,
                    Colors.teal[800]!,
                  ],
                  stops: const [0.0, 0.3, 1.0],
                ),
                border: Border.all(color: Colors.teal[900]!, width: 3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 15,
                    offset: const Offset(4, 4),
                  ),
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(-2, -2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Pipe cap
                  Positioned(
                    top: 0,
                    left: -5,
                    right: -5,
                    child: Container(
                      height: 25,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.teal[300]!, Colors.teal[600]!],
                        ),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.teal[900]!, width: 2),
                      ),
                    ),
                  ),
                  // Highlight
                  Positioned(
                    left: 8,
                    top: 30,
                    child: Container(
                      width: 8,
                      height: (200 - pipe['centerY']! - pipeGap / 2) - 40,
                      decoration: BoxDecoration(
                        color: Colors.teal[200]!.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildGround() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: groundHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.brown[800]!,
              Colors.brown[600]!,
              Colors.brown[400]!,
            ],
          ),
          border: Border(
            top: BorderSide(color: Colors.brown[900]!, width: 3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.brown[500]!.withOpacity(0.8),
            border: Border(
              top: BorderSide(color: Colors.brown[700]!, width: 2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBird() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: 50,
          top: MediaQuery.of(context).size.height / 2 + birdY - 50,
          child: Transform.rotate(
            angle: (birdVelocity / 8).clamp(-0.6, 0.6),
            child: Container(
              width: 45,
              height: 35,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.orange[300]!,
                    Colors.orange[500]!,
                    Colors.orange[700]!,
                  ],
                ),
                border: Border.all(color: Colors.orange[800]!, width: 2),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 12,
                    offset: const Offset(4, 4),
                  ),
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(-2, -2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Body highlight
                  Positioned(
                    left: 8,
                    top: 6,
                    child: Container(
                      width: 15,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.orange[100]!.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  // Eye white
                  Positioned(
                    right: 8,
                    top: 6,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 2,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Eye pupil
                  Positioned(
                    right: 10,
                    top: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Beak
                  Positioned(
                    right: -4,
                    top: 14,
                    child: Container(
                      width: 12,
                      height: 8,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.deepOrange[400]!,
                            Colors.deepOrange[700]!
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(6),
                          bottomRight: Radius.circular(6),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 3,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Wing with smooth animation
                  Positioned(
                    left: 6,
                    top: 10,
                    child: Transform.rotate(
                      angle: (_controller.value - 0.5) * 1.2,
                      child: Container(
                        width: 18,
                        height: 12,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.orange[500]!, Colors.orange[700]!],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 3,
                              offset: const Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Score
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.grey[900]!.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.orange.withOpacity(0.7), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Text(
                    'Score: $score',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Best score
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.grey[900]!.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.yellow.withOpacity(0.7), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.yellow.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Text(
                    'Best: $bestScore',
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Control buttons
            if (MediaQuery.of(context).size.width < 600)
              Container(
                margin: const EdgeInsets.only(bottom: 120),
                child: ElevatedButton(
                  onPressed: _jump,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.flight_takeoff),
                      SizedBox(width: 8),
                      Text(
                        'FLY',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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
  }

  Widget _buildInstructions() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(30),
        margin: const EdgeInsets.symmetric(horizontal: 40),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.orange, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.flight,
              size: 60,
              color: Colors.orange,
            ),
            const SizedBox(height: 20),
            const Text(
              'FLAPPY BIRD',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tap to fly and avoid the pipes!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              '🖱️ Click or 🎮 Press SPACE/↑',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _jump,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'START GAME',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CloudPainter extends CustomPainter {
  final double animation;

  CloudPainter({this.animation = 0});

  @override
  void paint(Canvas canvas, Size size) {
    final cloudPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    // Draw animated clouds with parallax effect
    for (int i = 0; i < 6; i++) {
      double baseX = (i * size.width / 3) % size.width;
      double animatedX =
          (baseX - (animation * size.width * 0.3)) % (size.width + 100);
      double y = 30 + (i * 35) % 100;
      double scale = 0.5 + (i % 3) * 0.2;

      // Shadow
      _drawCloud(canvas, shadowPaint, animatedX + 2, y + 2, scale);

      // Cloud
      _drawCloud(canvas, cloudPaint, animatedX, y, scale);
    }

    // Draw distant mountains
    final mountainPaint = Paint()
      ..color = Colors.teal.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 4; i++) {
      double x = (i * size.width / 2 - animation * size.width * 0.05) %
          (size.width + 200);
      double height = 60 + (i * 15) % 40;

      Path mountainPath = Path();
      mountainPath.moveTo(x - 50, size.height);
      mountainPath.lineTo(x, size.height - height);
      mountainPath.lineTo(x + 50, size.height);
      mountainPath.close();

      canvas.drawPath(mountainPath, mountainPaint);
    }
  }

  void _drawCloud(
      Canvas canvas, Paint paint, double x, double y, double scale) {
    canvas.drawCircle(Offset(x, y), 15 * scale, paint);
    canvas.drawCircle(Offset(x + 20 * scale, y), 20 * scale, paint);
    canvas.drawCircle(Offset(x + 40 * scale, y), 15 * scale, paint);
    canvas.drawCircle(
        Offset(x + 20 * scale, y - 10 * scale), 12 * scale, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
