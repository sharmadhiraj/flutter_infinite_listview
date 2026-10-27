import 'package:flutter/material.dart';

class RetryButton extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const RetryButton({
    required this.message,
    required this.onRetry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Semantics(
              label: "Retry loading posts",
              button: true,
              child: FilledButton.tonalIcon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text("Retry"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
