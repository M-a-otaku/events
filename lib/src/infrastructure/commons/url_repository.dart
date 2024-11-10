class UrlRepository {
  UrlRepository._();

  static const String _baseUrl = 'localhost:3000';
  static const String _users = '/users';
  static const String _events = '/events';
  static const String _details = '/details';

  static Uri users = Uri.http(_baseUrl, _users);
  static Uri events = Uri.http(_baseUrl, _events);
  static Uri details = Uri.http(_baseUrl, _details);

  static Uri eventsById({required int eventId}) {
    return Uri.http(_baseUrl, '$_events/$eventId');
  }

  // static Uri itemsById({required int itemId}) {
  //   return Uri.http(_baseUrl, '$_items/$itemId');
  // }
}
