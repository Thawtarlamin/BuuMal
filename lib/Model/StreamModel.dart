class StreamModel {
  final String link, referer, user_agent, mx_player_link;

  StreamModel(
      {required this.link,
      required this.referer,
      required this.user_agent,
      required this.mx_player_link});
  factory StreamModel.from(dynamic data) {
    return StreamModel(
        link: data['link'],
        referer: data['referer'],
        user_agent: data['user_agent'],
        mx_player_link: data['mx_player_link']);
  }
}
