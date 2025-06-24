import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:async';

class TetrisGame extends StatefulWidget {
  const TetrisGame({super.key});

  @override
  State<TetrisGame> createState() => _TetrisGameState();
}

class _TetrisGameState extends State<TetrisGame> {
  static const int boardWidth = 10;
  static const int boardHeight = 20;

  List<List<int>> board =
      List.generate(boardHeight, (index) => List.filled(boardWidth, 0));

  late Timer gameTimer;
  bool isGameRunning = false;
  int score = 0;
  int level = 1;
  int linesCleared = 0;

  // Current piece
  List<List<int>> currentPiece = [];
  int currentX = 4;
  int currentY = 0;
  int currentRotation = 0;

  // Tetris pieces (tetrominos)
  final List<List<List<List<int>>>> pieces = [
    // I piece
    [
      [
        [1, 1, 1, 1]
      ],
      [
        [1],
        [1],
        [1],
        [1]
      ],
    ],
    // O piece
    [
      [
        [1, 1],
        [1, 1]
      ],
    ],
    // T piece
    [
      [
        [0, 1, 0],
        [1, 1, 1]
      ],
      [
        [1, 0],
        [1, 1],
        [1, 0]
      ],
      [
        [1, 1, 1],
        [0, 1, 0]
      ],
      [
        [0, 1],
        [1, 1],
        [0, 1]
      ],
    ],
    // S piece
    [
      [
        [0, 1, 1],
        [1, 1, 0]
      ],
      [
        [1, 0],
        [1, 1],
        [0, 1]
      ],
    ],
    // Z piece
    [
      [
        [1, 1, 0],
        [0, 1, 1]
      ],
      [
        [0, 1],
        [1, 1],
        [1, 0]
      ],
    ],
    // J piece
    [
      [
        [1, 0, 0],
        [1, 1, 1]
      ],
      [
        [1, 1],
        [1, 0],
        [1, 0]
      ],
      [
        [1, 1, 1],
        [0, 0, 1]
      ],
      [
        [0, 1],
        [0, 1],
        [1, 1]
      ],
    ],
    // L piece
    [
      [
        [0, 0, 1],
        [1, 1, 1]
      ],
      [
        [1, 0],
        [1, 0],
        [1, 1]
      ],
      [
        [1, 1, 1],
        [1, 0, 0]
      ],
      [
        [1, 1],
        [0, 1],
        [0, 1]
      ],
    ],
  ];

  final List<Color> pieceColors = [
    Colors.cyan, // I
    Colors.yellow, // O
    Colors.purple, // T
    Colors.green, // S
    Colors.red, // Z
    Colors.blue, // J
    Colors.orange, // L
  ];

  int currentPieceType = 0;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  @override
  void dispose() {
    if (isGameRunning) {
      gameTimer.cancel();
    }
    super.dispose();
  }

  void _resetGame() {
    board = List.generate(boardHeight, (index) => List.filled(boardWidth, 0));
    score = 0;
    level = 1;
    linesCleared = 0;
    _spawnNewPiece();
  }

  void _spawnNewPiece() {
    currentPieceType = Random().nextInt(pieces.length);
    currentPiece = pieces[currentPieceType][0];
    currentRotation = 0;
    currentX = boardWidth ~/ 2 - currentPiece[0].length ~/ 2;
    currentY = 0;

    if (_isColliding()) {
      _gameOver();
    }
  }

