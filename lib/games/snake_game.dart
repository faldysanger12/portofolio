import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:async';

class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> with TickerProviderStateMixin {
  static const int boardSize = 20;
  List<Point<int>> snake = [const Point(10, 10)];
  Point<int> food = const Point(15, 15);
  String direction = 'right';
  bool isGameRunning = false;
  int score = 0;
  Timer? gameTimer;

  late AnimationController _foodController;
  late Animation<double> _foodAnimation;
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();

    _foodController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _foodAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _foodController,
      curve: Curves.easeInOut,
    ));

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _backgroundAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_backgroundController);

    _generateFood();
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    _foodController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  void _generateFood() {
    Random random = Random();
    Point<int> newFood;
    do {
      newFood = Point(random.nextInt(boardSize), random.nextInt(boardSize));
    } while (snake.contains(newFood));

    setState(() {
      food = newFood;
    });
  }

  void _startGame() {
    if (!isGameRunning) {
      setState(() {
        isGameRunning = true;
        snake = [const Point(10, 10)];
        direction = 'right';
        score = 0;
      });
      _generateFood();

      gameTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
        _moveSnake();
      });
    }
  }

  void _pauseGame() {
    gameTimer?.cancel();
    setState(() {
      isGameRunning = false;
    });
  }

  void _resetGame() {
    gameTimer?.cancel();
    setState(() {
      isGameRunning = false;
      snake = [const Point(10, 10)];
      direction = 'right';
      score = 0;
    });
    _generateFood();
  }

  void _moveSnake() {
    Point<int> head = snake.first;
    Point<int> newHead;

    switch (direction) {
      case 'up':
        newHead = Point(head.x, head.y - 1);
        break;
      case 'down':
        newHead = Point(head.x, head.y + 1);
        break;
      case 'left':
        newHead = Point(head.x - 1, head.y);
        break;
      case 'right':
        newHead = Point(head.x + 1, head.y);
        break;
      default:
        newHead = head;
    }

    // Check wall collision
    if (newHead.x < 0 ||
        newHead.x >= boardSize ||
        newHead.y < 0 ||
        newHead.y >= boardSize) {
      _gameOver();
      return;
    }

    // Check self collision
    if (snake.contains(newHead)) {
      _gameOver();
      return;
    }

    setState(() {
      snake.insert(0, newHead);

      // Check food collision
      if (newHead == food) {
        score += 10;
        _generateFood();
      } else {
        snake.removeLast();
      }
    });
  }

  void _gameOver() {
    gameTimer?.cancel();
    setState(() {
      isGameRunning = false;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text(
          'Game Over',
          style: TextStyle(color: Colors.red),
        ),
        content: Text(
          'Score: $score',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetGame();
              _startGame();
            },
            child:
                const Text('Play Again', style: TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Exit', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _changeDirection(String newDirection) {
    if (!isGameRunning) return;

    // Prevent reverse direction
    if ((direction == 'up' && newDirection == 'down') ||
        (direction == 'down' && newDirection == 'up') ||
        (direction == 'left' && newDirection == 'right') ||
        (direction == 'right' && newDirection == 'left')) {
      return;
    }

    setState(() {
      direction = newDirection;
    });
  }

  Widget _buildMobileControls() {
    return Column(
      children: [
        // Score
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xFF262629).withOpacity(0.8),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Score',
                style: TextStyle(
                  color: Colors.green.shade300,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$score',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Control buttons
        Row(
          children: [
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    colors: isGameRunning
                        ? [Colors.orange.shade600, Colors.red.shade600]
                        : [Colors.green.shade600, Colors.teal.shade600],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isGameRunning ? Colors.orange : Colors.green)
                          .withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: isGameRunning ? _pauseGame : _startGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    isGameRunning ? 'PAUSE' : 'START',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey.shade600),
                  color: const Color(0xFF262629).withOpacity(0.8),
                ),
                child: ElevatedButton(
                  onPressed: _resetGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'RESET',
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Arrow controls
        Column(
          children: [
            // Up
            _buildControlButton(
                Icons.keyboard_arrow_up, () => _changeDirection('up')),
            const SizedBox(height: 8),
            // Left, Down, Right
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildControlButton(
                    Icons.keyboard_arrow_left, () => _changeDirection('left')),
                const SizedBox(width: 20),
                _buildControlButton(
                    Icons.keyboard_arrow_down, () => _changeDirection('down')),
                const SizedBox(width: 20),
                _buildControlButton(Icons.keyboard_arrow_right,
                    () => _changeDirection('right')),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopControls() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Score
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF262629).withOpacity(0.8),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Text(
                'Score',
                style: TextStyle(
                  color: Colors.green.shade300,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$score',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        // Control buttons
        Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              colors: isGameRunning
                  ? [Colors.orange.shade600, Colors.red.shade600]
                  : [Colors.green.shade600, Colors.teal.shade600],
            ),
            boxShadow: [
              BoxShadow(
                color: (isGameRunning ? Colors.orange : Colors.green)
                    .withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: isGameRunning ? _pauseGame : _startGame,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(
              isGameRunning ? 'PAUSE' : 'START',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.grey.shade600),
            color: const Color(0xFF262629).withOpacity(0.8),
          ),
          child: ElevatedButton(
            onPressed: _resetGame,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(
              'RESET',
              style: TextStyle(
                color: Colors.grey.shade300,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        // Arrow controls
        Column(
          children: [
            // Up
            _buildControlButton(
                Icons.keyboard_arrow_up, () => _changeDirection('up')),
            const SizedBox(height: 8),
            // Left, Down, Right
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildControlButton(
                    Icons.keyboard_arrow_left, () => _changeDirection('left')),
                const SizedBox(width: 20),
                _buildControlButton(
                    Icons.keyboard_arrow_down, () => _changeDirection('down')),
                const SizedBox(width: 20),
                _buildControlButton(Icons.keyboard_arrow_right,
                    () => _changeDirection('right')),
              ],
            ),
          ],
        ),
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xFF262629).withOpacity(0.6),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Text(
                'Controls',
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Use arrow keys\nor touch controls',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 12,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green.shade600,
              Colors.green.shade800,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0B),
      appBar: AppBar(
        title: const Text('Snake Game',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1A1A1D),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A0A0B),
              Color(0xFF1A1A1D),
              Color(0xFF0F2027),
            ],
          ),
        ),
        child: KeyboardListener(
          focusNode: FocusNode()..requestFocus(),
          onKeyEvent: (event) {
            if (event is KeyDownEvent && isGameRunning) {
              switch (event.logicalKey) {
                case LogicalKeyboardKey.arrowUp:
                  _changeDirection('up');
                  break;
                case LogicalKeyboardKey.arrowDown:
                  _changeDirection('down');
                  break;
                case LogicalKeyboardKey.arrowLeft:
                  _changeDirection('left');
                  break;
                case LogicalKeyboardKey.arrowRight:
                  _changeDirection('right');
                  break;
              }
            }
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 800) {
                // Mobile layout
                return Column(
                  children: [
                    // Game board
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                            border: Border.all(
                              color: Colors.green.withOpacity(0.5),
                              width: 2,
                            ),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF1A1A1D),
                                Color(0xFF0F2027),
                                Color(0xFF1A1A1D),
                              ],
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: AnimatedBuilder(
                                animation: _backgroundAnimation,
                                builder: (context, child) {
                                  return CustomPaint(
                                    painter: SnakePainter(
                                      snake: snake,
                                      food: food,
                                      boardSize: boardSize,
                                      foodAnimation: _foodAnimation.value,
                                      backgroundAnimation:
                                          _backgroundAnimation.value,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Bottom controls
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1D).withOpacity(0.8),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)),
                      ),
                      child: _buildMobileControls(),
                    ),
                  ],
                );
              } else {
                // Desktop layout
                return Row(
                  children: [
                    // Game board
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                            border: Border.all(
                              color: Colors.green.withOpacity(0.5),
                              width: 2,
                            ),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF1A1A1D),
                                Color(0xFF0F2027),
                                Color(0xFF1A1A1D),
                              ],
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: AnimatedBuilder(
                                animation: _backgroundAnimation,
                                builder: (context, child) {
                                  return CustomPaint(
                                    painter: SnakePainter(
                                      snake: snake,
                                      food: food,
                                      boardSize: boardSize,
                                      foodAnimation: _foodAnimation.value,
                                      backgroundAnimation:
                                          _backgroundAnimation.value,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Side panel
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: _buildDesktopControls(),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class SnakePainter extends CustomPainter {
  final List<Point<int>> snake;
  final Point<int> food;
  final int boardSize;
  final double foodAnimation;
  final double backgroundAnimation;

  SnakePainter({
    required this.snake,
    required this.food,
    required this.boardSize,
    this.foodAnimation = 1.0,
    this.backgroundAnimation = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double cellSize = size.width / boardSize;

    // Draw animated grid background
    final gridPaint = Paint()
      ..color = Colors.grey[700]!.withOpacity(0.3 + backgroundAnimation * 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (int i = 0; i <= boardSize; i++) {
      // Vertical lines with wave effect
      double offset = sin(backgroundAnimation * 2 * pi + i * 0.5) * 2;
      canvas.drawLine(
        Offset(i * cellSize + offset, 0),
        Offset(i * cellSize + offset, size.height),
        gridPaint,
      );
      // Horizontal lines
      canvas.drawLine(
        Offset(0, i * cellSize),
        Offset(size.width, i * cellSize),
        gridPaint,
      );
    }

    // Draw snake with gradient and glow effect
    for (int i = 0; i < snake.length; i++) {
      final point = snake[i];
      final rect = Rect.fromLTWH(
        point.x * cellSize + 2,
        point.y * cellSize + 2,
        cellSize - 4,
        cellSize - 4,
      );

      final double alpha = (snake.length - i) / snake.length;
      Color segmentColor;

      if (i == 0) {
        // Head - bright green with glow
        segmentColor = Colors.lightGreen;

        // Glow effect for head
        final glowPaint = Paint()
          ..color = Colors.lightGreen.withOpacity(0.5)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            rect.inflate(4),
            const Radius.circular(8),
          ),
          glowPaint,
        );
      } else {
        // Body - gradient from light to dark green
        segmentColor = Color.lerp(
          Colors.green[400]!,
          Colors.green[800]!,
          1 - alpha,
        )!;
      }

      final snakePaint = Paint()
        ..shader = LinearGradient(
          colors: [
            segmentColor,
            segmentColor.withOpacity(0.8),
          ],
        ).createShader(rect);

      // Shadow
      final shadowPaint = Paint()..color = Colors.black.withOpacity(0.3);

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          rect.translate(1, 1),
          const Radius.circular(6),
        ),
        shadowPaint,
      );

      // Main body
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(6)),
        snakePaint,
      );

      // Highlight
      if (i < 3) {
        final highlightPaint = Paint()..color = Colors.white.withOpacity(0.3);

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              rect.left + 2,
              rect.top + 2,
              rect.width * 0.6,
              rect.height * 0.3,
            ),
            const Radius.circular(3),
          ),
          highlightPaint,
        );
      }
    }

    // Draw animated food
    final foodRect = Rect.fromLTWH(
      food.x * cellSize + 2,
      food.y * cellSize + 2,
      cellSize - 4,
      cellSize - 4,
    );

    // Animated scale
    final scaledRect = Rect.fromCenter(
      center: foodRect.center,
      width: foodRect.width * foodAnimation,
      height: foodRect.height * foodAnimation,
    );

    // Glow effect
    final foodGlowPaint = Paint()
      ..color = Colors.red.withOpacity(0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawOval(scaledRect.inflate(6), foodGlowPaint);

    // Food gradient
    final foodPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.red[300]!,
          Colors.red[600]!,
          Colors.red[900]!,
        ],
        stops: const [0.0, 0.7, 1.0],
      ).createShader(scaledRect);

    // Shadow
    final foodShadowPaint = Paint()..color = Colors.black.withOpacity(0.4);

    canvas.drawOval(scaledRect.translate(2, 2), foodShadowPaint);

    // Main food
    canvas.drawOval(scaledRect, foodPaint);

    // Highlight
    final highlightPaint = Paint()..color = Colors.white.withOpacity(0.6);

    canvas.drawOval(
      Rect.fromCenter(
        center: scaledRect.center.translate(-3, -3),
        width: scaledRect.width * 0.3,
        height: scaledRect.height * 0.3,
      ),
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
