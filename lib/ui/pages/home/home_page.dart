import 'package:flutter/material.dart';
import 'package:memory/ui/pages/pages.dart';
import 'package:memory/ui/widgets/widgets.dart';

enum MemoryDifficulty { easy, medium, hard }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int numRounds = 25;
  int rows = 6;
  int columns = 6;
  MemoryDifficulty difficulty = MemoryDifficulty.medium;

  @override
  void initState() {
    super.initState();
  }

  void setDifficulty(MemoryDifficulty difficulty) {
    setState(() {
      this.difficulty = difficulty;
      switch (difficulty) {
        case MemoryDifficulty.easy:
          numRounds = 50;
          rows = 4;
          columns = 4;
          break;
        case MemoryDifficulty.medium:
          numRounds = 25;
          rows = 6;
          columns = 6;
          break;
        case MemoryDifficulty.hard:
          numRounds = 15;
          rows = 8;
          columns = 8;
          break;
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GridPreview(
                rows: rows,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(20),
                        backgroundColor: difficulty == MemoryDifficulty.easy
                            ? Colors.greenAccent.withOpacity(.75)
                            : null),
                    onPressed: () => setDifficulty(MemoryDifficulty.easy),
                    child: const Text('Nybörjare'),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(20),
                        backgroundColor: difficulty == MemoryDifficulty.medium
                            ? Colors.greenAccent.withOpacity(.75)
                            : null),
                    onPressed: () => setDifficulty(MemoryDifficulty.medium),
                    child: const Text('Medel'),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      backgroundColor: difficulty == MemoryDifficulty.hard
                          ? Colors.greenAccent.withOpacity(.75)
                          : null,
                    ),
                    onPressed: () => setDifficulty(MemoryDifficulty.hard),
                    child: const Text('Svår'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text('Rounds'),
              const SizedBox(height: 10),
              RoundSlider(
                numRounds: numRounds,
                onChanged: (rounds) {
                  setState(() {
                    numRounds = rounds;
                  });
                },
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MemoryPage(
                        rows: rows,
                        columns: columns,
                        maxRounds: numRounds,
                      ),
                    ),
                  );
                },
                child: const Text('Play new game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
