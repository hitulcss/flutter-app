enum PlayerType {
  youtube,
  hLS,
  network;

  factory PlayerType.fromJson(String type) {
    switch (type) {
      case "youtube":
        return PlayerType.youtube;
      case "hls":
        return PlayerType.hLS;
      case "network":
        return PlayerType.network;
      default:
        return PlayerType.youtube;
    }
  }
}
