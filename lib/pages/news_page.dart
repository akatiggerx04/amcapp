import 'package:amcapp/globals.dart';
import 'package:amcapp/models/article_model.dart';
import 'package:amcapp/pages/article_page.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  Future? _future;
  final pb = Globals.pb;

  @override
  void initState() {
    super.initState();
    _future = fetchNews();
  }

  bool _isLoading = true;
  bool _isErrored = false;

  List news = [];

  Future fetchNews() async {
    try {
      news = await pb.collection('News').getFullList(
            sort: '-created',
          );
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isErrored = true;
        _isLoading = false;
      });
    }
  }

  Future<void> refreshPage() async {
    setState(() {
      _isLoading = true;
    });
    await fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          "assets/logo.png",
          width: 200,
        ),
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          return _isErrored
              ? Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error,
                        size: 30,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      const Text(
                        "An Error Occured!",
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      ElevatedButton(
                        onPressed: refreshPage,
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: refreshPage,
                  child: SingleChildScrollView(
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 12,
                          right: 12,
                          top: 12,
                        ),
                        child: news.isEmpty && !_isLoading
                            ? const Center(
                                child: Text("No Articles Found."),
                              )
                            : Skeletonizer(
                                enabled: _isLoading,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    for (var article in _isLoading
                                        ? List.generate(5, (index) => {})
                                        : news)
                                      Column(
                                        children: [
                                          GestureDetector(
                                            onTap: _isLoading
                                                ? null
                                                : () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ViewArticle(
                                                          article: ArticleModel(
                                                            id: article.id,
                                                            title: article.data[
                                                                    "Title"] ??
                                                                "Article",
                                                            coverUrl: pb.files
                                                                .getUrl(
                                                                    article,
                                                                    article.data[
                                                                        "Cover"])
                                                                .toString(),
                                                            body: article.data[
                                                                "appArticle"],
                                                            date:
                                                                article.created,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surfaceContainer,
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .surfaceContainerLowest,
                                                      child: Hero(
                                                        tag: _isLoading
                                                            ? 'skeleton_image'
                                                            : pb.files
                                                                .getUrl(
                                                                    article,
                                                                    article.data[
                                                                        "Cover"])
                                                                .toString(),
                                                        child: _isLoading
                                                            ? Container(
                                                                height: 180,
                                                                width: double
                                                                    .infinity,
                                                                color: Colors
                                                                    .grey[300],
                                                              )
                                                            : Image.network(
                                                                height: 180,
                                                                fit: BoxFit
                                                                    .cover,
                                                                width: double
                                                                    .infinity,
                                                                pb.files
                                                                    .getUrl(
                                                                        article,
                                                                        article.data[
                                                                            "Cover"])
                                                                    .toString(),
                                                              ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 12,
                                                        vertical: 6,
                                                      ),
                                                      child: Text(
                                                        _isLoading
                                                            ? 'Loading Article Title'
                                                            : article.data[
                                                                    "Title"] ??
                                                                "Article",
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      )
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
