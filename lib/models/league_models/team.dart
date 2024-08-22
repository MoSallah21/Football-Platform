class Team {
  int id;
  String name;
  String logo;

  Team(this.id, this.name, this.logo);

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(json['id'], json['name'], json['logo']);
  }
}
