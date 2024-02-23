import 'package:flutter/material.dart';
import 'package:flutter_infinite_listview/screens/photo_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Infinite Scrolling ListView",
      theme: ThemeData(primarySwatch: Colors.teal),
      home: PhotosListScreen(),
    );
  }
}
