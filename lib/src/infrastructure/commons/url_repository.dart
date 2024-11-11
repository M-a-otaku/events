class UrlRepository {
  UrlRepository._();

  static const String _baseUrl = 'localhost:3000';
  static const String _users = '/users';
  static const String _events = '/events';
  static const String _details = '/details';

  static Uri login(String username, String password) {
    return Uri.http(_baseUrl, _users);
  }
  static Uri register = Uri.http(_baseUrl, _users);

  static Uri users = Uri.parse('$_baseUrl$_users');
  static Uri userByUsername({required String username}) {
    return Uri.parse('$_baseUrl$_users?username=$username');
  }
  static Uri userById({required int id}) {
    return Uri.parse('$_baseUrl$_users/$id');
  }
  static Uri events = Uri.http(_baseUrl, _events);
  static Uri details = Uri.http(_baseUrl, _details);

  static Uri eventsById({required int eventId}) {
    return Uri.http(_baseUrl, '$_events/$eventId');
  }

  static Uri getMyEvents({required int creatorId}) {
    return Uri.parse('$_baseUrl$_events/?creatorId=$creatorId');
  }

  static Uri deleteEventById({required int eventId}) {
    return Uri.parse('$_baseUrl$_events/$eventId');
  }



// static Uri itemsById({required int itemId}) {
//   return Uri.http(_baseUrl, '$_items/$itemId');
// }
}
