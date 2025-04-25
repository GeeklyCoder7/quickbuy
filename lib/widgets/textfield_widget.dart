import 'package:ecommerce_application/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';

class TextfieldWidget extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType inputType;
  final bool isMultiLine;

  const TextfieldWidget({
    super.key,
    required this.hintText,
    required this.controller,
    this.inputType = TextInputType.text,
    this.isMultiLine = false,
  });

  @override
  State<TextfieldWidget> createState() => _TextfieldWidgetState();
}

class _TextfieldWidgetState extends State<TextfieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.inputType,
        maxLines: widget.isMultiLine ? null : 1,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter ${widget.hintText}";
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: widget.hintText,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.primary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      ),
    );
  }
}
