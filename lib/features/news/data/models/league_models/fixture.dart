class Fixture {
  final int id;
  final String date;
  final Venue venue;
  final Status statue;
  final String referee;

  Fixture(this.id, this.date, this.venue, this.statue,this.referee);

  factory Fixture.fromJson(Map<String, dynamic> e) {
    return Fixture(e['id'], e['date'], Venue.formJson(e['venue']),
        Status.formJson(e['status']),e['referee']??"");
  }
}

class Venue {
  final String name;
  final String city;

  Venue(this.name, this.city);

  factory Venue.formJson(Map<String, dynamic> e) {
    return Venue(e['name'], e['city']);
  }
}

class Status {
  final String long;
  final String short;
  final String elapsed;

  Status(this.long, this.short, this.elapsed);

  factory Status.formJson(Map<String, dynamic> e) {
    return Status(
        e['long'], e['short'], e['elapsed'] == null? '0' : e['elapsed'].toString());
  }
}
