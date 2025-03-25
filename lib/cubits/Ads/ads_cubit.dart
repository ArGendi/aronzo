import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:meta/meta.dart';
import 'package:yofa/cubits/home/home_cubit.dart';
import 'package:yofa/cubits/internet_connection/internet_connection_cubit.dart';

part 'ads_state.dart';

class AdsCubit extends Cubit<AdsState> {
  BannerAd? bannerAd;
  InterstitialAd? interstitialAd;
  bool bannerLoaded = false;

  AdsCubit() : super(AdsInitial());
  static AdsCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> loadBannerAd(BuildContext context) async{
    if(bannerLoaded){
      log("hereee");
      return;
    }
    bannerAd = BannerAd(
      adUnitId: kReleaseMode ? 
        "ca-app-pub-8711020842224112/2162893824" : "ca-app-pub-3940256099942544/9214589741",
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('Banner Ad loaded.');
          bannerLoaded = true;
          emit(AdsBannerLoadedState());
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Banner Ad failed to load: $error');
          bannerLoaded = false;
          //InternetConnectionCubit.get(context).closeConnection();
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text(error.toString()))
          // );
        },
      ),
    )..load();
  }

  void loadInterstitialAd(BuildContext context) {
    InterstitialAd.load(
      adUnitId: kReleaseMode ? 
        "ca-app-pub-8711020842224112/3440316474" : "ca-app-pub-3940256099942544/1033173712",
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          interstitialAd = ad;
          showInterstitialAd();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Interstitial Ad failed to load: $error');
          // HomeCubit.get(context).decreasePoints();
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text("تم خصم 70 نقطة بسبب عدم ظهور الأعلان"))
          // );
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (interstitialAd != null) {
      interstitialAd!.show();
    }
  }
}
