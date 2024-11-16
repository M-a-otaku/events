import 'package:flutter/material.dart';

class NumberPicker extends  StatefulWidget {
  final int initialValue;
  final int min;
  final int max;
  final int step;
  final Function(int) onChanged;

  const NumberPicker({
    super.key,
    required this.initialValue,
    required this.min,
    required this.max,
    required this.step,
    required this.onChanged
  });

  @override
  State<NumberPicker> createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker> {
  int _currentValue = 0;

  @override
  void initState() {
    super.initState();

    _currentValue = widget.initialValue;
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(onPressed: (){
          setState(() {
            if(_currentValue > widget.min){
              _currentValue -= widget.step;
            }
            widget.onChanged (_currentValue);
          });
        }, icon: const Icon(Icons.remove_circle,color: Colors.redAccent,)),
        Text(
          _currentValue.toString(),
          style: TextStyle(fontSize: 30),
        ),
        IconButton(onPressed: (){
          setState(() {
            if(_currentValue < widget.max){
              _currentValue += widget.step;
            }
            widget.onChanged (_currentValue);
          });
        }, icon: const Icon(Icons.add_circle,color: Colors.greenAccent)),
      ],
    );

  }
}