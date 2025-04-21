import 'package:flites/main.dart';
import 'package:flutter/material.dart';
import 'package:syntax_highlight/syntax_highlight.dart';
import 'package:flutter/services.dart';

enum CodeHighlightLanguage {
  dart,
  yaml,
  sql,
}

class CodeHighlight extends StatelessWidget {
  final String code;
  final CodeHighlightLanguage language;

  const CodeHighlight({
    super.key,
    required this.code,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: context.colors.surface,
      child: Stack(
        children: [
          Flexible(
            flex: 1,
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                color: context.colors.surface,
                child: _buildCodeHighlight(context),
              ),
            ),
          ),
          Positioned(
            top: 8.0,
            right: 8.0,
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
  }

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
                var highlighter = Highlighter(
                  language: language.name,
                  theme: themeSnapshot.data!,
                );
                var highlightedCode = highlighter.highlight(code);
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
