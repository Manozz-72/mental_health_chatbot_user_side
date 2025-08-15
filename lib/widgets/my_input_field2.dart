import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/colors/colors.dart';

class MyInputField2 extends StatefulWidget {
  final String? hint;
  final String? label;
  final double? height;
  final bool? isPasswordField;
  final TextStyle? textStyle;
  final Function(String? value)? onChange;
  final TextInputType? keyboardType;
  final void Function(String)? onFieldSubmitted;
  final Widget? prefix;
  final int? limit;
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

  MyInputField2(
      {this.hint,
        this.isPasswordField,
        this.onChange,
        this.padding,
        this.height,
        this.keyboardType,
        this.prefix,
        this.limit,
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
        this.focusNode})
      : super(key: key);

  final _state = _MyInputField2State();

  @override
  _MyInputField2State createState() {
    return _state;
  }

  Future<void> validate() async {
    if (asyncValidator != null) {
      await _state.validate();
    }
  }
}

enum InputBorderType { outline, underline }

class _MyInputField2State extends State<MyInputField2> {
  late bool _isHidden;
  String text = "";
  bool isPasswordField = false;

  @override
  void initState() {
    isPasswordField = widget.isPasswordField ?? false;
    _isHidden = isPasswordField;
    errorMessage = null;
    if (widget.validator != null && widget.asyncValidator != null) {
      throw "validator and asyncValidator are not allowed at same time";
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
    return SizedBox(
      // padding: EdgeInsets.only(top: 5),
      height: widget.height ?? 55.sp,
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(10),
      // ),
      child: TextFormField(
        maxLength: widget.limit,
        key: widget.key,
        onChanged: widget.asyncValidator == null
            ? widget.onChange
            : (value) {
          text = value.toString();
          validateValue(text);
          if (widget.onChange != null) {
            widget.onChange!(text);
          }
        },
        style: widget.textStyle?? TextStyle(color: Colors.black,fontSize: 13.sp),
        obscureText: _isHidden,
        onTap: widget.onTap,
        validator: widget.validator ??
            (widget.asyncValidator != null
                ? (value) {
              text = value.toString();
              return errorMessage;
            }
                : null),
        maxLines: widget.maxLines ?? 1,
        minLines: widget.minLines,
        readOnly: widget.readOnly ?? false,
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        initialValue: widget.controller == null ? widget.text : null,
        onFieldSubmitted: widget.onFieldSubmitted,
        focusNode: widget.focusNode,
        enabled: widget.keyboardType != TextInputType.none,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        buildCounter: (_,
            {required currentLength, maxLength, required isFocused}) {
          return Visibility(
            visible: widget.showCounter ?? false,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0.sp),
              child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  currentLength.toString() +
                      (widget.limit != null ? "/$maxLength" : ""),
                  style: TextStyle(color: widget.counterColor),
                ),
              ),
            ),
          );
        },
        cursorColor: appPrimaryColor,
        cursorHeight: 22.sp,
        decoration: InputDecoration(
          prefixIcon: widget.prefix,
          hintText: widget.hint,
          labelText: widget.label,
          labelStyle: TextStyle(fontSize: 12.sp),
          isDense: widget.isDense,

          fillColor: widget.fillColor ?? /*Color(0xFFECECEC)*/
              const Color(0xffB9D2E8),
          filled: widget.fillColor != null,
          suffixIconConstraints: BoxConstraints(minWidth: 50.sp),
          suffixIcon: widget.suffix ??
              (isPasswordField
                  ? IconButton(
                onPressed: () {
                  if (isPasswordField) {
                    if (mounted) {
                      setState(() {
                        _isHidden = !_isHidden;
                      });
                    }
                  }
                },
                icon: Visibility(
                  visible: isPasswordField,
                  child: Icon(
                    isPasswordField
                        ? (_isHidden
                        ? Icons.visibility
                        : Icons.visibility_off)
                        : null,
                    color: Colors.grey,
                  ),
                ),
              )
                  : (widget.asyncValidator != null ? _getSuffixIcon() : null)),
          hintStyle: TextStyle(color: Colors.black.withOpacity(.5),fontSize: 12.sp),
          contentPadding: widget.padding ??
              EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: (widget.maxLines != null) ? 15 : 5,
                  bottom: (widget.maxLines != null) ? 15 : 5),
          border: InputBorder.none,
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            borderSide: BorderSide(width: 1.5, color: Colors.transparent),
          ),
          enabledBorder: widget.enabledBorder ??
              const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                borderSide: BorderSide(width: 1.5, color: Colors.transparent),
              ),

          // filled: true,
          // fillColor: Color(0xF0BBBBBB),
        ),
      ),
    );
  }

  Widget _getSuffixIcon() {
    if (isValidating) {
      return Transform.scale(scale: 0.7, child: const CupertinoActivityIndicator());
    } else {
      if (!isValid && isDirty) {
        return const Icon(
          Icons.cancel,
          color: Colors.red,
          size: 20,
        );
      } else if (isValid) {
        return const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 20,
        );
      } else {
        return const SizedBox(
          height: 1,
          width: 1,
        );
      }
    }
  }

  Future<void> validateValue(String newValue) async {
    isDirty = true;
    if (text.isEmpty) {
      if (mounted) {
        setState(() {
          isValid = false;
        });
      }
      return;
    }
    isValidating = true;
    if (mounted) {
      setState(() {});
    }
    errorMessage = await widget.asyncValidator!(newValue);
    isValidating = false;
    isValid = errorMessage == null;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> validate() async {
    await validateValue(text);
  }
}
