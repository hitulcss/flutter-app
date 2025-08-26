extension IntExtensions on int {
  /// Formats the integer as a string with "K" for thousands and "M" for millions.
  String toNumberFormattedViews() {
    if (this >= 1000000000000) {
      // Trillions (T)
      return '${(this / 1000000000000).toStringAsFixed(1)}T';
    } else if (this >= 1000000000) {
      // Billions (B)
      return '${(this / 1000000000).toStringAsFixed(1)}B';
    } else if (this >= 1000000) {
      // Millions (M)
      return '${(this / 1000000).toStringAsFixed(1)}M';
    } else if (this >= 1000) {
      // Thousands (K)
      return '${(this / 1000).toStringAsFixed(1)}K';
    } else {
      // Less than 1000
      return '$this';
    }
  }
}
