import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class PongGameScreen extends StatelessWidget {
  const PongGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A3A),
        title: Text(
          'Pong Game',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () => _showControls(context),
          ),
        ],
      ),
      body: _PongGameWrapper(),
    );
  }

  void _showControls(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A3A),
        title: Text(
          'Game Controls',
          style: GoogleFonts.inter(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🖱️ Click/touch to move paddle to that position',
                style: GoogleFonts.inter(color: Colors.white)),
            const SizedBox(height: 8),
            Text('🖱️ Drag to move paddle up/down',
                style: GoogleFonts.inter(color: Colors.white)),
            const SizedBox(height: 8),
            Text('⌨️ Arrow keys or W/S to move paddle',
                style: GoogleFonts.inter(color: Colors.white)),
            const SizedBox(height: 8),
            Text('🏓 Score points by hitting the ball past opponent',
                style: GoogleFonts.inter(color: Colors.white)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK',
                style: GoogleFonts.inter(color: const Color(0xFF6366F1))),
          ),
        ],
      ),
    );
  }
}

class _PongGameWrapper extends StatefulWidget {
  @override
  State<_PongGameWrapper> createState() => _PongGameWrapperState();
}

class _PongGameWrapperState extends State<_PongGameWrapper> {
  late PongGame game;

  @override
  void initState() {
    super.initState();
    game = PongGame();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        final screenHeight = MediaQuery.of(context).size.height;
        final relativeY = details.globalPosition.dy / screenHeight;
        game.updatePlayerPaddle(relativeY);
      },
      onTapUp: (details) {
        final screenHeight = MediaQuery.of(context).size.height;
        final relativeY = details.globalPosition.dy / screenHeight;
        game.updatePlayerPaddle(relativeY);
      },
      child: Focus(
        autofocus: true,
        child: GameWidget<PongGame>.controlled(
          gameFactory: () => game,
        ),
      ),
    );
  }
}

class PongGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  late Paddle playerPaddle;
  late Paddle aiPaddle;
  late Ball ball;
  late TextComponent playerScoreText;
  late TextComponent aiScoreText;
  late TextComponent centerLine;

  int playerScore = 0;
  int aiScore = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Create paddles
    playerPaddle = Paddle(
      position: Vector2(30, size.y / 2),
      isPlayer: true,
    );

    aiPaddle = Paddle(
      position: Vector2(size.x - 50, size.y / 2),
      isPlayer: false,
    );

    // Create ball
    ball = Ball(
      position: Vector2(size.x / 2, size.y / 2),
      gameSize: size,
    );

    add(playerPaddle);
    add(aiPaddle);
    add(ball);

    // Score displays
    playerScoreText = TextComponent(
      text: '0',
      position: Vector2(size.x / 4, 50),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.white,
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    aiScoreText = TextComponent(
      text: '0',
      position: Vector2(3 * size.x / 4, 50),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.white,
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    add(playerScoreText);
    add(aiScoreText);

    // Center line
    centerLine = TextComponent(
      text: '|',
      position: Vector2(size.x / 2, size.y / 2),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.white.withOpacity(0.3),
          fontSize: 400,
          fontWeight: FontWeight.w100,
        ),
      ),
    );
    add(centerLine);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // AI paddle follows ball
    final ballY = ball.position.y;
    final paddleY = aiPaddle.position.y;
    final aiSpeed = 200.0;

    if (ballY > paddleY + 10) {
      aiPaddle.position.y += aiSpeed * dt;
    } else if (ballY < paddleY - 10) {
      aiPaddle.position.y -= aiSpeed * dt;
    }

    // Keep AI paddle in bounds
    aiPaddle.position.y = aiPaddle.position.y.clamp(50, size.y - 50);

    // Check ball collisions with paddles
    if (ball.position.x <= playerPaddle.position.x + 20 &&
        ball.position.y >= playerPaddle.position.y - 50 &&
        ball.position.y <= playerPaddle.position.y + 50 &&
        ball.velocity.x < 0) {
      ball.velocity.x = -ball.velocity.x;
      ball.velocity.y += (ball.position.y - playerPaddle.position.y) * 0.1;
    }

    if (ball.position.x >= aiPaddle.position.x - 20 &&
        ball.position.y >= aiPaddle.position.y - 50 &&
        ball.position.y <= aiPaddle.position.y + 50 &&
        ball.velocity.x > 0) {
      ball.velocity.x = -ball.velocity.x;
      ball.velocity.y += (ball.position.y - aiPaddle.position.y) * 0.1;
    }

    // Check scoring
    if (ball.position.x < 0) {
      aiScore++;
      aiScoreText.text = aiScore.toString();
      resetBall();
    } else if (ball.position.x > size.x) {
      playerScore++;
      playerScoreText.text = playerScore.toString();
      resetBall();
    }
  }

  void updatePlayerPaddle(double relativeY) {
    final targetY = relativeY * size.y;
    playerPaddle.position.y = targetY.clamp(50, size.y - 50);
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);

    final paddleSpeed = 300.0;

    if (keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.keyW)) {
      playerPaddle.position.y = (playerPaddle.position.y - paddleSpeed * 0.016)
          .clamp(50, size.y - 50);
      return KeyEventResult.handled;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
        keysPressed.contains(LogicalKeyboardKey.keyS)) {
      playerPaddle.position.y = (playerPaddle.position.y + paddleSpeed * 0.016)
          .clamp(50, size.y - 50);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void resetBall() {
    ball.position = Vector2(size.x / 2, size.y / 2);
    ball.velocity = Vector2(
      Random().nextBool() ? 200 : -200,
      Random().nextDouble() * 200 - 100,
    );
  }
}

class Paddle extends RectangleComponent {
  final bool isPlayer;

  Paddle({
    required Vector2 position,
    required this.isPlayer,
  }) : super(
          position: position,
          size: Vector2(20, 100),
          anchor: Anchor.center,
        );

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = const Color(0xFF6366F1);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        const Radius.circular(10),
      ),
      paint,
    );
  }
}

class Ball extends CircleComponent {
  Vector2 velocity = Vector2(200, 100);
  final Vector2 gameSize;

  Ball({
    required Vector2 position,
    required this.gameSize,
  }) : super(
          position: position,
          radius: 10,
          anchor: Anchor.center,
        );

  @override
  void update(double dt) {
    super.update(dt);

    position += velocity * dt;

    // Bounce off top and bottom walls
    if (position.y <= radius || position.y >= gameSize.y - radius) {
      velocity.y = -velocity.y;
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = const Color(0xFF10B981);
    canvas.drawCircle(Offset(radius, radius), radius, paint);
  }
}
