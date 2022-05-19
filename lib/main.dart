import 'package:attendance/bloc/history/history_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bloc/pin_location/pin_location_cubit.dart';
import 'pages/pick_pin_location_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<PinLocationCubit>(
              create: (context) => PinLocationCubit(),
            ),
            BlocProvider<HistoryCubit>(
              create: (context) => HistoryCubit(),
            )
          ],
          child: MaterialApp(
            title: 'Flutter Attendance Demo',
            theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              primarySwatch: Colors.blue,
            ),
            home: child,
          ),
        );
      },
      child: const PickPinLocationPage(),
    );
  }
}
