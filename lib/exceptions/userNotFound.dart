class UserNotFound implements Exception{
  final String message;

  UserNotFound(this.message);

  @override
  String toString() => 'UserNotFound: $message';

  
}
