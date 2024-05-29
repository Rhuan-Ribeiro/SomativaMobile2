import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';

class Films extends StatefulWidget {
  const Films({super.key});

  @override
  State<Films> createState() => _FilmsState();
}

class _FilmsState extends State<Films> {
  @override
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
        // print(data); // transforma os dados como uma lista para poder exibir
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Catálogo",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            CarouselSlider.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index, int realIndex) {
                final item = Movies.fromJson(data[index]);
                return MovieCard(
                  title: item.title,
                  imageUrl: item.image,
                  duration: item.duration,
                  releaseYear: item.releaseYear,
                  rating: double.parse(item.note),
                );
              },
              options: CarouselOptions(
                height: 605,
                aspectRatio: 16 / 9,
                enableInfiniteScroll: false,
                enlargeCenterPage: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Movies {
  String title;
  String image;
  String duration;
  String releaseYear;
  String note;
  Movies(
    this.title,
    this.image,
    this.duration,
    this.releaseYear,
    this.note,
  );
  factory Movies.fromJson(Map<String, dynamic> json) {
    return Movies(json["nome"], json["imagem"], json["duração"],
        json["ano de lançamento"], json["nota"]);
  }
}

class MovieCard extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String duration;
  final String releaseYear;
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
      margin: const EdgeInsets.all(4.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            AspectRatio(
              aspectRatio: 2 / 3, // Proporção 2:3
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit
                    .cover, // Para preencher o espaço mantendo a proporção
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Duração: ${widget.duration}',
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 5.0),
            Text(
              'Ano de Lançamento: ${widget.releaseYear}',
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 5.0),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.yellow),
                const SizedBox(width: 5.0),
                Text(
                  widget.rating.toString(),
                  style: const TextStyle(fontSize: 20.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
