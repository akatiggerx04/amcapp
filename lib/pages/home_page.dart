import 'package:amcapp/globals.dart';
import 'package:amcapp/widgets/tournament_card.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future? _future;
  final pb = Globals.pb;

  @override
  void initState() {
    super.initState();
    _future = fetchTournaments();
  }

  bool _isLoading = true;
  bool _isErrored = false;

  List tournaments = [];

  Future fetchTournaments() async {
    try {
      tournaments = await pb.collection('Competitions').getFullList(
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
    await fetchTournaments();
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
              : Skeletonizer(
                  enabled: _isLoading,
                  child: SingleChildScrollView(
                    child: RefreshIndicator(
                      onRefresh: refreshPage,
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 12,
                            right: 12,
                            top: 12,
                          ),
                          child: GridView.count(
                            physics: const ScrollPhysics(),
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            children: [
                              for (var tournament in _isLoading
                                  ? List.generate(6, (index) => null)
                                  : tournaments)
                                TournamentCard(
                                  title:
                                      tournament?.data["Name"] ?? "Tournament",
                                  bannerUrl: tournament != null
                                      ? pb.files
                                          .getUrl(tournament,
                                              tournament.data["banner"])
                                          .toString()
                                      : '',
                                  competitionId: tournament?.id ?? '',
                                ),
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
