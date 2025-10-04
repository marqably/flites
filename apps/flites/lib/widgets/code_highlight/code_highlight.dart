import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

import '../../main.dart';

enum CodeHighlightLanguage {
  dart,
  yaml,
  sql,
}

class CodeHighlight extends StatelessWidget {
  const CodeHighlight({
    required this.code,
    required this.language,
    super.key,
  });
  final String code;
  final CodeHighlightLanguage language;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        color: context.colors.surface,
        child: Stack(
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  color: context.colors.surface,
                  child: _buildCodeHighlight(context),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: FloatingActionButton(
                mini: true,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Code copied to clipboard!')),
                  );
                },
                child: const Icon(Icons.copy),
              ),
            ),
          ],
        ),
      );

  Widget _buildCodeHighlight(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = isDarkMode
        ? HighlighterTheme.loadDarkTheme()
        : HighlighterTheme.loadLightTheme();

    return FutureBuilder(
      future: Highlighter.initialize([language.name]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return FutureBuilder<HighlighterTheme>(
            future: theme,
            builder: (context, themeSnapshot) {
              if (themeSnapshot.connectionState == ConnectionState.done) {
                final highlighter = Highlighter(
                  language: language.name,
                  theme: themeSnapshot.data!,
                );
                final highlightedCode = highlighter.highlight(code);
                return Text.rich(highlightedCode);
              } else {
                return const CircularProgressIndicator();
              }
            },
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
