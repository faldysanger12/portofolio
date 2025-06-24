import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:math';

class TetrisGameScreen extends StatelessWidget {
  const TetrisGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A3A),
        title: Text(
          'Tetris Game',
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
      body: const TetrisGame(),
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
            Text('⬅️ ➡️ Arrow keys to move left/right',
                style: GoogleFonts.inter(color: Colors.white)),
            const SizedBox(height: 8),
            Text('⬇️ Down arrow to move faster',
                style: GoogleFonts.inter(color: Colors.white)),
            const SizedBox(height: 8),
            Text('⬆️ Up arrow or Space to rotate',
                style: GoogleFonts.inter(color: Colors.white)),
            const SizedBox(height: 8),
            Text('🎯 Complete lines to score points',
                style: GoogleFonts.inter(color: Colors.white)),
            const SizedBox(height: 8),
            Text('💥 Game ends when blocks reach top',
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

class TetrisGame extends StatefulWidget {
  const TetrisGame({super.key});

  @override
  State<TetrisGame> createState() => _TetrisGameState();
}

class _TetrisGameState extends State<TetrisGame> {
  static const int boardWidth = 10;
  static const int boardHeight = 20;
  static const double blockSize = 25.0;

  List<List<Color?>> board = [];
  TetrisPiece? currentPiece;
  TetrisPiece? nextPiece;

  int score = 0;
  int level = 1;
  int linesCleared = 0;
  bool gameOver = false;
  bool gamePaused = false;

  Timer? gameTimer;
  final Random random = Random();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initializeBoard();
    _startGame();
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _initializeBoard() {
    board = List.generate(
      boardHeight,
      (row) => List.generate(boardWidth, (col) => null),
    );
  }

  void _startGame() {
    _spawnNewPiece();
    _startGameTimer();
  }

  void _startGameTimer() {
    gameTimer?.cancel();
    final speed = Duration(milliseconds: max(100, 800 - (level * 50)));
    gameTimer = Timer.periodic(speed, (timer) {
      if (!gameOver && !gamePaused) {
        _movePieceDown();
      }
    });
  }

  void _spawnNewPiece() {
    if (nextPiece != null) {
      currentPiece = nextPiece;
    } else {
      currentPiece = _getRandomPiece();
    }
    nextPiece = _getRandomPiece();

    currentPiece!.x = boardWidth ~/ 2 - 1;
    currentPiece!.y = 0;

    if (_isColliding(currentPiece!)) {
      _endGame();
    }
  }

  TetrisPiece _getRandomPiece() {
    final pieces = [
      TetrisPiece.i(),
      TetrisPiece.o(),
      TetrisPiece.t(),
      TetrisPiece.s(),
      TetrisPiece.z(),
      TetrisPiece.j(),
      TetrisPiece.l(),
    ];
    return pieces[random.nextInt(pieces.length)];
  }

  void _movePieceDown() {
    if (currentPiece == null) return;

    currentPiece!.y++;
    if (_isColliding(currentPiece!)) {
      currentPiece!.y--;
      _placePiece();
      _clearLines();
      _spawnNewPiece();
    }
    setState(() {});
  }

  void _movePieceLeft() {
    if (currentPiece == null) return;

    currentPiece!.x--;
    if (_isColliding(currentPiece!)) {
      currentPiece!.x++;
    }
    setState(() {});
  }

  void _movePieceRight() {
    if (currentPiece == null) return;

    currentPiece!.x++;
    if (_isColliding(currentPiece!)) {
      currentPiece!.x--;
    }
    setState(() {});
  }

  void _rotatePiece() {
    if (currentPiece == null) return;

    final oldShape = currentPiece!.shape;
    currentPiece!.rotate();
    if (_isColliding(currentPiece!)) {
      currentPiece!.shape = oldShape;
    }
    setState(() {});
  }

  bool _isColliding(TetrisPiece piece) {
    for (int row = 0; row < piece.shape.length; row++) {
      for (int col = 0; col < piece.shape[row].length; col++) {
        if (piece.shape[row][col] == 1) {
          final boardX = piece.x + col;
          final boardY = piece.y + row;

          if (boardX < 0 ||
              boardX >= boardWidth ||
              boardY >= boardHeight ||
              (boardY >= 0 && board[boardY][boardX] != null)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void _placePiece() {
    if (currentPiece == null) return;

    for (int row = 0; row < currentPiece!.shape.length; row++) {
      for (int col = 0; col < currentPiece!.shape[row].length; col++) {
        if (currentPiece!.shape[row][col] == 1) {
          final boardX = currentPiece!.x + col;
          final boardY = currentPiece!.y + row;

          if (boardY >= 0 &&
              boardY < boardHeight &&
              boardX >= 0 &&
              boardX < boardWidth) {
            board[boardY][boardX] = currentPiece!.color;
          }
        }
      }
    }
  }

  void _clearLines() {
    int clearedCount = 0;

    for (int row = boardHeight - 1; row >= 0; row--) {
      if (board[row].every((cell) => cell != null)) {
        board.removeAt(row);
        board.insert(0, List.generate(boardWidth, (col) => null));
        row++; // Check the same row again
        clearedCount++;
      }
    }

    if (clearedCount > 0) {
      linesCleared += clearedCount;
      score += clearedCount * 100 * level;
      level = (linesCleared ~/ 10) + 1;
      _startGameTimer(); // Update speed
    }
  }

  void _endGame() {
    gameOver = true;
    gameTimer?.cancel();
    setState(() {});
  }

  void _restartGame() {
    setState(() {
      gameOver = false;
      gamePaused = false;
      score = 0;
      level = 1;
      linesCleared = 0;
      _initializeBoard();
      _startGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent && !gameOver && !gamePaused) {
          switch (event.logicalKey) {
            case LogicalKeyboardKey.arrowLeft:
              _movePieceLeft();
              return KeyEventResult.handled;
            case LogicalKeyboardKey.arrowRight:
              _movePieceRight();
              return KeyEventResult.handled;
            case LogicalKeyboardKey.arrowDown:
              _movePieceDown();
              return KeyEventResult.handled;
            case LogicalKeyboardKey.arrowUp:
            case LogicalKeyboardKey.space:
              _rotatePiece();
              return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Game Board
            Container(
              width: boardWidth * blockSize,
              height: boardHeight * blockSize,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                color: const Color(0xFF1A1A3A),
              ),
              child: CustomPaint(
                painter: TetrisPainter(
                  board: board,
                  currentPiece: currentPiece,
                  blockSize: blockSize,
                ),
              ),
            ),

            const SizedBox(width: 30),

            // Score Panel
            Container(
              width: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A3A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF6366F1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Score: $score',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Level: $level',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lines: $linesCleared',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Next Piece Preview
                  if (nextPiece != null) ...[
                    Text(
                      'Next:',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: const Color(0xFF0F0F23),
                      ),
                      child: CustomPaint(
                        painter: NextPiecePainter(
                          piece: nextPiece!,
                          blockSize: 15,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  if (gameOver) ...[
                    Text(
                      'Game Over!',
                      style: GoogleFonts.inter(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _restartGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Restart', style: GoogleFonts.inter()),
                    ),
                  ] else ...[
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          gamePaused = !gamePaused;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        gamePaused ? 'Resume' : 'Pause',
                        style: GoogleFonts.inter(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TetrisPiece {
  List<List<int>> shape;
  int x;
  int y;
  Color color;

  TetrisPiece({
    required this.shape,
    required this.color,
    this.x = 0,
    this.y = 0,
  });

  factory TetrisPiece.i() => TetrisPiece(
        shape: [
          [1, 1, 1, 1],
        ],
        color: Colors.cyan,
      );

  factory TetrisPiece.o() => TetrisPiece(
        shape: [
          [1, 1],
          [1, 1],
        ],
        color: Colors.yellow,
      );

  factory TetrisPiece.t() => TetrisPiece(
        shape: [
          [0, 1, 0],
          [1, 1, 1],
        ],
        color: Colors.purple,
      );

  factory TetrisPiece.s() => TetrisPiece(
        shape: [
          [0, 1, 1],
          [1, 1, 0],
        ],
        color: Colors.green,
      );

  factory TetrisPiece.z() => TetrisPiece(
        shape: [
          [1, 1, 0],
          [0, 1, 1],
        ],
        color: Colors.red,
      );

  factory TetrisPiece.j() => TetrisPiece(
        shape: [
          [1, 0, 0],
          [1, 1, 1],
        ],
        color: Colors.blue,
      );

  factory TetrisPiece.l() => TetrisPiece(
        shape: [
          [0, 0, 1],
          [1, 1, 1],
        ],
        color: Colors.orange,
      );

  void rotate() {
    final rows = shape.length;
    final cols = shape[0].length;
    final rotated = List.generate(cols, (i) => List.generate(rows, (j) => 0));

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        rotated[j][rows - 1 - i] = shape[i][j];
      }
    }

    shape = rotated;
  }
}

class TetrisPainter extends CustomPainter {
  final List<List<Color?>> board;
  final TetrisPiece? currentPiece;
  final double blockSize;

  TetrisPainter({
    required this.board,
    required this.currentPiece,
    required this.blockSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Draw board
    for (int row = 0; row < board.length; row++) {
      for (int col = 0; col < board[row].length; col++) {
        final color = board[row][col];
        if (color != null) {
          paint.color = color;
          final rect = Rect.fromLTWH(
            col * blockSize,
            row * blockSize,
            blockSize - 1,
            blockSize - 1,
          );
          canvas.drawRect(rect, paint);
        }
      }
    }

    // Draw current piece
    if (currentPiece != null) {
      paint.color = currentPiece!.color;
      for (int row = 0; row < currentPiece!.shape.length; row++) {
        for (int col = 0; col < currentPiece!.shape[row].length; col++) {
          if (currentPiece!.shape[row][col] == 1) {
            final x = (currentPiece!.x + col) * blockSize;
            final y = (currentPiece!.y + row) * blockSize;
            final rect = Rect.fromLTWH(x, y, blockSize - 1, blockSize - 1);
            canvas.drawRect(rect, paint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class NextPiecePainter extends CustomPainter {
  final TetrisPiece piece;
  final double blockSize;

  NextPiecePainter({
    required this.piece,
    required this.blockSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = piece.color;

    final offsetX = (size.width - piece.shape[0].length * blockSize) / 2;
    final offsetY = (size.height - piece.shape.length * blockSize) / 2;

    for (int row = 0; row < piece.shape.length; row++) {
      for (int col = 0; col < piece.shape[row].length; col++) {
        if (piece.shape[row][col] == 1) {
          final rect = Rect.fromLTWH(
            offsetX + col * blockSize,
            offsetY + row * blockSize,
            blockSize - 1,
            blockSize - 1,
          );
          canvas.drawRect(rect, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
