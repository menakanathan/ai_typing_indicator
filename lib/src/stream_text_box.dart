import 'dart:async';

import 'package:flutter/material.dart';

/// Renders text progressively as tokens arrive from a [Stream],
/// accompanied by a blinking terminal cursor while active.
class StreamingTextBox extends StatefulWidget {
  final Stream<String> tokenStream;
  final TextStyle? textStyle;
  final Color cursorColor;
  final VoidCallback? onCompleted;

  const StreamingTextBox({
    super.key,
    required this.tokenStream,
    this.textStyle,
    this.cursorColor = const Color(0xFF02569B),
    this.onCompleted,
  });

  @override
  State<StreamingTextBox> createState() => _StreamingTextBoxState();
}

class _StreamingTextBoxState extends State<StreamingTextBox>
    with SingleTickerProviderStateMixin {
  final StringBuffer _buffer = StringBuffer();
  StreamSubscription<String>? _subscription;
  late final AnimationController _cursorController;
  bool _isStreaming = true;

  @override
  void initState() {
    super.initState();
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _subscribe();
  }

  void _subscribe() {
    _subscription = widget.tokenStream.listen(
      (token) {
        if (!mounted) return;
        setState(() => _buffer.write(token));
      },
      onDone: () {
        if (!mounted) return;
        setState(() => _isStreaming = false);
        _cursorController.stop();
        widget.onCompleted?.call();
      },
    );
  }

  @override
  void didUpdateWidget(covariant StreamingTextBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tokenStream != widget.tokenStream) {
      _subscription?.cancel();
      _buffer.clear();
      _isStreaming = true;
      _cursorController.repeat(reverse: true);
      _subscribe();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.textStyle ?? Theme.of(context).textTheme.bodyLarge;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC), // Or Color(0xFFF8FAFC)
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: RichText(
        text: TextSpan(
          style: style?.copyWith(color: Colors.black87, height: 1.5),
          children: [
            TextSpan(text: _buffer.toString()),
            if (_isStreaming)
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: FadeTransition(
                  opacity: _cursorController,
                  child: Container(
                    width: 8,
                    height: 18,
                    margin: const EdgeInsets.only(left: 3),
                    color: widget.cursorColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
