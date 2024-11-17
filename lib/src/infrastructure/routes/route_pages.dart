import '../../pages/add_event/common/add_event_bindings.dart';
import '../../pages/add_event/views/add_event_view.dart';
import '../../pages/bookmark/common/bookmark_event_binding.dart';
import '../../pages/bookmark/views/bookmark_event_screen.dart';
import '../../pages/bottom_nav_bar/bindings/nav_bar.dart';
import '../../pages/bottom_nav_bar/views/bottom_nav_bar.dart';
import '../../pages/edit_event/common/edit_event_bindings.dart';
import '../../pages/my_events/common/my_events_bindings.dart';
import '../../pages/my_events/views/my_events_view.dart';
import '../../pages/edit_event/views/edit_event_view.dart';
import '../../pages/event_details/common/event_details_bindings.dart';
import '../../pages/event_details/views/event_details_view.dart';
import '../../pages/events/common/events_bindings.dart';
import '../../pages/events/views/events_view.dart';
import '../../pages/login/commons/login_bindings.dart';
import '../../pages/login/views/login_view.dart';
import '../../pages/register/common/register_bindings.dart';
import '../../pages/register/views/register_view.dart';
import '../../pages/splash/commons/splash_bindings.dart';
import '../../pages/splash/views/splash_screen.dart';
import 'route_paths.dart';
import 'package:get/get.dart';

class RoutePages {
  static List<GetPage> pages = [
    GetPage(
        name: RoutePaths.splash,
        page: () => const SplashScreen(),
        binding: SplashBindings()),
    GetPage(
        name: RoutePaths.login,
        page: () => const LoginView(),
        binding: LoginBindings(),
        children: [
          GetPage(
            name: RoutePaths.register,
            page: () => const RegisterView(),
            binding: RegisterBindings(),
          )
        ]),
    GetPage(
        name: RoutePaths.events,
        page: () => const EventsView(),
        binding: EventsBindings(),
        children: [
          GetPage(
              name: RoutePaths.detailsEvent,
              page: () =>  const EventDetailsView(),
              binding: EventDetailBindings())
        ]),
    GetPage(
        name: RoutePaths.bookmark,
        page: () => const BookmarkEventScreen(),
        binding: BookmarkEventBinding()),
    GetPage(
        name: RoutePaths.home,
        page: () => const BottomNavBar(),
        binding: NavBarBindings()),
    GetPage(
        name: RoutePaths.myEvents,
        page: () => const MyEventsView(),
        binding: MyEventsBindings(),
        children: [
          GetPage(
              name: RoutePaths.addEvents,
              page: () => const AddEventView(),
              binding: AddEventBindings()),
          GetPage(
              name: RoutePaths.editEvents,
              page: () => const EditEventView(),
              binding: EditEventBinding()),
        ])
  ];
}
