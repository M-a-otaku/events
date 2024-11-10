import 'route_paths.dart';

class RouteNames {
  static const String splash = RoutePaths.splash;
  static const String login = RoutePaths.login;
  static const String register = '${RoutePaths.login}${RoutePaths.register}';
  static const String events = RoutePaths.events;
  static const String home = RoutePaths.home;
  static const String car = RoutePaths.car;
  static const String myEvents = RoutePaths.myEvents;
  static const String addEvents = '${RoutePaths.myEvents}${RoutePaths.addEvents}';
  static const String editEvents = '${RoutePaths.myEvents}${RoutePaths.editEvents}';
  static const String detailsEvent = '${RoutePaths.events}${RoutePaths.detailsEvent}';
  static const String bookmark = RoutePaths.bookmark;
}
