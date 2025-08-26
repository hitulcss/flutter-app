
class AppException implements Exception{
  final String prefix;
  final String message;

  AppException({required this.prefix,required this.message});

  @override
  String toString(){
    return '$prefix $message';
  }
}


class FetchDataException extends AppException{
  FetchDataException({required super.message}):super(prefix: 'Error During Communication');
}

class BadRequestException extends AppException{
  BadRequestException({required super.message}):super(prefix: 'Invalid Request');
}

class UnauthorisedException extends AppException{
  UnauthorisedException({required super.message}):super(prefix: 'Unauthorised Request');
}

class InValidInputException extends AppException{
  InValidInputException({required super.message}):super(prefix: 'Invalid Input');
}