  bool _isColliding() {
    for (int y = 0; y < currentPiece.length; y++) {
      for (int x = 0; x < currentPiece[y].length; x++) {
        if (currentPiece[y][x] == 1) {
          int boardX = currentX + x;
          int boardY = currentY + y;

          if (boardX < 0 ||
              boardX >= boardWidth ||
              boardY >= boardHeight ||
              (boardY >= 0 && board[boardY][boardX] != 0)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void _movePiece(int dx, int dy) {
    currentX += dx;
    currentY += dy;

    if (_isColliding()) {
      currentX -= dx;
      currentY -= dy;

      if (dy > 0) {
        _placePiece();
      }
    }
  }

  void _rotatePiece() {
    List<List<List<int>>> rotations = pieces[currentPieceType];
    int nextRotation = (currentRotation + 1) % rotations.length;
    List<List<int>> oldPiece = currentPiece;

    currentPiece = rotations[nextRotation];
    currentRotation = nextRotation;

    if (_isColliding()) {
      currentPiece = oldPiece;
      currentRotation = (currentRotation - 1) % rotations.length;
    }
  }

  void _placePiece() {
    for (int y = 0; y < currentPiece.length; y++) {
      for (int x = 0; x < currentPiece[y].length; x++) {
        if (currentPiece[y][x] == 1) {
          int boardX = currentX + x;
          int boardY = currentY + y;

          if (boardY >= 0) {
            board[boardY][boardX] = currentPieceType + 1;
          }
        }
      }
    }

    _clearLines();
    _spawnNewPiece();
  }

  void _clearLines() {
    int cleared = 0;

    for (int y = boardHeight - 1; y >= 0; y--) {
      bool isLineFull = true;
      for (int x = 0; x < boardWidth; x++) {
        if (board[y][x] == 0) {
          isLineFull = false;
          break;
        }
      }

      if (isLineFull) {
        board.removeAt(y);
        board.insert(0, List.filled(boardWidth, 0));
        cleared++;
        y++; // Check the same line again
      }
    }

    if (cleared > 0) {
      linesCleared += cleared;
      score += cleared * 100 * level;
      level = (linesCleared ~/ 10) + 1;
    }
  }

  void _gameOver() {
    if (isGameRunning) {
      gameTimer.cancel();
      isGameRunning = false;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: Text('Score: $score\nLevel: $level\nLines: $linesCleared'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetGame();
            },
            child: const Text('Play Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  void _startGame() {
    if (!isGameRunning) {
      isGameRunning = true;
      gameTimer = Timer.periodic(
        Duration(milliseconds: 500 - (level - 1) * 50),
        (timer) {
          _movePiece(0, 1);
        },
      );
    }
  }

  void _pauseGame() {
    if (isGameRunning) {
      gameTimer.cancel();
      isGameRunning = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0B),
      appBar: AppBar(
        title: const Text('Tetris',
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
              Color(0xFF262629),
            ],
          ),
        ),
        child: KeyboardListener(
          focusNode: FocusNode()..requestFocus(),
          onKeyEvent: (event) {
            if (event is KeyDownEvent && isGameRunning) {
              switch (event.logicalKey) {
                case LogicalKeyboardKey.arrowLeft:
                  _movePiece(-1, 0);
                  break;
                case LogicalKeyboardKey.arrowRight:
                  _movePiece(1, 0);
                  break;
                case LogicalKeyboardKey.arrowDown:
                  _movePiece(0, 1);
                  break;
                case LogicalKeyboardKey.arrowUp:
                case LogicalKeyboardKey.space:
                  _rotatePiece();
                  break;
              }
              setState(() {});
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
                                color: Colors.cyan.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                            border: Border.all(
                              color: Colors.cyan.withOpacity(0.5),
                              width: 2,
                            ),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF1A1A1D),
                                Color(0xFF262629),
                                Color(0xFF1A1A1D),
                              ],
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: AspectRatio(
                              aspectRatio: boardWidth / boardHeight,
                              child: CustomPaint(
                                painter: TetrisPainter(
                                  board: board,
                                  currentPiece: currentPiece,
                                  currentX: currentX,
                                  currentY: currentY,
                                  currentPieceType: currentPieceType,
                                  pieceColors: pieceColors,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Bottom panel
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1D).withOpacity(0.8),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)),
                      ),
                      child: _buildControlPanel(),
                    ),
                  ],
                );
              } else {
                // Desktop layout
                return Row(
                  children: [
                    // Game board
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.cyan.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                            border: Border.all(
                              color: Colors.cyan.withOpacity(0.5),
                              width: 2,
                            ),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF1A1A1D),
                                Color(0xFF262629),
                                Color(0xFF1A1A1D),
                              ],
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: AspectRatio(
                              aspectRatio: boardWidth / boardHeight,
                              child: CustomPaint(
                                painter: TetrisPainter(
                                  board: board,
                                  currentPiece: currentPiece,
                                  currentX: currentX,
                                  currentY: currentY,
                                  currentPieceType: currentPieceType,
                                  pieceColors: pieceColors,
                                ),
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
                        child: _buildControlPanel(),
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

  Widget _buildControlPanel() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF262629).withOpacity(0.8),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.cyan.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Text(
                'Score',
                style: TextStyle(
                  color: Colors.cyan.shade300,
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
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF262629).withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.purple.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Text(
                    'Level',
                    style: TextStyle(
                      color: Colors.purple.shade300,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '$level',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF262629).withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Text(
                    'Lines',
                    style: TextStyle(
                      color: Colors.green.shade300,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '$linesCleared',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              colors: isGameRunning
                  ? [Colors.orange.shade600, Colors.red.shade600]
                  : [Colors.cyan.shade600, Colors.blue.shade600],
            ),
            boxShadow: [
              BoxShadow(
                color: (isGameRunning ? Colors.orange : Colors.cyan)
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
            onPressed: () {
              _pauseGame();
              _resetGame();
              setState(() {});
            },
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
                '← → Move\n↓ Soft Drop\n↑ Rotate\nSpace Rotate',
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
}

class TetrisPainter extends CustomPainter {
  final List<List<int>> board;
  final List<List<int>> currentPiece;
  final int currentX;
  final int currentY;
  final int currentPieceType;
  final List<Color> pieceColors;

  TetrisPainter({
    required this.board,
    required this.currentPiece,
    required this.currentX,
    required this.currentY,
    required this.currentPieceType,
    required this.pieceColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double cellWidth = size.width / 10; // boardWidth
    final double cellHeight = size.height / 20; // boardHeight

    // Draw board background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF0A0A0B),
    );

    // Draw grid
    for (int y = 0; y < 20; y++) {
      for (int x = 0; x < 10; x++) {
        final rect = Rect.fromLTWH(
          x * cellWidth,
          y * cellHeight,
          cellWidth,
          cellHeight,
        );

        // Draw cell background with subtle gradient
        final gradient = RadialGradient(
          center: const Alignment(0.3, 0.3),
          radius: 1.0,
          colors: [
            const Color(0xFF1A1A1D),
            const Color(0xFF0F0F11),
          ],
        );

        canvas.drawRect(
          rect,
          Paint()..shader = gradient.createShader(rect),
        );

        // Draw subtle grid lines
        canvas.drawRect(
          rect,
          Paint()
            ..color = Colors.cyan.withOpacity(0.1)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.5,
        );

        // Draw placed pieces with glow effect
        if (board[y][x] > 0) {
          final color = pieceColors[board[y][x] - 1];

          // Glow effect
          canvas.drawRect(
            rect.inflate(2),
            Paint()
              ..color = color.withOpacity(0.3)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
          );

          // Main piece with gradient
          final pieceGradient = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.9),
              color.withOpacity(0.7),
              color.withOpacity(0.5),
            ],
          );

          canvas.drawRRect(
            RRect.fromRectAndRadius(rect.deflate(1), const Radius.circular(3)),
            Paint()..shader = pieceGradient.createShader(rect),
          );

          // Highlight
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(rect.left + 2, rect.top + 2, rect.width - 4,
                  rect.height * 0.3),
              const Radius.circular(2),
            ),
            Paint()..color = Colors.white.withOpacity(0.3),
          );
        }
      }
    }

    // Draw current piece with animation
    for (int y = 0; y < currentPiece.length; y++) {
      for (int x = 0; x < currentPiece[y].length; x++) {
        if (currentPiece[y][x] == 1) {
          final boardX = currentX + x;
          final boardY = currentY + y;

          if (boardX >= 0 && boardX < 10 && boardY >= 0 && boardY < 20) {
            final rect = Rect.fromLTWH(
              boardX * cellWidth,
              boardY * cellHeight,
              cellWidth,
              cellHeight,
            );

            final color = pieceColors[currentPieceType];

            // Animated glow
            canvas.drawRect(
              rect.inflate(3),
              Paint()
                ..color = color.withOpacity(0.4)
                ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
            );

            // Main piece with stronger gradient
            final pieceGradient = LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color,
                color.withOpacity(0.8),
                color.withOpacity(0.6),
              ],
            );

            canvas.drawRRect(
              RRect.fromRectAndRadius(
                  rect.deflate(1), const Radius.circular(4)),
              Paint()..shader = pieceGradient.createShader(rect),
            );

            // Strong highlight for current piece
            canvas.drawRRect(
              RRect.fromRectAndRadius(
                Rect.fromLTWH(rect.left + 2, rect.top + 2, rect.width - 4,
                    rect.height * 0.4),
                const Radius.circular(2),
              ),
              Paint()..color = Colors.white.withOpacity(0.5),
            );

            // Border
            canvas.drawRRect(
              RRect.fromRectAndRadius(
                  rect.deflate(1), const Radius.circular(4)),
              Paint()
                ..color = color.withOpacity(0.8)
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1,
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
