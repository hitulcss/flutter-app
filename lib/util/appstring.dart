class Fontsize {
   double h2 = 22.0;
   double h3 = 16.0;
   double h4 = 14.0;
   double h5 = 12.0;
   double h6 = 8.0;
   
}

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
  
}