import 'package:flutter/material.dart';

class CustomDialpad extends StatelessWidget {
  final Function(String) onDigitPressed;
  final Function() onClearPressed;
  final Function() onCallPressed;

  const CustomDialpad({
    Key? key,
    required this.onDigitPressed,
    required this.onClearPressed,
    required this.onCallPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('1'),
              _buildButton('2'),
              _buildButton('3'),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('4'),
              _buildButton('5'),
              _buildButton('6'),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('7'),
              _buildButton('8'),
              _buildButton('9'),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('Clear', onTap: onClearPressed),
              _buildButton('0'),
              _buildCallButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String label, {Function()? onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap != null ? onTap : () => onDigitPressed(label),
        child: Container(
          height: 64.0,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(fontSize: 24.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCallButton() {
    return Expanded(
      child: InkWell(
        onTap: onCallPressed,
        child: Container(
          height: 64.0,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Icon(
              Icons.phone,
              size: 36.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
