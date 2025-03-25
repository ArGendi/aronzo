import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:yofa/cubits/home/home_cubit.dart';
import 'package:yofa/models/cache.dart';
import 'package:yofa/models/data.dart';
import 'package:yofa/models/firestore_services.dart';

part 'withdraw_state.dart';

class WithdrawCubit extends Cubit<WithdrawState> {
  String? phone;
  String? name;
  GlobalKey<FormState> phoneFormKey = GlobalKey<FormState>();
  WithdrawType type = WithdrawType.none;
  bool showNormalScreen = true;
  double? money;

  WithdrawCubit() : super(WithdrawInitial());
  static WithdrawCubit get(BuildContext context) => BlocProvider.of(context);

  void onWithdraw(BuildContext context) async{
    bool valid = phoneFormKey.currentState?.validate() ?? false;
    if(valid){
      phoneFormKey.currentState?.save();
      if(type != WithdrawType.none){
        emit(WithdrawLoadingState());
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        //print('Device ID: ${androidInfo.id}');
        await FirestoreServices.set("Withdraw", androidInfo.id, {
          "name": name,
          "phone": phone,
          "money": money,
          "type": type == WithdrawType.instapay ? "Instapay" : "Wallet",
          "completed": false,
          "clicks": Cache.getClicks()
        });
        showNormalScreen = false;
        Cache.clear();
        if(context.mounted){
          HomeCubit.get(context).getMoneyAndClicksFromCache();
        }
        emit(WithdrawChangedState());
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("أختار بين انستا باي و محفظة"))
        );
      }
    }
  }

  void getInfo(BuildContext context) async{
    money = HomeCubit.get(context).money;
    emit(WithdrawLoadingInfoState());
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    log(androidInfo.id);
    var response = await FirestoreServices.getInfo(androidInfo.id);
    log(response.data.toString());
    if(response.status == Status.success){
      showNormalScreen = response.data["completed"];
      log(response.data["completed"].toString());
      if(!showNormalScreen){
        name = response.data["name"];
        phone = response.data["phone"];
        money = response.data["money"];
      }
    }
    emit(WithdrawChangedState());
  }

  void setType(WithdrawType value){
    type = value;
    emit(WithdrawChangedState());
  }
}


enum WithdrawType{
  instapay,
  wallet,
  none,
}
