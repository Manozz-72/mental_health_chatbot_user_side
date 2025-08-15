import 'package:flutter/material.dart';

class MyInputField4 extends StatefulWidget {
  final String? hint;
  final String? label;
  final bool? isPasswordField;
  final TextStyle? textStyle;
  final Function(String? value)? onChange;
  final TextInputType? keyboardType;
  final void Function(String)? onFieldSubmitted;
  final Widget? prefix;
  final int? limit;
  final double? height;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final bool? readOnly;
  final Color? fillColor;
  final int? maxLines;
  final int? minLines;
  final String? text;
  final Color? counterColor;
  final bool? showCounter;
  final bool? showBorder;
  final bool? isDense;
  @override
  final Key? key;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? margin;
  final String? Function(String?)? validator;
  final Future<String?> Function(String?)? asyncValidator;
  final Widget? suffix;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorderType? borderType;
  final EdgeInsetsGeometry? padding;

  MyInputField4({
    this.hint,
    this.isPasswordField,
    this.onChange,
    this.padding,
    this.keyboardType,
    this.prefix,
    this.limit,
    this.height,
    this.controller,
    this.onTap,
    this.readOnly,
    this.fillColor,
    this.maxLines,
    this.text,
    this.showCounter,
    this.counterColor,
    this.showBorder,
    this.minLines,
    this.margin,
    this.suffix,
    this.validator,
    this.isDense,
    this.onFieldSubmitted,
    this.asyncValidator,
    this.label,
    this.key,
    this.textStyle,
    this.border,
    this.enabledBorder,
    this.borderType,
    this.focusNode,
    required Null Function(dynamic value) onChanged, required bool obscureText, required String initialValue,
  }) : super(key: key);

  @override
  _MyInputField4State createState() => _MyInputField4State();
}

enum InputBorderType { outline, underline }

class _MyInputField4State extends State<MyInputField4> {
  late bool _isHidden;

  @override
  void initState() {
    super.initState();
    _isHidden = widget.isPasswordField ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      onChanged: widget.onChange,
      onSubmitted: widget.onFieldSubmitted,
      keyboardType: widget.keyboardType,
      obscureText: _isHidden, // Toggles password visibility
      readOnly: widget.readOnly ?? false,
      maxLines: widget.maxLines ?? 1,
      minLines: widget.minLines,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: widget.prefix,
        suffixIcon: widget.isPasswordField == true
            ? IconButton(
          icon: Icon(
            _isHidden ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _isHidden = !_isHidden; // Toggle password visibility
            });
          },
        )
            : widget.suffix,
        contentPadding: widget.padding ??
            const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        border: widget.border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
        enabledBorder: widget.enabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.black, width: 2.0),
            ),
        focusedBorder: widget.borderType == InputBorderType.underline
            ? const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xff21AF85), width: 2.0),
        )
            : OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xff21AF85), width: 2.0),
        ),
        filled: true,
        fillColor: widget.fillColor ?? Colors.white,
        counterText: widget.showCounter == true
            ? '${widget.controller?.text.length ?? 0}/${widget.limit ?? ''}'
            : null,
        isDense: widget.isDense ?? false,
      ),
      style: widget.textStyle,
      onTap: widget.onTap,
    );
  }
}
