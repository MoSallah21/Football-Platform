class Goals {
  final int home ;
  final int away ;

  Goals(this.home,this.away);

  factory Goals.formJson(Map<String, dynamic> e) {
    return Goals(e['home']==null?0:e['home'], e['away']==null?0:e['away']);
  }
}
