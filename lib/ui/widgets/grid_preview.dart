import 'package:flutter/material.dart';

class GridPreview extends StatelessWidget {
  const GridPreview({
    super.key,
    required this.amount,
  });
  final int amount;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width / 3,
      height: width / 3,
      child: GridView.count(
        crossAxisCount: amount,
        children: List.generate(amount * amount, (index) {
          return Container(
            margin: const EdgeInsets.all(1.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(color: Colors.grey),
              color: Colors.greenAccent,
            ),
          );
        }),
      ),
    );
  }
}
