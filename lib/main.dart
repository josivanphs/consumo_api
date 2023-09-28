// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_application_1/noticia_details.dart';

Future<List<Noticia>> fetchNoticias() async {
  final response = await http
      .get(Uri.parse('https://cultura.am.gov.br/wp-json/wp/v2/posts'));

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = jsonDecode(response.body);
    List<Noticia> noticias =
        jsonResponse.map((item) => Noticia.fromJson(item)).toList();
    return noticias;
  } else {
    throw Exception('Failed to load noticias');
  }
}

class Noticia {
  final int id;
  final String title;
  final String guid;
  final String link;
  final String slug;
  final String content;

  Noticia({
    required this.id,
    required this.title,
    required this.guid,
    required this.link,
    required this.slug,
    required this.content,
  });

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      guid: json['guid']['rendered'],
      id: json['id'],
      title: json['title']['rendered'],
      link: json['link'],
      slug: json['slug'],
      content: json['content']['rendered'],
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Noticia>> futureNoticias;

  @override
  void initState() {
    super.initState();
    futureNoticias = fetchNoticias();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('culturaam News'),
        ),
        body: Center(
          child: FutureBuilder<List<Noticia>>(
            future: futureNoticias,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Render the list of noticias as cards here
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final noticia = snapshot.data![index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoticiaDetailsScreen(
                              title: noticia.title,
                              description: noticia.content,
                              htmlDescription: '',
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 1.8,
                        margin: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                noticia.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Text(
                                noticia.slug,
                              ),
                            ),
                            const Divider(
                              height: 20.0,
                              color: Colors.transparent,
                            )
                            // Outras informações da notícia podem ser adicionadas aqui
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              // Por padrão, mostra um indicador de carregamento.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
