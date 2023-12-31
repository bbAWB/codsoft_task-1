import 'package:flutter/material.dart';
import 'package:todo_app/utils/app_str.dart';

class RepTextField extends StatelessWidget {
  const RepTextField({
    super.key,
    required this.controller,
    this.isForDesc = false,
    required this.onFieldSubmitted,
    required this.onChanged,
  });

  final TextEditingController? controller;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final bool isForDesc;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListTile(
        title: TextFormField(
            controller: controller,
            maxLines: isForDesc ? 6 : null,
            cursorHeight: isForDesc ? 60 : null,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: isForDesc ? InputBorder.none : null,
              counter: Container(),
              hintText: isForDesc ? App.addNote : null,
              prefixIcon: isForDesc
                  ? const Icon(
                      Icons.bookmark_border,
                      color: Colors.grey,
                    )
                  : null,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            onFieldSubmitted: onFieldSubmitted,
            onChanged: onChanged),
      ),
    );
  }
}
