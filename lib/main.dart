import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const DaStoryTellaReaderApp());
}

class DaStoryTellaReaderApp extends StatelessWidget {
  const DaStoryTellaReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "daStoryTella's Reader",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const _ScaffoldPlaceholder(),
    );
  }
}

/// Temporary landing widget — replace with the real navigation shell
/// (Library / Voices / Settings via bottom nav) once `go_router` (or the
/// chosen navigation approach, see ARCHITECTURE.md §7) is wired up.
class _ScaffoldPlaceholder extends StatelessWidget {
  const _ScaffoldPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "daStoryTella's Reader\nScaffold ready — build the first feature screen.",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
