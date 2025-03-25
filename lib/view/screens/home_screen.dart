// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:yofa/cubits/Ads/ads_cubit.dart';
import 'package:yofa/cubits/home/home_cubit.dart';
import 'package:yofa/cubits/internet_connection/internet_connection_cubit.dart';
import 'package:yofa/models/local_notification.dart';
import 'package:yofa/view/screens/withdraw_screen.dart';
import 'package:yofa/view/widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void start() async {
    LocalNotificationServices.showPeriodNotification(1, "أدخل واكسب", "هذا الوقت المناسب لتحقيق الربح ادخل واربح الان");
    await InternetConnectionCubit.get(context).checkInternetConnection(context);
    // if (mounted) {
    //   log(InternetConnectionCubit.get(context).isConnected.toString());
    //   if (InternetConnectionCubit.get(context).isConnected) {
    //     HomeCubit.get(context).getMoneyAndClicksFromCache();
    //     AdsCubit.get(context).loadBannerAd(context);
    //     AdsCubit.get(context).loadInterstitialAd();
    //   }
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aronzo Cash"),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_) => WithdrawScreen()));
            }, 
            icon: Icon(Icons.account_balance_wallet_outlined),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: BlocBuilder<InternetConnectionCubit, InternetConnectionState>(
            builder: (context, state) {
              if (state is InternetConnectionLoadingState) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue.shade800,
                  ),
                );
              } else if (InternetConnectionCubit.get(context).isConnected) {
                return Column(
                  children: [
                    Text(
                      "فلوســــك",
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        return Text(
                          "${HomeCubit.get(context).money.toStringAsFixed(3)} LE",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        );
                      },
                    ),
                    Divider(
                      height: 30,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("💸 دوس اكتر.. تكسب اكتر"),
                          SizedBox(
                            height: 15,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              backgroundColor: Colors.blue.shade800,
                            ),
                            onPressed: () {
                              HomeCubit.get(context).inc(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(50.0),
                              child: BlocBuilder<HomeCubit, HomeState>(
                                builder: (context, state) {
                                  return Text(
                                    HomeCubit.get(context).counter.toString(),
                                    style: TextStyle(
                                        fontSize: 22, color: Colors.white),
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, right: 150),
                            child: Image.asset(
                              "assets/images/clickhere.png",
                              width: 80,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LottieBuilder.asset(
                      "assets/images/wifi.json",
                      width: 100,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("لا يوجد شبكة"),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: CustomButton(
                        text: "حاول مرة اخرى", 
                        onPressed: (){
                          start();
                        },
                      ),
                    )
                  ],
                );
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: BlocBuilder<AdsCubit, AdsState>(
        builder: (context, state) {
          return SizedBox(
            width: AdsCubit.get(context).bannerAd?.size.width.toDouble(),
            height: AdsCubit.get(context).bannerAd?.size.height.toDouble(),
            child: AdsCubit.get(context).bannerAd != null
                ? AdWidget(ad: AdsCubit.get(context).bannerAd!)
                : SizedBox(),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    //AdsCubit.get(context).bannerAd?.dispose();
    super.dispose();
  }
}
