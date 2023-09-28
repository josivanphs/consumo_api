import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as htmlParser; // Importa a biblioteca html para processamento

class NoticiaDetailsScreen extends StatelessWidget {
  final String title;
  final String htmlDescription;

  NoticiaDetailsScreen({required this.title, required this.htmlDescription, required String description});

  String _stripHtmlTags(String htmlString) {
    final document = htmlParser.parse(htmlString);
    return document.body!.text;
  }

  @override
  Widget build(BuildContext context) {
    final plainTextDescription = _stripHtmlTags(htmlDescription);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Notícia'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 16.0),
            Html(
              data: plainTextDescription, // Use o texto processado aqui
            ),
          ],
        ),
      ),
    );
  }
}
