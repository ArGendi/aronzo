import 'package:flutter/material.dart';
import 'package:yofa/constants.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final Function()? onPressed;
  final double fontSize;
  final Widget? icon;
  const CustomButton({super.key, required this.text, required this.onPressed, this.fontSize = 18, this.icon});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: mainColor,
          foregroundColor: secondColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(widget.icon != null)
                widget.icon!,
              if(widget.icon == null)
                Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}