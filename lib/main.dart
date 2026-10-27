import 'package:flutter/material.dart';
import 'package:flutter_infinite_listview/screens/post_list_screen.dart';

void main() => runApp(const InfiniteListViewApp());

class InfiniteListViewApp extends StatelessWidget {
  const InfiniteListViewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Infinite ListView",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const PostListScreen(),
    );
  }
}
