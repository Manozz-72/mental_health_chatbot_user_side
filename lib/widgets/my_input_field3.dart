import 'package:flutter/material.dart';


class MyInputField3 extends StatefulWidget {
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

  MyInputField3(
      {this.hint,
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
        this.focusNode, required bool obscureText, required String initialValue})
      : super(key: key);

  final _state = _MyInputField3State();

  @override
  _MyInputField3State createState() {
    return _state;
  }

  Future<void> validate() async {
    if (asyncValidator != null) {
      await _state.validate();
    }
  }
}

enum InputBorderType { outline, underline }

class _MyInputField3State extends State<MyInputField3> {
  late bool _isHidden;
  String text = "";
  bool isPasswordField = false;

  @override
  void initState() {
    isPasswordField = widget.isPasswordField ?? false;
    _isHidden = isPasswordField;
    errorMessage = null;
    if (widget.validator != null && widget.asyncValidator != null) {
      throw "validator and asyncValidator are not allowed at the same time";
    }

    if (widget.controller != null && widget.text != null) {
      widget.controller!.text = widget.text!;
    }

    super.initState();
  }

  var isValidating = false;
  var isValid = false;
  var isDirty = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      onChanged: widget.onChange,
      onSubmitted: widget.onFieldSubmitted,
      keyboardType: widget.keyboardType,
      obscureText: _isHidden,
      readOnly: widget.readOnly ?? false,
      maxLines: widget.maxLines ?? 1,
      minLines: widget.minLines,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: widget.prefix,
        suffixIcon: widget.suffix,
        contentPadding: widget.padding ??
            const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        border: widget.border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
        enabledBorder: widget.enabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Color(0xff21AF85), width: 2.0),
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

  validate() {}
}
