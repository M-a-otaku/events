class UrlRepository {
  UrlRepository._();

  static const String _baseUrl = 'localhost:3000';
  static const String _users = '/users';
  static const String _events = '/events';
  static const String _details = '/details';
  static const String _bookmark = '/bookmark';

  static Uri login(String username, String password) {
    return Uri.http(_baseUrl, _users);
  }

  static Uri register = Uri.http(_baseUrl, _users);

  static Uri users = Uri.parse('$_baseUrl$_users');

  static Uri userByUsername({required String username}) {
    return Uri.parse('http://$_baseUrl$_users?username=$username');
  }


  static Uri events = Uri.http(_baseUrl, _events);

  static Uri getEventsByParameters({required String parameters}) {
    return Uri.http(
      'localhost:3000',
      '$_events/$parameters',
    );
  }


  static Uri getEventById({required String eventId}) {
    return Uri.http(
      'localhost:3000',
      '$_events/$eventId',
    );
  }

  static Uri getUserById({required int userId}) {
    return Uri.http(
      'localhost:3000',
      '$_users/$userId',
    );
  }

  static Uri updateBookmark({required int userId}) {
    return Uri.http(
      'localhost:3000',
      '$_users/bookmark',
    );
  }

  static Uri myEvents(int userId) => Uri.http(_baseUrl, _events);

  static Uri getEventsByUserId({required int userId}) {
    return Uri.parse('$_baseUrl$_events?userId=$userId');
  }

  static Uri details = Uri.http(_baseUrl, _details);

  static Uri eventsById({required int eventId}) {
    return Uri.http(_baseUrl, '$_events/$eventId');
  }

  static Uri getMyEvents({required int creatorId}) {
    return Uri.parse('$_baseUrl$_events/?creatorId=$creatorId');
  }

  static Uri deleteEventById({required int eventId}) {
    return Uri.parse('http://$_baseUrl$_events/$eventId');
  }

  // static Uri deleteEventById({required int eventId}) {
  //   return Uri.http(
  //     'localhost:3000',
  //     '$_events/$eventId',
  //   );
  // }

  static Uri deleteEventById22({required int eventId}) =>
      Uri.http(_baseUrl, _events);

// static Uri itemsById({required int itemId}) {
//   return Uri.http(_baseUrl, '$_items/$itemId');
// }
}
