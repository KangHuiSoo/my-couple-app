import 'package:go_router/go_router.dart';
import 'package:my_couple_app/ui/view/bottom_navigation/main_screen.dart';
import 'package:my_couple_app/ui/view/home/home_screen.dart';
import 'package:my_couple_app/ui/view/join/join_screen.dart';
import 'package:my_couple_app/ui/view/link/ask_couple_link_screen.dart';
import 'package:my_couple_app/ui/view/link/couple_link_screen.dart';
import 'package:my_couple_app/ui/view/login/login_screen.dart';
import 'package:my_couple_app/ui/view/mypage/mypage_screen.dart';
import 'package:my_couple_app/ui/view/mypage/password_edit_screen.dart';
import 'package:my_couple_app/ui/view/mypage/profile_edit_screen.dart';
import 'package:my_couple_app/ui/view/place/datepicker_screen.dart';
import 'package:my_couple_app/ui/view/place/place_add_screen.dart';
import 'package:my_couple_app/ui/view/place/place_list_screen.dart';
import 'package:my_couple_app/ui/view/place/place_search_screen.dart';

import '../../data/model/place/place.dart';

final GoRouter router = GoRouter(
    // redirect: (context, state) {
    //   final isLogin = true;
    //   if (!isLogin && state.fullPath != '/login'){
    //     return '/login';
    //   }
    //   return null;
    // },
    routes: [
      GoRoute(path: '/', builder: (context, state) => LoginScreen()),
      GoRoute(path: '/join', builder: (context, state) => JoinScreen()),
      GoRoute(path: '/askCoupleLink', builder: (context, state) => AskCoupleLinkScreen()),
      GoRoute(path: '/coupleLink', builder: (context, state) => CoupleLinkScreen()),
      // GoRoute(path: '/placeDetail', builder: (context, state) {
      //   final url = state.uri.queryParameters['url'];  // id 값 가져오기
      //   print(" ==========>>>>>>>>>>>>> $url");
      //   return PlaceDetailWebview(url: url!);
      // }),
      ShellRoute(
        builder: (context, state, child) {
          return MainScreen(child: child);
        },
        routes: [
          GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
          GoRoute(path: '/placeList', builder: (context, state) => PlaceListScreen()),
          GoRoute(path: '/placeAdd', builder: (context, state) {
            final searchPlace = state.extra as Place?;
            return PlaceAddScreen(searchPlace);
          }),
          GoRoute(path: '/placeSearch', builder: (context, state) => PlaceSearchScreen()),
          GoRoute(path: '/datePicker', builder: (context, state) => DatepickerScreen()),
          GoRoute(path: '/myPage', builder: (context, state) => MyPageScreen()),
          GoRoute(path: '/profileEdit', builder: (context, state) => ProfileEditScreen()),
          GoRoute(path: '/passwordEdit', builder: (context, state) => PasswordEditScreen()),
        ],
      )
    ]);
