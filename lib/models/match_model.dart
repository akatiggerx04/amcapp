class MatchModel {
  final String homeTeamName;
  final String homeTeamFlagUrl;
  final int homeTeamScore;

  final String visitorTeamName;
  final String visitorTeamFlagUrl;
  final int visitorTeamScore;

  final String matchDate;

  MatchModel({
    required this.homeTeamName,
    required this.homeTeamFlagUrl,
    required this.homeTeamScore,
    required this.visitorTeamName,
    required this.visitorTeamFlagUrl,
    required this.visitorTeamScore,
    required this.matchDate,
  });
}
