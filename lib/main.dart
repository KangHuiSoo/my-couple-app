import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_couple_app/config/route/router.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); //Flutter의 비동기 작업 초기화
  await initializeDateFormatting(); //로케일 데이터 초기화
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "Pretendard",
        // primarySwatch: Colors.blue,
      ),
      routerConfig: router,
    );
  }
}