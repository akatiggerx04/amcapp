import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:amcapp/models/match_model.dart';
import 'package:intl/intl.dart';

class Match extends StatelessWidget {
  final MatchModel matchData;

  const Match({
    super.key,
    required this.matchData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('MMMM d, yyyy').format(
                    DateFormat('yyyy-MM-dd').parse(
                      matchData.matchDate,
                      true,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: SvgPicture.network(
                          matchData.homeTeamFlagUrl,
                          fit: BoxFit.contain,
                          semanticsLabel: 'Home Team Flag',
                          placeholderBuilder: (BuildContext context) =>
                              const CircularProgressIndicator(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        matchData.homeTeamName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${matchData.homeTeamScore} - ${matchData.visitorTeamScore}",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'VS',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: SvgPicture.network(
                          matchData.visitorTeamFlagUrl,
                          fit: BoxFit.contain,
                          semanticsLabel: 'Visitor Team Flag',
                          placeholderBuilder: (BuildContext context) =>
                              const CircularProgressIndicator(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        matchData.visitorTeamName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
