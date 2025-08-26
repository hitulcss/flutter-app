import 'package:flutter/material.dart';

extension StringCasingExtension on String {
  String toCapitalize() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  // String yourStringModifyingMethod() => write your logic here to modify the string as per your need;
  /// Converts a HEX color string to a [Color].
  /// 
  /// Examples:
  /// - "#FFFFFF" -> Color(0xFFFFFFFF)
  /// - "FFFFFF" -> Color(0xFFFFFFFF)
  /// - "0xFFFFFFFF" -> Color(0xFFFFFFFF)
  Color? toColor() {
    try {
      String hex = this;

      // Remove any leading characters like "#" or "0x"
      if (hex.startsWith("#")) {
        hex = hex.substring(1);
      } else if (hex.startsWith("0x")) {
        hex = hex.substring(2);
      }

      // Ensure the string is 6 or 8 characters long
      if (hex.length == 6) {
        // Add full opacity if alpha is not provided
        hex = "FF$hex";
      } else if (hex.length != 8) {
        return null; // Invalid HEX format
      }

      // Parse the string as an integer and return a Color
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      // Return null if parsing fails
      return null;
    }
  }
}

extension DurationExtensions on Duration {
  String toYearsMonthsDaysString() {
    final years = inDays ~/ 365;
    final remainingDays = inDays % 365;

    final months = remainingDays ~/ 30;
    final days = remainingDays % 30;

    // Use a single string buffer for efficiency
    final buffer = StringBuffer();

    if (years > 0) {
      buffer.write('$years year${years > 1 ? 's' : ''}');
      buffer.write(' '); // Add space for better readability
    }

    if (months > 0) {
      buffer.write('$months month${months > 1 ? 's' : ''}');
      buffer.write(' '); // Add space
    }

    if (days > 0) {
      buffer.write('$days day${days > 1 ? 's' : ''}');
    }

    return buffer.toString().trim(); // Remove trailing spaces
  }
}
extension ListExtension<T> on List<T> {
  /// Returns a new list containing only the repeated elements.
  List<T> get repeatedElements {
    final seen = <T>{};
    final repeated = <T>[];
    for (final element in this) {
      if (seen.contains(element)) {
        repeated.add(element);
      } else {
        seen.add(element);
      }
    }
    return repeated;
  }

  /// Returns the number of times each element appears in the list.
  Map<T, int> get countByElement {
    final counts = Map<T, int>.from({});
    for (final element in this) {
      counts[element] = (counts[element] ?? 0) + 1;
    }
    return counts;
  }

  /// Returns the count of a specific element (string or int) in the list.
  int countOf(T element) {
    return countByElement[element] ?? 0;
  }
}