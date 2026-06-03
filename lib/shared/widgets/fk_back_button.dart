import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FkBackButton extends StatelessWidget {
  const FkBackButton({super.key, this.fallbackPath = '/community'});

  final String fallbackPath;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(fallbackPath);
        }
      },
      icon: const Icon(Icons.arrow_back_rounded),
    );
  }
}
