import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Films extends StatefulWidget {
  const Films({super.key});

  @override
  State<Films> createState() => _FilmsState();
}

class _FilmsState extends State<Films> {
  void initState() {
    super.initState();
    showFilms();
  }

  List data = [];
  Future<void> showFilms() async {
    String url =
        "https://raw.githubusercontent.com/danielvieira95/DESM-2/master/filmes.json";
    http.Response response = await http.get(Uri.parse(url));
    // lista de produtos prod itens

    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body) as List<
            dynamic>; // cria a variavel data como lista para receber o json
        print(data); // transforma os dados como uma lista para poder exibir
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: data.length, // conta o tamanho da lista de datas
          itemBuilder: (context, index) {
            final item = data[
                index]; // variavel item que irá armazenar os elementos da lista
            return ListTile(MovieCard(),
                // title: Text(
                //   "Nome: ${item["nome"]}",
                //   style: TextStyle(fontSize: 16),
                //   textAlign: TextAlign.center,
                // ),
                // subtitle: Column(
                //   children: [
                //     Text(
                //       "Valor: ${item["valor"]} ",
                //       style: TextStyle(fontSize: 16),
                //     ),
                //     Text("Qtde: ${item["qtde"]}", style: TextStyle(fontSize: 16)),
                //   ],
                // ),
                );
          }),
    );
  }
}

class Users {
  String name;
  String image;
  String duration;
  int release;
  String note;
  Users(
    this.name,
    this.image,
    this.duration,
    this.release,
    this.note,
  );
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(json["nome"], json["imagem"], json["duração"],
        json["ano de lançamento"], json["nota"]);
  }
}

class MovieCard extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String duration;
  final int releaseYear;
  final double rating;

  const MovieCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.duration,
    required this.releaseYear,
    required this.rating,
  });

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                widget.imageUrl,
                width: 150.0,
                height: 200.0,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Duração: ${widget.duration}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 5.0),
            Text(
              'Ano de Lançamento: ${widget.releaseYear}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 5.0),
            Row(
              children: [
                Icon(Icons.star, color: Colors.yellow),
                SizedBox(width: 5.0),
                Text(
                  widget.rating.toString(),
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
