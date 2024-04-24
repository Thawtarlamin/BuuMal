import 'package:flutter/material.dart';
import 'package:mal/screen/MyanmarScreen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        appBarTheme:
            const AppBarTheme(iconTheme: IconThemeData(color: Colors.white))),
    home: const MyanmarScreen(),
  ));
}
