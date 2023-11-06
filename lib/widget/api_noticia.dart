import 'dart:convert';

import 'package:api_noticias/widget/noticia.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  Future<List<Noticia>> noticiasFuture = getNoticia();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Noticias"),
        actions: const [
          IconButton(onPressed: null, icon: Icon(Icons.search)),
          IconButton(onPressed: null, icon: Icon(Icons.more_vert))
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future: noticiasFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              final noticias = snapshot.data as List<Noticia>;
              return buildNoticia(noticias);
            } else {
              return const Text("No data available");
            }
          },
        ),
      ),
    );
  }

  static Future<List<Noticia>> getNoticia() async {
    var url = Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=us&apiKey=f06f099974e7417b9faf97fc4fda5f62");
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    final Map<String, dynamic> body = json.decode(response.body);
    final List articles = body['articles'];
    return articles.map((e) => Noticia.fromJson(e)).toList();
  }
}

Widget buildNoticia(List<Noticia> noticias) {
  return ListView.separated(
    itemCount: noticias.length,
    itemBuilder: (BuildContext context, int index) {
      final noticia = noticias[index];
      final url = noticia.url;

      return ListTile(
        title: Text(noticia.name),
        leading: CircleAvatar(backgroundImage: NetworkImage(url)),
        subtitle: Text(noticia.description),
        trailing: const Icon(Icons.arrow_forward_ios),
      );
    },
    separatorBuilder: (BuildContext context, int index) {
      return const Divider(
        thickness: 2,
      );
    },
  );
}
