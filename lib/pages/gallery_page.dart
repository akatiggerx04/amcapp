import 'package:amcapp/globals.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  Future? _future;
  final pb = Globals.pb;

  @override
  void initState() {
    super.initState();
    _future = fetchGallery();
  }

  bool _isLoading = true;
  bool _isErrored = false;

  List gallery = [];

  Future fetchGallery() async {
    try {
      gallery = await pb.collection('Gallery').getFullList(
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
    await fetchGallery();
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
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                        top: 12,
                      ),
                      child: gallery.isEmpty && !_isLoading
                          ? const Center(
                              child: Text("No Images found."),
                            )
                          : Skeletonizer(
                              enabled: _isLoading,
                              child: GridView.count(
                                physics: const ScrollPhysics(),
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                children: [
                                  for (var image in _isLoading
                                      ? List.generate(8, (index) => null)
                                      : gallery)
                                    GestureDetector(
                                      onTap: _isLoading
                                          ? null
                                          : () {
                                              showImageViewer(
                                                context,
                                                NetworkImage(
                                                  pb.files
                                                      .getUrl(image,
                                                          image.data["Image"])
                                                      .toString(),
                                                ),
                                                swipeDismissible: true,
                                              );
                                            },
                                      child: Container(
                                        margin: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surfaceContainer,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: _isLoading
                                              ? Container(
                                                  height: 180,
                                                  color: Colors.grey[850],
                                                )
                                              : Image.network(
                                                  height: 180,
                                                  pb.files
                                                      .getUrl(image,
                                                          image.data["Image"])
                                                      .toString(),
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                    )
                                ],
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
