import 'package:flutter/material.dart';
import 'package:ai_typing_indicator/ai_typing_indicator.dart';

void main() => runApp(const MaterialApp(home: AiStreamDemo()));

class AiStreamDemo extends StatefulWidget {
  const AiStreamDemo({super.key});

  @override
  State<AiStreamDemo> createState() => _AiStreamDemoState();
}

class _AiStreamDemoState extends State<AiStreamDemo> {
  late Stream<String> _stream;

  @override
  void initState() {
    super.initState();
    _stream = _simulateLlmResponse();
  }

  Stream<String> _simulateLlmResponse() async* {
    const words = [
      'Packages ',
      'let ',
      'engineering ',
      'teams ',
      'decouple ',
      'domain ',
      'logic ',
      'from ',
      'UI ',
      'shells—',
      'enabling ',
      'independent ',
      'testing, ',
      'semantic ',
      'versioning, ',
      'and ',
      'zero-friction ',
      'reuse.',
    ];
    for (final word in words) {
      await Future.delayed(const Duration(milliseconds: 90));
      yield word;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LLM Stream Package Demo')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            StreamingTextBox(tokenStream: _stream),
            FilledButton.icon(
              onPressed: () => setState(() => _stream = _simulateLlmResponse()),
              icon: const Icon(Icons.refresh),
              label: const Text('Replay Token Stream'),
            ),
          ],
        ),
      ),
    );
  }
}
