import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web Source Viewer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CodeViewerPage(),
    );
  }
}

class CodeViewerPage extends StatefulWidget {
  @override
  _CodeViewerPageState createState() => _CodeViewerPageState();
}

class _CodeViewerPageState extends State<CodeViewerPage> {
  final TextEditingController _urlController = TextEditingController();
  String _code = '';

  Future<void> _fetchCodeFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse("http://www." + url));
      if (response.statusCode == 200) {
        setState(() {
          _code = response.body;
        });
      } else {
        setState(() {
          _code = 'შეცდომა! გთხოვთ შეამოწმოთ ვებსაიტის მისამართი სწორედ იქნა ჩაწერილი თუ არა';
        });
      }
    } catch (e) {
      setState(() {
        _code = 'შეცდომა! გთხოვთ შეამოწმოთ ვებსაიტის მისამართი სწორედ იქნა ჩაწერილი თუ არა';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Web Source Viewer'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'ჩაწერე ვებსაიტის მისამართი',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _fetchCodeFromUrl(_urlController.text);
                  },
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: HighlightView(
                  _code,
                  language: 'dart',
                  theme: githubTheme,
                  padding: EdgeInsets.all(12),
                  textStyle: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
