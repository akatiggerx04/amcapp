import 'package:amcapp/globals.dart';
import 'package:amcapp/models/match_model.dart';
import 'package:flutter/material.dart';
import 'package:amcapp/widgets/match.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ScoresPage extends StatefulWidget {
  final String competitionId;

  const ScoresPage({
    super.key,
    required this.competitionId,
  });

  @override
  State<ScoresPage> createState() => _ScoresPageState();
}

class _ScoresPageState extends State<ScoresPage> {
  Future? _future;
  final pb = Globals.pb;

  @override
  void initState() {
    super.initState();
    _future = fetchMatches();
  }

  bool _isLoading = true;
  bool _isErrored = false;

  List matches = [];
  List finishedMatches = [];
  List ongoingMatches = [];
  List upcomingMatches = [];

  Future fetchMatches() async {
    try {
      matches = await pb.collection('Matches').getFullList(
            sort: '-Date',
            filter: 'competition = "${widget.competitionId}"',
          );

      finishedMatches =
          matches.where((match) => match.data["time"] == "Finished").toList();
      ongoingMatches =
          matches.where((match) => match.data["time"] == "Ongoing").toList();
      upcomingMatches =
          matches.where((match) => match.data["time"] == "Upcoming").toList();

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
    await fetchMatches();
  }

  Widget _buildMatchList(List matches, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 8,
            top: 16,
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _isLoading
            ? ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 6,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  return Skeleton.leaf(
                    child: Container(
                      height: 160,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
              )
            : matches.isEmpty
                ? Text("No $title Available")
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: matches.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final match = matches[index];
                      return Match(
                        matchData: MatchModel(
                          homeTeamName: match.data["home_team"] ?? "Team",
                          homeTeamFlagUrl: pb.files
                              .getUrl(match, match.data["home_team_flag"])
                              .toString(),
                          homeTeamScore: match.data["home_score"] ?? 0,
                          visitorTeamName: match.data["visitor_team"] ?? "Team",
                          visitorTeamFlagUrl: pb.files
                              .getUrl(match, match.data["visitor_team_flag"])
                              .toString(),
                          visitorTeamScore: match.data["visitor_score"],
                          matchDate: match.data["Date"],
                        ),
                      );
                    },
                  ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            const SizedBox(
              height: 5,
            ),
            IconButton(
              onPressed: refreshPage,
              icon: const Icon(Icons.refresh),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.sports_soccer),
                text: "Finished",
              ),
              Tab(
                icon: Icon(Icons.settings_input_antenna_outlined),
                text: "Live",
              ),
              Tab(
                icon: Icon(Icons.date_range),
                text: "Upcoming",
              ),
            ],
          ),
          title: Image.asset(
            "assets/logo.png",
            width: 200,
          ),
        ),
        body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              _isLoading = true;
            }
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
                : TabBarView(
                    children: [
                      SingleChildScrollView(
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: _buildMatchList(
                                finishedMatches, "Finished Matches"),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: _buildMatchList(
                                ongoingMatches, "Ongoing Matches"),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: _buildMatchList(
                                upcomingMatches, "Upcoming Matches"),
                          ),
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
