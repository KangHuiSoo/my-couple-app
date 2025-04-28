import 'package:go_router/go_router.dart';
import 'package:my_couple_app/core/ui/bottom_navigation/main_screen.dart';
import 'package:my_couple_app/features/couple/view/ask_couple_link_screen.dart';
import 'package:my_couple_app/features/couple/view/couple_link_screen.dart';
import 'package:my_couple_app/features/place/view/place_list_screen.dart';
import 'package:my_couple_app/features/place/view/place_search_screen.dart';
import 'package:my_couple_app/features/home/view/home_screen.dart';
import 'package:my_couple_app/features/mypage/view/mypage_screen.dart';
import 'package:my_couple_app/features/mypage/view/password_edit_screen.dart';
import 'package:my_couple_app/features/mypage/view/profile_edit_screen.dart';
import 'package:my_couple_app/features/place/view/datepicker_screen.dart';
import 'package:my_couple_app/features/place/view/place_add_screen.dart';
import '../../features/place/model/place.dart';
import '../../features/auth/view/join_screen.dart';
import '../../features/auth/view/login_screen.dart';

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
      GoRoute(
          path: '/askCoupleLink',
          builder: (context, state) => AskCoupleLinkScreen()),
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
