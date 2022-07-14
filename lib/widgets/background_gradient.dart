import 'package:flutter/material.dart';

class BackgroundGradient extends StatelessWidget {
  BackgroundGradient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.elliptical(
              MediaQuery.of(context).size.width,
              50.0,
            ),
          ),
          gradient: LinearGradient(
            colors: [
              const Color(0xFFF58C28),
              const Color(0xFFF3C76F),
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
      ),
    );
  }
}
