import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';
import 'package:yofa/cubits/Ads/ads_cubit.dart';
import 'package:yofa/cubits/home/home_cubit.dart';

part 'internet_connection_state.dart';

class InternetConnectionCubit extends Cubit<InternetConnectionState> {
  bool isConnected = false;
  final connectionChecker = InternetConnectionChecker.instance;
  StreamSubscription<InternetConnectionStatus>? subscription;

  InternetConnectionCubit() : super(InternetConnectionInitial());
  static InternetConnectionCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> checkInternetConnection(BuildContext context) async {
    // Check network connectivity (Wi-Fi or mobile data)'
    emit(InternetConnectionLoadingState());
    var connectivityResult = await Connectivity().checkConnectivity();
    print('1');
    // Check if there's an active internet connection
    if (!connectivityResult.contains(ConnectivityResult.none)) {
      print('2');
      subscription = connectionChecker.onStatusChange.listen(
        (InternetConnectionStatus status) {
          if (status == InternetConnectionStatus.connected) {
            print('Connected to the internet');
            isConnected = true;
            emit(InternetConnectionChangedState());
            if(context.mounted){
              HomeCubit.get(context).getMoneyAndClicksFromCache();
              AdsCubit.get(context).loadBannerAd(context);
              AdsCubit.get(context).loadInterstitialAd(context);
            }
            
          } else {
            print('Disconnected from the internet');
            isConnected = false;
            emit(InternetConnectionChangedState());
          }
        },
      );
      // bool isDeviceConnected = await InternetConnectionChecker.instance.hasConnection;
      // isConnected = isDeviceConnected;
    } else {
      print('3');
      isConnected = false;
      emit(InternetConnectionChangedState());
    }
    print('4');
    //emit(InternetConnectionChangedState());
  }

  void closeConnection(){
    isConnected = false;
    connectionChecker.dispose();
    subscription?.cancel();
    emit(InternetConnectionChangedState());
  }
}
