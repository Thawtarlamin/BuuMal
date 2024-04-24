class MyanmarModel {
  final String profile, title, time, link;
  

  MyanmarModel(
      {required this.profile,
      required this.title,
      required this.time,
      required this.link,
      // required this.referer,
      // required this.user_agent,
      // required this.mx_player_link
      });

  factory MyanmarModel.from(dynamic data) {
    return MyanmarModel(
        profile: data['thumb'],
        title: data['title'],
        time: data['time'],
        link: data['link'],
        // referer: data['referer'],
        // user_agent: data['user_agent'],
        // mx_player_link: data['mx_player_link']
        );
  }
}
