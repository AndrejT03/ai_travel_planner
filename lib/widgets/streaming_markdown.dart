import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class StreamingMarkdown extends StatefulWidget {
  final String data;
  final MarkdownStyleSheet styleSheet;
  final bool animate;

  const StreamingMarkdown({
    super.key,
    required this.data,
    required this.styleSheet,
    this.animate = true,
  });

  @override
  State<StreamingMarkdown> createState() => _StreamingMarkdownState();
}

class _StreamingMarkdownState extends State<StreamingMarkdown> {
  String _displayedData = "";
  late final String _fullData;
  final int _chunkSize = 5;
  final Duration _interval = const Duration(milliseconds: 15);

  @override
  void initState() {
    super.initState();
    _fullData = widget.data;
    if (widget.animate) {
      _startStreaming();
    } else {
      _displayedData = _fullData;
    }
  }

  void _startStreaming() async {
    for (int i = 0; i < _fullData.length; i += _chunkSize) {
      if (!mounted) return;
      await Future.delayed(_interval);
      setState(() {
        int end = (i + _chunkSize < _fullData.length)
            ? i + _chunkSize
            : _fullData.length;
        _displayedData = _fullData.substring(0, end);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      key: ValueKey(_displayedData.length),
      data: _displayedData,
      styleSheet: widget.styleSheet,
      fitContent: true,
    );
  }
}