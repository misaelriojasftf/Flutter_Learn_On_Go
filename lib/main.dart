import 'package:flutter/material.dart';
// import 'course/02_Address_search.dart';
import 'course/03_multi_file_picker.dart';
// import 'course/01_api_form_call.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Course',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MultiFilePicker(),
    );
  }
}
