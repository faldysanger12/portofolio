import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class FlappyGameScreen extends StatelessWidget {
  const FlappyGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A3A),
        title: Text(
          'Flappy Bird',
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
      body: _FlappyGameWrapper(),
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
            Text('👆 Tap anywhere to flap',
                style: GoogleFonts.inter(color: Colors.white)),
            const SizedBox(height: 8),
            Text('⌨️ Spacebar, Up arrow, or W to flap',
                style: GoogleFonts.inter(color: Colors.white)),
            const SizedBox(height: 8),
            Text('🚁 Navigate through pipes without crashing',
                style: GoogleFonts.inter(color: Colors.white)),
            const SizedBox(height: 8),
            Text('🎯 Score points by passing through pipes',
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

class _FlappyGameWrapper extends StatefulWidget {
  @override
  State<_FlappyGameWrapper> createState() => _FlappyGameWrapperState();
}

class _FlappyGameWrapperState extends State<_FlappyGameWrapper> {
  late FlappyGame game;

  @override
  void initState() {
    super.initState();
    game = FlappyGame();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        game.handleTap();
      },
      child: Focus(
        autofocus: true,
        child: GameWidget<FlappyGame>.controlled(
          gameFactory: () => game,
        ),
      ),
    );
  }
}

class FlappyGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  late Bird bird;
  late List<Pipe> pipes;
  late TextComponent scoreText;
  late TextComponent gameOverText;
  late TextComponent instructionText;

  int score = 0;
  bool gameOver = false;
  bool gameStarted = false;
  double pipeSpawnTimer = 0;
  final double pipeSpawnInterval = 2.0;
  final Random random = Random();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    bird = Bird(position: Vector2(100, size.y / 2));
    pipes = [];

    add(bird);

    // Score text
    scoreText = TextComponent(
      text: '0',
      position: Vector2(size.x / 2, 80),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.white,
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(scoreText);

    // Instruction text
    instructionText = TextComponent(
      text: 'Tap to fly!',
      position: Vector2(size.x / 2, size.y / 2 + 100),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
    );
    add(instructionText);

    // Game over text
    gameOverText = TextComponent(
      text: 'Game Over!\nTap to restart',
      position: Vector2(size.x / 2, size.y / 2),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.red,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!gameStarted || gameOver) return;

    // Spawn pipes
    pipeSpawnTimer += dt;
    if (pipeSpawnTimer >= pipeSpawnInterval) {
      spawnPipe();
      pipeSpawnTimer = 0;
    }

    // Check collisions
    checkCollisions();

    // Remove off-screen pipes
    pipes.removeWhere((pipe) {
      if (pipe.position.x < -100) {
        remove(pipe);
        return true;
      }
      return false;
    });

    // Check if bird passed through pipes for scoring
    for (final pipe in pipes) {
      if (!pipe.scored && pipe.position.x + pipe.size.x < bird.position.x) {
        if (pipe.isTop) {
          score++;
          scoreText.text = score.toString();
        }
        pipe.scored = true;
      }
    }
  }

  void spawnPipe() {
    final gapHeight = 150.0;
    final gapPosition = random.nextDouble() * (size.y - gapHeight - 200) + 100;

    // Top pipe
    final topPipe = Pipe(
      position: Vector2(size.x, 0),
      size: Vector2(80, gapPosition),
      isTop: true,
    );

    // Bottom pipe
    final bottomPipe = Pipe(
      position: Vector2(size.x, gapPosition + gapHeight),
      size: Vector2(80, size.y - gapPosition - gapHeight),
      isTop: false,
    );

    pipes.add(topPipe);
    pipes.add(bottomPipe);
    add(topPipe);
    add(bottomPipe);
  }

  void checkCollisions() {
    // Check ground and ceiling collision
    if (bird.position.y <= 0 || bird.position.y >= size.y) {
      endGame();
      return;
    }

    // Check pipe collisions
    for (final pipe in pipes) {
      if (bird.position.x + 20 > pipe.position.x &&
          bird.position.x - 20 < pipe.position.x + pipe.size.x &&
          bird.position.y + 20 > pipe.position.y &&
          bird.position.y - 20 < pipe.position.y + pipe.size.y) {
        endGame();
        return;
      }
    }
  }

  void endGame() {
    gameOver = true;
    add(gameOverText);
  }

  void restartGame() {
    gameOver = false;
    gameStarted = false;
    score = 0;
    scoreText.text = '0';

    // Remove all pipes
    for (final pipe in pipes) {
      remove(pipe);
    }
    pipes.clear();

    // Reset bird
    bird.reset(Vector2(100, size.y / 2));

    remove(gameOverText);
    add(instructionText);

    pipeSpawnTimer = 0;
  }

  void handleTap() {
    if (gameOver) {
      restartGame();
    } else if (!gameStarted) {
      gameStarted = true;
      remove(instructionText);
      bird.flap();
    } else {
      bird.flap();
    }
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);

    if (keysPressed.contains(LogicalKeyboardKey.space) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.keyW)) {
      handleTap();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}

class Bird extends CircleComponent {
  double velocity = 0;
  final double gravity = 980;
  final double jumpStrength = 350;

  Bird({required Vector2 position})
      : super(
          position: position,
          radius: 20,
          anchor: Anchor.center,
        );

  @override
  void update(double dt) {
    super.update(dt);

    velocity += gravity * dt;
    position.y += velocity * dt;
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = const Color(0xFFF59E0B);
    canvas.drawCircle(Offset(radius, radius), radius, paint);

    // Draw wing
    final wingPaint = Paint()..color = const Color(0xFFD97706);
    canvas.drawOval(
      Rect.fromLTWH(radius - 10, radius - 5, 15, 10),
      wingPaint,
    );

    // Draw eye
    final eyePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(radius + 5, radius - 5), 5, eyePaint);

    final pupilPaint = Paint()..color = Colors.black;
    canvas.drawCircle(Offset(radius + 7, radius - 3), 2, pupilPaint);
  }

  void flap() {
    velocity = -jumpStrength;
  }

  void reset(Vector2 newPosition) {
    position = newPosition;
    velocity = 0;
  }
}

class Pipe extends RectangleComponent {
  final bool isTop;
  bool scored = false;
  final double speed = 200;

  Pipe({
    required Vector2 position,
    required Vector2 size,
    required this.isTop,
  }) : super(
          position: position,
          size: size,
          anchor: Anchor.topLeft,
        );

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= speed * dt;
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = const Color(0xFF10B981);

    // Draw pipe body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        const Radius.circular(5),
      ),
      paint,
    );

    // Draw pipe cap
    final capPaint = Paint()..color = const Color(0xFF059669);
    if (isTop) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(-10, size.y - 30, size.x + 20, 30),
          const Radius.circular(5),
        ),
        capPaint,
      );
    } else {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(-10, 0, size.x + 20, 30),
          const Radius.circular(5),
        ),
        capPaint,
      );
    }
  }
}
