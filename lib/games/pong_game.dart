import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:async';

class PongGame extends StatefulWidget {
  const PongGame({super.key});

  @override
  State<PongGame> createState() => _PongGameState();
}

class _PongGameState extends State<PongGame> with TickerProviderStateMixin {
  static const double paddleWidth = 20;
  static const double paddleHeight = 100;
  static const double ballSize = 20;
  static const int gameSpeed = 16; // milliseconds

  Timer? gameTimer;
  bool isGameRunning = false;
  bool isGameStarted = false;

  late AnimationController _ballController;
  late Animation<double> _ballAnimation;
  late AnimationController _paddleController;
  late Animation<double> _paddleAnimation;
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  // Paddle positions (0 to 1, where 0 is top, 1 is bottom)
  double playerPaddleY = 0.5;
  double aiPaddleY = 0.5;

  // Ball properties
  double ballX = 0.5;
  double ballY = 0.5;
  double ballVelocityX = 0.003;
  double ballVelocityY = 0.002;

  // Scores
  int playerScore = 0;
  int aiScore = 0;
  int winningScore = 5;

  // AI difficulty
  double aiSpeed = 0.01;

  @override
  void initState() {
    super.initState();

    _ballController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _ballAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _ballController,
      curve: Curves.easeInOut,
    ));

    _paddleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _paddleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _paddleController,
      curve: Curves.easeOut,
    ));

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_backgroundController);

    _resetGame();
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    _ballController.dispose();
    _paddleController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  void _resetGame() {
    setState(() {
      playerPaddleY = 0.5;
      aiPaddleY = 0.5;
      ballX = 0.5;
      ballY = 0.5;
      ballVelocityX = (Random().nextBool() ? 1 : -1) * 0.003;
      ballVelocityY = (Random().nextDouble() - 0.5) * 0.004;
      isGameRunning = false;
      isGameStarted = false;
    });
  }

  void _startGame() {
    if (!isGameRunning) {
      setState(() {
        isGameRunning = true;
        isGameStarted = true;
      });

      gameTimer = Timer.periodic(
        Duration(milliseconds: gameSpeed),
        (timer) => _updateGame(),
      );
    }
  }

  void _pauseGame() {
    if (isGameRunning) {
      setState(() {
        isGameRunning = false;
      });
      gameTimer?.cancel();
    }
  }

  void _updateGame() {
    if (!isGameRunning) return;

    setState(() {
      // Update ball position
      ballX += ballVelocityX;
      ballY += ballVelocityY;

      // Ball collision with top and bottom walls
      if (ballY <= 0 || ballY >= 1) {
        ballVelocityY = -ballVelocityY;
        ballY = ballY <= 0 ? 0 : 1;
        _ballController.forward().then((_) => _ballController.reverse());
      }

      // Ball collision with paddles
      if (ballX <= paddleWidth / 400 && // Player paddle area
          ballY >= playerPaddleY - 0.1 &&
          ballY <= playerPaddleY + 0.1) {
        ballVelocityX = -ballVelocityX;
        ballVelocityY += (Random().nextDouble() - 0.5) * 0.002;
        _paddleController.forward().then((_) => _paddleController.reverse());
      }

      if (ballX >= 1 - (paddleWidth / 400) && // AI paddle area
          ballY >= aiPaddleY - 0.1 &&
          ballY <= aiPaddleY + 0.1) {
        ballVelocityX = -ballVelocityX;
        ballVelocityY += (Random().nextDouble() - 0.5) * 0.002;
      }

      // AI movement
      if (ballX > 0.5) {
        if (aiPaddleY < ballY) {
          aiPaddleY = min(1.0, aiPaddleY + aiSpeed);
        } else {
          aiPaddleY = max(0.0, aiPaddleY - aiSpeed);
        }
      }

      // Score points
      if (ballX < 0) {
        aiScore++;
        _resetBall();
      } else if (ballX > 1) {
        playerScore++;
        _resetBall();
      }

      // Check for game end
      if (playerScore >= winningScore || aiScore >= winningScore) {
        _pauseGame();
      }
    });
  }

  void _resetBall() {
    ballX = 0.5;
    ballY = 0.5;
    ballVelocityX = (Random().nextBool() ? 1 : -1) * 0.003;
    ballVelocityY = (Random().nextDouble() - 0.5) * 0.004;
  }

  void _movePaddle(double delta) {
    setState(() {
      playerPaddleY = (playerPaddleY + delta).clamp(0.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text(
          'Pong Game',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Animated Background
              AnimatedBuilder(
                animation: _backgroundAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: PongBackgroundPainter(_backgroundAnimation.value),
                    size: Size(constraints.maxWidth, constraints.maxHeight),
                  );
                },
              ),

              // Game Area
              Container(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: [
                    // Center line
                    _buildCenterLine(constraints),

                    // Player paddle
                    _buildPlayerPaddle(constraints),

                    // AI paddle
                    _buildAIPaddle(constraints),

                    // Ball
                    _buildBall(constraints),

                    // Touch controls for mobile
                    if (Theme.of(context).platform == TargetPlatform.android ||
                        Theme.of(context).platform == TargetPlatform.iOS)
                      _buildTouchControls(constraints),
                  ],
                ),
              ),

              // UI Overlay
              _buildUI(constraints),

              // Game Over Dialog
              if ((playerScore >= winningScore || aiScore >= winningScore) &&
                  !isGameRunning)
                _buildGameOverDialog(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCenterLine(BoxConstraints constraints) {
    return Positioned(
      left: constraints.maxWidth / 2 - 1,
      top: 0,
      bottom: 0,
      child: Container(
        width: 2,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }

  Widget _buildPlayerPaddle(BoxConstraints constraints) {
    return AnimatedBuilder(
      animation: _paddleAnimation,
      builder: (context, child) {
        return _buildPaddle(
          constraints,
          true,
          playerPaddleY,
          Colors.blue,
          _paddleAnimation.value,
        );
      },
    );
  }

  Widget _buildAIPaddle(BoxConstraints constraints) {
    return _buildPaddle(
      constraints,
      false,
      aiPaddleY,
      Colors.red,
      1.0,
    );
  }

  Widget _buildPaddle(
    BoxConstraints constraints,
    bool isPlayer,
    double paddleY,
    Color color,
    double scale,
  ) {
    double paddlePixelHeight = constraints.maxHeight * 0.2;
    double paddlePixelWidth = paddleWidth;

    return Positioned(
      left: isPlayer ? 10 : constraints.maxWidth - paddlePixelWidth - 10,
      top: (paddleY * constraints.maxHeight) - (paddlePixelHeight / 2),
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: paddlePixelWidth,
          height: paddlePixelHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color,
                color.withOpacity(0.7),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBall(BoxConstraints constraints) {
    return Positioned(
      left: (ballX * constraints.maxWidth) - (ballSize / 2),
      top: (ballY * constraints.maxHeight) - (ballSize / 2),
      child: AnimatedBuilder(
        animation: _ballAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _ballAnimation.value,
            child: Container(
              width: ballSize,
              height: ballSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [
                    Colors.white,
                    Colors.grey,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTouchControls(BoxConstraints constraints) {
    return Positioned(
      left: 0,
      bottom: 20,
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _movePaddle(-0.1),
            child: Container(
              width: 60,
              height: 60,
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.keyboard_arrow_up,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _movePaddle(0.1),
            child: Container(
              width: 60,
              height: 60,
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUI(BoxConstraints constraints) {
    return Positioned(
      top: 20,
      left: 0,
      right: 0,
      child: Column(
        children: [
          // Score Display
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Player Score
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: Column(
                  children: [
                    const Text(
                      'PLAYER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$playerScore',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // AI Score
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.red, width: 2),
                ),
                child: Column(
                  children: [
                    const Text(
                      'AI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$aiScore',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Control Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: isGameRunning ? _pauseGame : _startGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isGameRunning ? Colors.orange : Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Text(isGameRunning ? 'PAUSE' : 'START'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  _pauseGame();
                  setState(() {
                    playerScore = 0;
                    aiScore = 0;
                  });
                  _resetGame();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text('RESET'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGameOverDialog() {
    String winner = playerScore >= winningScore ? 'PLAYER WINS!' : 'AI WINS!';
    Color winnerColor = playerScore >= winningScore ? Colors.blue : Colors.red;

    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: winnerColor, width: 3),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'GAME OVER',
                style: TextStyle(
                  color: winnerColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                winner,
                style: TextStyle(
                  color: winnerColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Final Score: $playerScore - $aiScore',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    playerScore = 0;
                    aiScore = 0;
                  });
                  _resetGame();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: winnerColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text('PLAY AGAIN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PongBackgroundPainter extends CustomPainter {
  final double animationValue;

  PongBackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Animated grid background
    paint.color = Colors.white.withOpacity(0.05);
    paint.strokeWidth = 1;

    double spacing = 50;
    double offset = (animationValue * spacing) % spacing;

    // Vertical lines
    for (double x = -offset; x < size.width + spacing; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Horizontal lines
    for (double y = -offset; y < size.height + spacing; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Center glow effect
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.cyan.withOpacity(0.1),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 3,
      ));

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 3,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
