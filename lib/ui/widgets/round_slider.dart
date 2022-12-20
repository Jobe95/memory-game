import 'package:flutter/material.dart';

class RoundSlider extends StatefulWidget {
  const RoundSlider({
    super.key,
    required this.numRounds,
    required this.onChanged,
  });

  final int numRounds;
  final Function(int numRounds) onChanged;

  @override
  State<RoundSlider> createState() => _RoundSliderState();
}

class _RoundSliderState extends State<RoundSlider> {
  @override
  Widget build(BuildContext context) {
    return Slider(
      value: widget.numRounds.toDouble(),
      min: 0,
      max: 50,
      divisions: 50,
      label: '${widget.numRounds}',
      onChanged: (double newValue) {
        widget.onChanged(newValue.round());
      },
    );
  }
}
