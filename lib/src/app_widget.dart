import 'package:embalador/src/Home-page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.green),
      home: HomePage(),
    );
  }
}
