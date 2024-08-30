import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String hintText;
  final String? errorText;
  final bool obscureText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final void Function(String)? onChanged;
  const MyTextField({super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
  this.keyboardType,
  this.prefixIcon,
  this.errorText,
  this.onChanged});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChanged,
      validator: (value){
        if(value == null || value.isEmpty){
          return "This field is required";
        }else if(value.length <= 2){
          return "enter correct value";
        }
        return null;
      },
      style: const TextStyle(
        color: Colors.black
      ),
      cursorColor: Colors.black,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      controller: widget.controller,
      decoration: InputDecoration(
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red.shade100, width: 2),
        ),
        prefixIcon: widget.prefixIcon,
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        labelStyle: const TextStyle(
          color: Colors.black
        ),
        labelText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }
}
