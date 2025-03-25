import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:yofa/cubits/Ads/ads_cubit.dart';
import 'package:yofa/cubits/home/home_cubit.dart';
import 'package:yofa/cubits/internet_connection/internet_connection_cubit.dart';
import 'package:yofa/cubits/widthraw/withdraw_cubit.dart';
import 'package:yofa/firebase_options.dart';
import 'package:yofa/models/cache.dart';
import 'package:yofa/models/local_notification.dart';
import 'package:yofa/view/screens/home_screen.dart';
import 'package:yofa/view/screens/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  LocalNotificationServices.init();
  await Cache.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => InternetConnectionCubit()),
        BlocProvider(create: (_) => AdsCubit()),
        BlocProvider(create: (_) => WithdrawCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue.shade800,
            foregroundColor: Colors.white,
          ),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
