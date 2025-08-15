import 'package:flutter/material.dart' hide Badge;

class CustomError extends StatelessWidget{
  final FlutterErrorDetails errorDetails;

  const CustomError({super.key, 
    required this.errorDetails
});
  @override
  Widget build(BuildContext context){
    print(errorDetails);
    return const Card(
      color: Colors.red,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('Something is not right here..',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
        ),
        ),
      ),
    );
  }
}