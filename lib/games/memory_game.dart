import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class MemoryGame extends StatefulWidget {
  const MemoryGame({super.key});

  @override
  State<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> with TickerProviderStateMixin {
  static const int gridSize = 4;
  static const int totalCards = gridSize * gridSize;

  List<int> cardValues = [];
  List<bool> flippedCards = [];
  List<bool> matchedCards = [];
  List<int> selectedCards = [];

  int moves = 0;
  int matches = 0;
  bool isGameActive = false;
  bool isGameWon = false;
  Timer? flipTimer;
  Stopwatch gameTimer = Stopwatch();

  late AnimationController _flipController;
  late AnimationController _matchController;
  late AnimationController _winController;

  List<String> cardIcons = [
    '🎮',
    '🎯',
    '🎲',
    '🎪',
    '🎨',
    '🎭',
    '🎸',
    '🎹',
    '⚽',
    '🏀',
    '🏈',
    '⚾',
    '🎾',
    '🏐',
    '🏓',
    '🥅',
  ];

  @override
  void initState() {
    super.initState();

    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _matchController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _winController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _initializeGame();
  }

  @override
  void dispose() {
    _flipController.dispose();
    _matchController.dispose();
    _winController.dispose();
    flipTimer?.cancel();
    super.dispose();
  }

  void _initializeGame() {
    setState(() {
      cardValues = [];
      flippedCards = List.filled(totalCards, false);
      matchedCards = List.filled(totalCards, false);
      selectedCards = [];
      moves = 0;
      matches = 0;
      isGameActive = false;
      isGameWon = false;
    });

    gameTimer.reset();

    // Create pairs of cards
    List<int> values = [];
    for (int i = 0; i < totalCards ~/ 2; i++) {
      values.add(i);
      values.add(i);
    }

    // Shuffle cards
    values.shuffle(Random());
    cardValues = values;
  }

  void _startGame() {
    setState(() {
      isGameActive = true;
    });
    gameTimer.start();

    // Show all cards briefly
    setState(() {
      flippedCards = List.filled(totalCards, true);
    });

    Timer(const Duration(seconds: 2), () {
      setState(() {
        flippedCards = List.filled(totalCards, false);
      });
    });
  }

  void _flipCard(int index) {
    if (!isGameActive ||
        flippedCards[index] ||
        matchedCards[index] ||
        selectedCards.length >= 2) {
      return;
    }

    setState(() {
      flippedCards[index] = true;
      selectedCards.add(index);
    });

    _flipController.forward().then((_) {
      _flipController.reverse();
    });

    if (selectedCards.length == 2) {
      moves++;
      _checkMatch();
    }
  }

  void _checkMatch() {
    int first = selectedCards[0];
    int second = selectedCards[1];

    if (cardValues[first] == cardValues[second]) {
      // Match found!
      _matchController.forward().then((_) {
        _matchController.reverse();
      });

      setState(() {
        matchedCards[first] = true;
        matchedCards[second] = true;
        matches++;
        selectedCards.clear();
      });

      if (matches == totalCards ~/ 2) {
        _winGame();
      }
    } else {
      // No match, flip back after delay
      flipTimer = Timer(const Duration(milliseconds: 1000), () {
        setState(() {
          flippedCards[first] = false;
          flippedCards[second] = false;
          selectedCards.clear();
        });
      });
    }
  }

  void _winGame() {
    gameTimer.stop();
    setState(() {
      isGameWon = true;
      isGameActive = false;
    });

    _winController.forward();

    Timer(const Duration(milliseconds: 500), () {
      _showWinDialog();
    });
  }

  void _showWinDialog() {
    int seconds = gameTimer.elapsed.inSeconds;
    int minutes = seconds ~/ 60;
    seconds = seconds % 60;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.purple[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.yellow, width: 3),
        ),
        title: const Text(
          '🎉 CONGRATULATIONS!',
          style: TextStyle(
            color: Colors.yellow,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.psychology,
              size: 60,
              color: Colors.yellow,
            ),
            const SizedBox(height: 20),
            const Text(
              'You matched all pairs!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Time:',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Moves:',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        '$moves',
                        style: const TextStyle(
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Accuracy:',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        '${((matches / moves) * 100).toStringAsFixed(1)}%',
                        style: const TextStyle(
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
                  child: const Text('PLAY AGAIN'),
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

  String _getFormattedTime() {
    int seconds = gameTimer.elapsed.inSeconds;
    int minutes = seconds ~/ 60;
    seconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[900],
      body: SafeArea(
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

              // Instructions
              if (!isGameActive && !isGameWon) _buildInstructions(),
            ],
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
          '🧠 MEMORY',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.yellow,
          ),
        ),
        Row(
          children: [
            _buildStatCard('TIME', _getFormattedTime()),
            const SizedBox(width: 10),
            _buildStatCard('MOVES', '$moves'),
            const SizedBox(width: 10),
            _buildStatCard('PAIRS', '$matches/${totalCards ~/ 2}'),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.purple[300]!, width: 1),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.yellow,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameBoard() {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.purple[300]!, width: 2),
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridSize,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: totalCards,
          itemBuilder: (context, index) {
            return _buildCard(index);
          },
        ),
      ),
    );
  }

  Widget _buildCard(int index) {
    bool isFlipped = flippedCards[index] || matchedCards[index];
    bool isMatched = matchedCards[index];
    bool isSelected = selectedCards.contains(index);

    return GestureDetector(
      onTap: () => _flipCard(index),
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _flipController,
          _matchController,
          _winController,
        ]),
        builder: (context, child) {
          double scale = 1.0;

          if (isSelected) {
            scale += _flipController.value * 0.1;
          }

          if (isMatched) {
            scale += _matchController.value * 0.2;
          }

          if (isGameWon && isMatched) {
            scale += _winController.value * 0.1;
          }

          return Transform.scale(
            scale: scale,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isFlipped
                      ? isMatched
                          ? [Colors.green[400]!, Colors.green[600]!]
                          : [Colors.blue[400]!, Colors.blue[600]!]
                      : [Colors.purple[400]!, Colors.purple[700]!],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(2, 4),
                  ),
                ],
                border: Border.all(
                  color: isSelected
                      ? Colors.yellow
                      : isMatched
                          ? Colors.green[300]!
                          : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Center(
                child: isFlipped
                    ? Text(
                        cardIcons[cardValues[index] % cardIcons.length],
                        style: const TextStyle(
                          fontSize: 32,
                        ),
                      )
                    : Icon(
                        Icons.psychology,
                        size: 32,
                        color: Colors.white.withOpacity(0.7),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: isGameActive ? null : _startGame,
          icon: const Icon(Icons.play_arrow),
          label: const Text('START'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        ElevatedButton.icon(
          onPressed: _initializeGame,
          icon: const Icon(Icons.refresh),
          label: const Text('RESET'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildInstructions() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.purple[300]!, width: 1),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.psychology,
            size: 40,
            color: Colors.yellow,
          ),
          SizedBox(height: 10),
          Text(
            'MEMORY CHALLENGE',
            style: TextStyle(
              color: Colors.yellow,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Flip cards to find matching pairs!\nMemorize the positions and match them all.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            '🎯 Goal: Match all pairs in minimum moves',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
