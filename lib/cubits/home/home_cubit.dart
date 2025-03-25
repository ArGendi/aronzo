import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';
import 'package:yofa/cubits/Ads/ads_cubit.dart';
import 'package:yofa/models/cache.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  int counter = 0;
  double money = 0;
 
  HomeCubit() : super(HomeInitial());
  static HomeCubit get(BuildContext context) => BlocProvider.of(context);

  void getMoneyAndClicksFromCache(){
    money = Cache.getDecryptedMoney() ?? 0;
    counter = Cache.getClicks() ?? 0;
    emit(HomeChangedState());
  }

  void inc(BuildContext context){
    counter++;
    if(counter % 2 == 0){
      money += 0.005;
      Cache.setEncryptedMoney(money);
      Cache.setClicks(counter);
    }
    if(counter % 70 == 0){
      AdsCubit.get(context).loadInterstitialAd(context);
      AdsCubit.get(context).loadBannerAd(context);
    }
    emit(HomeChangedState());
  }

  void decreasePoints(){
    counter -= 70;
    money -= 0.35;
    Cache.setEncryptedMoney(money);
    Cache.setClicks(counter);
    emit(HomeChangedState());
  }

}
