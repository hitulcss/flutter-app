class AppDateFormate {
  static String formatDuration(Duration duration) {
    String daysPart = duration.inDays > 0 ? '${duration.inDays} day ' : '';
    String hoursPart = duration.inHours.remainder(24) > 0 ? '${duration.inHours.remainder(24)} hour ' : '';
    String minutesPart = duration.inMinutes.remainder(60) > 0 ? '${duration.inMinutes.remainder(60)} min' : '';
    String secondsPart = duration.inSeconds.remainder(60) > 0 ? '${duration.inSeconds.remainder(60)} sec' : '';

    return '$daysPart$hoursPart$minutesPart$secondsPart'.trim();
  }
}

extension DurationExtension on Duration {
  String formatDuration() {
    List<String> parts = [];

    if (inDays > 0) {
      parts.add('$inDays');
    }
    if (inHours % 24 > 0) {
      parts.add('${inHours % 24}');
    }
    // if (inMinutes % 60 > 0) {
    parts.add('${inMinutes % 60}');
    // }
    // if (inSeconds % 60 > 0) {
    parts.add('${inSeconds % 60}');
    // }

    return parts.join(':');
  }
}
