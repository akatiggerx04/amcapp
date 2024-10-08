import 'package:amcapp/models/article_model.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewArticle extends StatelessWidget {
  final ArticleModel article;

  const ViewArticle({
    super.key,
    required this.article,
  });

  Future<void> _openArticle() async {
    if (!await launchUrl(
      Uri.parse(
          "https://www.africanminifootball.org/news/article/?id=${article.id}"),
    )) {
      throw Exception('Unable to open article!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/logo.png",
          width: 200,
        ),
        actions: [
          const SizedBox(
            height: 5,
          ),
          IconButton(
            onPressed: _openArticle,
            icon: const Icon(Icons.open_in_new_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  showImageViewer(
                    context,
                    NetworkImage(
                      article.coverUrl,
                    ),
                    swipeDismissible: true,
                  );
                },
                child: Hero(
                  tag: article.coverUrl,
                  child: Image.network(
                    article.coverUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Published on ${DateFormat('MMMM d, yyyy').format(
                        DateFormat('yyyy-MM-dd').parse(
                          article.date,
                          true,
                        ),
                      )}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(article.body),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
