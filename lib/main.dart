import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_couple_app/ui/login/login_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); //Flutter의 비동기 작업 초기화
  await initializeDateFormatting(); //로케일 데이터 초기화
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "Pretendard",
        // primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      // home: BottomNavigationScreen(),
    );
  }
}