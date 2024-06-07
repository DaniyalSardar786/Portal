import 'package:flutter/material.dart';

class CustomizedElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool loading;

  const CustomizedElevatedButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue, // Text color
        shadowColor: Colors.black, // Shadow color
        elevation: 5, // Elevation
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding
      ),
      child: loading
          ? const SizedBox(
        width: 25, // Set the width you want for the indicator
        height: 25, // Set the height you want for the indicator
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2.0, // Optional: change the thickness of the indicator
        ),
      )
          : Text(text),
    );
  }
}
