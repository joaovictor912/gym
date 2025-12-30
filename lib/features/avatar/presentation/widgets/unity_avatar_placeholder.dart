import 'package:flutter/material.dart';

/// MVP placeholder until Unity as a Library is wired.
///
/// The real implementation will be a PlatformView (AndroidView/UiKitView)
/// registered by the native Unity integration.
class UnityAvatarPlaceholder extends StatelessWidget {
  final int level;

  const UnityAvatarPlaceholder({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.person, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Avatar (Unity)', style: Theme.of(context).textTheme.titleMedium),
                  Text('Level atual: $level'),
                  const Text('Placeholder: integração Unity-as-a-Library na fase 2.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
