import 'package:amcapp/pages/scores_page.dart';
import 'package:flutter/material.dart';

class TournamentCard extends StatelessWidget {
  final String title;
  final String bannerUrl;
  final String competitionId;

  const TournamentCard({
    super.key,
    required this.title,
    required this.bannerUrl,
    required this.competitionId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ScoresPage(
              competitionId: competitionId,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: bannerUrl.isNotEmpty
              ? DecorationImage(
                  image: NetworkImage(bannerUrl),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color.fromARGB(100, 0, 0, 0),
              ),
            ),
            Center(
              child: Text(
                title,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
