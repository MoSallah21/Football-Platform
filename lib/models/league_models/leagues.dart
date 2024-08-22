class League {
  final int id;
  final String logo;
  final String name;
  final int season;
  final String round;

  League(this.id,this.name,this.logo, this.season, this.round);
  factory League.fromJson(Map<String, dynamic> e) {
    return League(e['id'],e['name'],e['logo'], e['season'], e['round']);
  }
}
