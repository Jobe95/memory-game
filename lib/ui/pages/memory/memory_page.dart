import 'package:flutter/material.dart';
import 'dart:math' as math;

class MemoryPage extends StatefulWidget {
  const MemoryPage({
    super.key,
    required this.rows,
    required this.columns,
    required this.maxRounds,
  });

  final int rows;
  final int columns;
  final int maxRounds;

  @override
  State<MemoryPage> createState() => _MemoryPageState();
}

class _MemoryPageState extends State<MemoryPage> {
  final int animationDuration = 500;
  int animatingCard1 = -1;
  int animatingCard2 = -1;

  int rows = 4;
  int columns = 4;
  int counter = 0;
  int maxRounds = 0;
  int helpCounter = 0;
  List<List<int>> grid = [];
  List<bool> revealed = [];
  int firstRevealed = -1;
  int secondRevealed = -1;
  bool waiting = false;

  @override
  void initState() {
    super.initState();

    rows = widget.rows;
    columns = widget.columns;
    maxRounds = widget.maxRounds;

    for (var i = 0; i < rows; i++) {
      List<int> row = [];
      for (var j = 0; j < columns; j++) {
        row.add(0);
      }
      grid.add(row);
    }
    for (int i = 0; i < rows * columns; i++) {
      revealed.add(false);
    }

    assignPairs();
  }

  void assignPairs() {
    List<int> values = [];
    for (int i = 0; i < rows * columns / 2; i++) {
      values.add(i);
      values.add(i);
    }
    values.shuffle();
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        grid[i][j] = values[i * columns + j];
      }
    }
  }

  void findMatch() {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        if (revealed[i * columns + j]) {
          continue;
        }
        int value = grid[i][j];
        for (int k = i; k < rows; k++) {
          for (int l = 0; l < columns; l++) {
            if (k == i && l <= j) {
              continue;
            }
            if (grid[k][l] == value && !revealed[k * columns + l]) {
              int index1 = i * columns + j;
              int index2 = k * columns + l;
              print('Found match at $index1 and $index2');
              setState(() {
                helpCounter++;
              });
              animateCards(index1, index2);
              return;
            }
          }
        }
      }
    }
    print('No match found');
  }

  void animateCards(int index1, int index2) {
    setState(() {
      animatingCard1 = index1;
      animatingCard2 = index2;
    });
    Future.delayed(Duration(milliseconds: animationDuration), () {
      setState(() {
        animatingCard1 = -1;
        animatingCard2 = -1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        'Rounds: $counter / $maxRounds',
                        style: TextStyle(
                          fontSize: 24,
                          color: counter >= maxRounds
                              ? Colors.redAccent
                              : Colors.green,
                        ),
                      ),
                      if (helpCounter > 0)
                        Text(
                          ' / $helpCounter',
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.redAccent,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    findMatch();
                  },
                  icon: const Icon(Icons.question_mark),
                )
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double itemSize =
                    (constraints.maxWidth - columns * 6 * 2) / columns;
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                    childAspectRatio: 1,
                    mainAxisExtent: itemSize,
                  ),
                  itemBuilder: (context, index) {
                    int row = index ~/ columns;
                    int column = index % columns;
                    return GestureDetector(
                      onTap: () {
                        if (waiting || revealed[index]) {
                          return;
                        }

                        setState(() {
                          revealed[index] = true;
                        });
                        if (firstRevealed == -1) {
                          firstRevealed = index;
                        } else {
                          secondRevealed = index;
                          waiting = true;
                          Future.delayed(const Duration(seconds: 1), () {
                            setState(() {
                              counter++;
                              int firstTapRow = firstRevealed ~/ columns;
                              int firstTapCol = firstRevealed % columns;
                              final firstValue = grid[firstTapRow][firstTapCol];
                              final secondValue = grid[row][column];

                              if (firstValue != secondValue) {
                                revealed[firstRevealed] = false;
                                revealed[secondRevealed] = false;
                              }
                              firstRevealed = -1;
                              secondRevealed = -1;
                              waiting = false;
                            });
                          });
                        }
                      },
                      child: AnimatedContainer(
                        key: Key(index.toString()),
                        margin: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: (index == animatingCard1 ||
                                      index == animatingCard2) ||
                                  revealed[index]
                              ? Colors.greenAccent
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              spreadRadius: 1,
                              offset: Offset(0, 2),
                            )
                          ],
                        ),
                        duration: Duration(milliseconds: animationDuration),
                        curve: Curves.easeInOut,
                        child: Center(
                          child: Text(
                            revealed[index] ? grid[row][column].toString() : '',
                            style: TextStyle(
                                fontSize: itemSize < 50
                                    ? 14
                                    : itemSize < 80
                                        ? 20
                                        : 32),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: rows * columns,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
