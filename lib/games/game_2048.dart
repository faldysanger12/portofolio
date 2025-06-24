import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class Game2048 extends StatefulWidget {
  const Game2048({super.key});

  @override
  State<Game2048> createState() => _Game2048State();
}

class _Game2048State extends State<Game2048> with TickerProviderStateMixin {
  static const int gridSize = 4;
  List<List<int>> grid = [];
  List<List<int>> previousGrid = [];
  int score = 0;
  int previousScore = 0;
  int bestScore = 0;
  bool gameOver = false;
  bool hasWon = false;

  late AnimationController _moveController;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _moveController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _initializeGame();
  }

  @override
  void dispose() {
    _moveController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _initializeGame() {
    grid = List.generate(gridSize, (i) => List.generate(gridSize, (j) => 0));
    score = 0;
    gameOver = false;
    hasWon = false;
    _addRandomTile();
    _addRandomTile();
    setState(() {});
  }

  void _addRandomTile() {
    List<List<int>> emptyCells = [];
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (grid[i][j] == 0) {
          emptyCells.add([i, j]);
        }
      }
    }

    if (emptyCells.isNotEmpty) {
      List<int> randomCell = emptyCells[Random().nextInt(emptyCells.length)];
      grid[randomCell[0]][randomCell[1]] = Random().nextDouble() < 0.9 ? 2 : 4;

      _scaleController.forward().then((_) {
        _scaleController.reverse();
      });
    }
  }

  void _saveState() {
    previousGrid = grid.map((row) => List<int>.from(row)).toList();
    previousScore = score;
  }

  void _undo() {
    if (previousGrid.isNotEmpty) {
      setState(() {
        grid = previousGrid.map((row) => List<int>.from(row)).toList();
        score = previousScore;
        gameOver = false;
      });
    }
  }

  bool _canMove() {
    // Check for empty cells
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (grid[i][j] == 0) return true;
      }
    }

    // Check for possible merges
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        int current = grid[i][j];
        if ((i < gridSize - 1 && grid[i + 1][j] == current) ||
            (j < gridSize - 1 && grid[i][j + 1] == current)) {
          return true;
        }
      }
    }

    return false;
  }

  void _move(String direction) {
    if (gameOver) return;

    _saveState();
    bool moved = false;

    switch (direction) {
      case 'left':
        moved = _moveLeft();
        break;
      case 'right':
        moved = _moveRight();
        break;
      case 'up':
        moved = _moveUp();
        break;
      case 'down':
        moved = _moveDown();
        break;
    }

    if (moved) {
      _moveController.forward().then((_) {
        _moveController.reverse();
        _addRandomTile();

        if (!_canMove()) {
          gameOver = true;
          _showGameOverDialog();
        }

        if (score > bestScore) {
          bestScore = score;
        }

        // Check for 2048 tile
        if (!hasWon) {
          for (int i = 0; i < gridSize; i++) {
            for (int j = 0; j < gridSize; j++) {
              if (grid[i][j] == 2048) {
                hasWon = true;
                _showWinDialog();
                break;
              }
            }
          }
        }

        setState(() {});
      });
    }
  }

  bool _moveLeft() {
    bool moved = false;
    for (int i = 0; i < gridSize; i++) {
      List<int> row = grid[i].where((cell) => cell != 0).toList();

      // Merge tiles
      for (int j = 0; j < row.length - 1; j++) {
        if (row[j] == row[j + 1]) {
          row[j] *= 2;
          score += row[j];
          row.removeAt(j + 1);
        }
      }

      // Fill with zeros
      while (row.length < gridSize) {
        row.add(0);
      }

      // Check if row changed
      for (int j = 0; j < gridSize; j++) {
        if (grid[i][j] != row[j]) {
          moved = true;
        }
        grid[i][j] = row[j];
      }
    }
    return moved;
  }

  bool _moveRight() {
    bool moved = false;
    for (int i = 0; i < gridSize; i++) {
      List<int> row = grid[i].where((cell) => cell != 0).toList();

      // Merge tiles (from right)
      for (int j = row.length - 1; j > 0; j--) {
        if (row[j] == row[j - 1]) {
          row[j] *= 2;
          score += row[j];
          row.removeAt(j - 1);
          j--;
        }
      }

      // Fill with zeros at the beginning
      while (row.length < gridSize) {
        row.insert(0, 0);
      }

      // Check if row changed
      for (int j = 0; j < gridSize; j++) {
        if (grid[i][j] != row[j]) {
          moved = true;
        }
        grid[i][j] = row[j];
      }
    }
    return moved;
  }

  bool _moveUp() {
    bool moved = false;
    for (int j = 0; j < gridSize; j++) {
      List<int> column = [];
      for (int i = 0; i < gridSize; i++) {
        if (grid[i][j] != 0) {
          column.add(grid[i][j]);
        }
      }

      // Merge tiles
      for (int i = 0; i < column.length - 1; i++) {
        if (column[i] == column[i + 1]) {
          column[i] *= 2;
          score += column[i];
          column.removeAt(i + 1);
        }
      }

      // Fill with zeros
      while (column.length < gridSize) {
        column.add(0);
      }

      // Check if column changed
      for (int i = 0; i < gridSize; i++) {
        if (grid[i][j] != column[i]) {
          moved = true;
        }
        grid[i][j] = column[i];
      }
    }
    return moved;
  }

  bool _moveDown() {
    bool moved = false;
    for (int j = 0; j < gridSize; j++) {
      List<int> column = [];
      for (int i = 0; i < gridSize; i++) {
        if (grid[i][j] != 0) {
          column.add(grid[i][j]);
        }
      }

      // Merge tiles (from bottom)
      for (int i = column.length - 1; i > 0; i--) {
        if (column[i] == column[i - 1]) {
          column[i] *= 2;
          score += column[i];
          column.removeAt(i - 1);
          i--;
        }
      }

      // Fill with zeros at the beginning
      while (column.length < gridSize) {
        column.insert(0, 0);
      }

      // Check if column changed
      for (int i = 0; i < gridSize; i++) {
        if (grid[i][j] != column[i]) {
          moved = true;
        }
        grid[i][j] = column[i];
      }
    }
    return moved;
  }

  Color _getTileColor(int value) {
    switch (value) {
      case 0:
        return Colors.grey[300]!;
      case 2:
        return const Color(0xFFEEE4DA);
      case 4:
        return const Color(0xFFEDE0C8);
      case 8:
        return const Color(0xFFF2B179);
      case 16:
        return const Color(0xFFF59563);
      case 32:
        return const Color(0xFFF67C5F);
      case 64:
        return const Color(0xFFF65E3B);
      case 128:
        return const Color(0xFFEDCF72);
      case 256:
        return const Color(0xFFEDCC61);
      case 512:
        return const Color(0xFFEDC850);
      case 1024:
        return const Color(0xFFEDC53F);
      case 2048:
        return const Color(0xFFEDC22E);
      default:
        return const Color(0xFF3C3A32);
    }
  }

  Color _getTextColor(int value) {
    return value <= 4 ? const Color(0xFF776E65) : Colors.white;
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.red, width: 2),
        ),
        title: const Text(
          '💥 GAME OVER',
          style: TextStyle(
            color: Colors.red,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sentiment_dissatisfied,
                size: 50, color: Colors.red),
            const SizedBox(height: 10),
            Text(
              'Final Score: $score',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            Text(
              'Best Score: $bestScore',
              style: const TextStyle(color: Colors.yellow, fontSize: 16),
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
                    _initializeGame();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('TRY AGAIN'),
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
                    side: const BorderSide(color: Colors.red),
                    foregroundColor: Colors.red,
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

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.yellow, width: 2),
        ),
        title: const Text(
          '🎉 YOU WIN!',
          style: TextStyle(
            color: Colors.yellow,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, size: 50, color: Colors.yellow),
            const SizedBox(height: 10),
            const Text(
              'You reached 2048!',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Text(
              'Score: $score',
              style: const TextStyle(color: Colors.yellow, fontSize: 16),
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
                    // Continue playing
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('CONTINUE'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _initializeGame();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('NEW GAME'),
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
      backgroundColor: const Color(0xFFFAF8EF),
      body: SafeArea(
        child: GestureDetector(
          onPanEnd: (details) {
            if (details.velocity.pixelsPerSecond.dx.abs() >
                details.velocity.pixelsPerSecond.dy.abs()) {
              // Horizontal swipe
              if (details.velocity.pixelsPerSecond.dx > 0) {
                _move('right');
              } else {
                _move('left');
              }
            } else {
              // Vertical swipe
              if (details.velocity.pixelsPerSecond.dy > 0) {
                _move('down');
              } else {
                _move('up');
              }
            }
          },
          child: KeyboardListener(
            focusNode: FocusNode()..requestFocus(),
            onKeyEvent: (event) {
              if (event is KeyDownEvent) {
                switch (event.logicalKey) {
                  case LogicalKeyboardKey.arrowLeft:
                  case LogicalKeyboardKey.keyA:
                    _move('left');
                    break;
                  case LogicalKeyboardKey.arrowRight:
                  case LogicalKeyboardKey.keyD:
                    _move('right');
                    break;
                  case LogicalKeyboardKey.arrowUp:
                  case LogicalKeyboardKey.keyW:
                    _move('up');
                    break;
                  case LogicalKeyboardKey.arrowDown:
                  case LogicalKeyboardKey.keyS:
                    _move('down');
                    break;
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Header
                  _buildHeader(),

                  const SizedBox(height: 20),

                  // Game board
                  Expanded(
                    child: Center(
                      child: _buildGameBoard(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Controls
                  _buildControls(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '2048',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Color(0xFF776E65),
          ),
        ),
        Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFBBADA0),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: [
                  const Text(
                    'SCORE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$score',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFBBADA0),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: [
                  const Text(
                    'BEST',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$bestScore',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGameBoard() {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFBBADA0),
          borderRadius: BorderRadius.circular(10),
        ),
        child: AnimatedBuilder(
          animation: _scaleController,
          builder: (context, child) {
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridSize,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: gridSize * gridSize,
              itemBuilder: (context, index) {
                int row = index ~/ gridSize;
                int col = index % gridSize;
                int value = grid[row][col];

                return AnimatedBuilder(
                  animation: _moveController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: value == 0
                          ? 1.0
                          : (1.0 + _scaleController.value * 0.1),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _getTileColor(value),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: value > 0
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(2, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: value > 0
                              ? Text(
                                  '$value',
                                  style: TextStyle(
                                    fontSize: value < 128
                                        ? 32
                                        : value < 1024
                                            ? 28
                                            : 24,
                                    fontWeight: FontWeight.bold,
                                    color: _getTextColor(value),
                                  ),
                                )
                              : null,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _initializeGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8F7A66),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: const Text('NEW GAME'),
            ),
            ElevatedButton(
              onPressed: previousGrid.isNotEmpty ? _undo : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEDCC61),
                foregroundColor: const Color(0xFF776E65),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: const Text('UNDO'),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Swipe instructions
        const Text(
          '📱 Swipe or use ⌨️ Arrow keys/WASD to move tiles',
          style: TextStyle(
            color: Color(0xFF776E65),
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 10),

        const Text(
          'Join numbers to reach 2048!',
          style: TextStyle(
            color: Color(0xFF776E65),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
