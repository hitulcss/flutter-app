import 'package:flutter/material.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';

class CustomTextFilled extends StatelessWidget {
  const CustomTextFilled({super.key, required this.hintText, required this.textController, required this.onChanged, required this.validator});
  final String hintText;
  final TextEditingController textController;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      keyboardType: hintText == 'Email id '
          ? TextInputType.emailAddress
          : hintText == 'Mobile No.'
              ? TextInputType.phone
              : TextInputType.name,
      onChanged: onChanged,
      decoration: InputDecoration(
        semanticCounterText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        labelText: hintText,
        hintText: hintText,
      ),
      validator: validator,
    );
  }
}

class PasswordTextFilled extends StatefulWidget {
  const PasswordTextFilled({super.key, required this.textEditingController, required this.validator, required this.onChanged});
  final TextEditingController textEditingController;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onChanged;
  @override
  State<PasswordTextFilled> createState() => _PasswordTextFilledState();
}

class _PasswordTextFilledState extends State<PasswordTextFilled> {
  bool _isVisible = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textEditingController,
      obscureText: _isVisible,
      validator: widget.validator,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        labelText: "Password",
        suffixIcon: GestureDetector(
            onTap: () {
              safeSetState(() {
                _isVisible = !_isVisible;
              });
            },
            child: _isVisible ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility)),
      ),
    );
  }
}
