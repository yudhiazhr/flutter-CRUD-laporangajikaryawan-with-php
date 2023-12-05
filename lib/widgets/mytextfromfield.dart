import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final dynamic validator;
  final TextEditingController controller;
  final String name;
  final dynamic onSaved;
  final bool enabled;
 

  MyTextFormField ({required this.controller, required this.name, required this.validator, required this.onSaved , required this.enabled});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      validator: validator,
      onSaved: onSaved,
      decoration: InputDecoration(
       hintText: name,
          hintStyle: TextStyle(
          color: Colors.grey[700],),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
       ),
     );
  }
}