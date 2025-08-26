String? extractYouTubeVideolink(String url) {
  // Regular expressions to match various YouTube URL formats
  List<RegExp> patterns = [
    RegExp(r'(?:https?:\/\/)?(?:www\.)?youtube\.com\/watch\?v=([a-zA-Z0-9_-]+)'),
    RegExp(r'(?:https?:\/\/)?(?:www\.)?youtube\.com\/watch\?.*&v=([a-zA-Z0-9_-]+)'),
    RegExp(r'(?:https?:\/\/)?(?:www\.)?youtube\.com\/embed\/([a-zA-Z0-9_-]+)'),
    RegExp(r'(?:https?:\/\/)?(?:www\.)?youtu.be\/([a-zA-Z0-9_-]+)'),
    RegExp(r'(?:https?:\/\/)?(?:www\.)?youtube\.com\/live\/([a-zA-Z0-9_\-?]+)'),
    RegExp(r'(?:https?:\/\/)?(?:www\.)?youtube\.com\/watch\?list=[a-zA-Z0-9_-]+&v=([a-zA-Z0-9_-]+)'),
    RegExp(r'(?:https?:\/\/)?(?:www\.)?youtube-nocookie\.com\/embed\/([a-zA-Z0-9_-]+)'),
  ];

  // Try each pattern and return the video ID if a match is found
  for (RegExp pattern in patterns) {
    Match? match = pattern.firstMatch(url);
    if (match != null && match.groupCount >= 1) {
      return 'https://www.youtube.com/embed/${match.group(1)}';
    }
  }

  // If no match is found, return null or handle the case as needed
  return null;
}
