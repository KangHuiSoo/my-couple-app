import 'package:go_router/go_router.dart';
import 'package:my_couple_app/ui/view/bottom_navigation/main_screen.dart';
import 'package:my_couple_app/ui/view/home/home_screen.dart';
import 'package:my_couple_app/ui/view/link/ask_couple_link_screen.dart';
import 'package:my_couple_app/ui/view/link/couple_link_screen.dart';
import 'package:my_couple_app/ui/view/mypage/mypage_screen.dart';
import 'package:my_couple_app/ui/view/mypage/password_edit_screen.dart';
import 'package:my_couple_app/ui/view/mypage/profile_edit_screen.dart';
import 'package:my_couple_app/ui/view/place/datepicker_screen.dart';
import 'package:my_couple_app/ui/view/place/place_add_screen.dart';
import 'package:my_couple_app/ui/view/place/place_list_screen.dart';
import 'package:my_couple_app/ui/view/place/place_search_screen.dart';

import '../../data/model/place/place.dart';
import '../../ui/view/auth/join_screen.dart';
import '../../ui/view/auth/login_screen.dart';

final GoRouter router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => LoginScreen(),
    routes: [
      GoRoute(path: '/join', builder: (context, state) => JoinScreen()),
      GoRoute(
          path: '/askCoupleLink',
          builder: (context, state) => AskCoupleLinkScreen()),
      GoRoute(
          path: '/coupleLink', builder: (context, state) => CoupleLinkScreen()),
      GoRoute(path: '/askCoupleLink', builder: (context, state) => AskCoupleLinkScreen()),
    ],
  ),
  ShellRoute(
    builder: (context, state, child) {
      return MainScreen(child: child);
    },
    routes: [
      GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
      GoRoute(
          path: '/placeList', builder: (context, state) => PlaceListScreen()),
      GoRoute(
          path: '/placeAdd',
          builder: (context, state) {
            final place = state.extra as Place?;
            return PlaceAddScreen(searchPlace: place);
          }),
      GoRoute(
          path: '/placeSearch',
          builder: (context, state) => PlaceSearchScreen()),
      GoRoute(
          path: '/datePicker', builder: (context, state) => DatepickerScreen()),
      GoRoute(path: '/myPage', builder: (context, state) => MyPageScreen()),
      GoRoute(
          path: '/profileEdit',
          builder: (context, state) => ProfileEditScreen()),
      GoRoute(
          path: '/passwordEdit',
          builder: (context, state) => PasswordEditScreen()),
    ],
  )
]);
