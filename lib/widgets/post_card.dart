import 'package:flutter/material.dart';
import 'package:flutter_infinite_listview/models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({required this.post, super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Semantics(
      label: "Post: ${post.title}",
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(post.title, style: textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(post.body, style: textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
