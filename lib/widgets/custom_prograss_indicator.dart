import 'package:flutter/material.dart';


class CustomProgressWidget extends StatefulWidget {
  final bool loading;
  final Widget child;
  final String? text;

  @override
  _CustomProgressWidgetState createState() => _CustomProgressWidgetState();

  const CustomProgressWidget({super.key, 
    required this.loading,
    required this.child,
    this.text,
  });
}

class _CustomProgressWidgetState extends State<CustomProgressWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SizedBox(
              height: MediaQuery.of(context).size.height,
              // decoration: BoxDecoration(
              //   color: Colors.white,
              // ),
              child: widget.child),
          widget.loading
              ? Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                  if (widget.text != null && widget.text!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        widget.text.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                ],
              ),
            ),
          )
              : Container(),
        ],
      ),
    );
  }
}
