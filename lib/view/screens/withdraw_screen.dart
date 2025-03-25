// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yofa/constants.dart';
import 'package:yofa/cubits/home/home_cubit.dart';
import 'package:yofa/cubits/widthraw/withdraw_cubit.dart';
import 'package:yofa/view/widgets/custom_button.dart';
import 'package:yofa/view/widgets/custom_texfield.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key,});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WithdrawCubit.get(context).getInfo(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aronzo Cash"),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<WithdrawCubit, WithdrawState>(
          builder: (context, state) {
            if (state is WithdrawLoadingInfoState) {
              return Center(
                child: CircularProgressIndicator(
                  color: mainColor,
                ),
              );
            } else if (!WithdrawCubit.get(context).showNormalScreen) {
              var cub = WithdrawCubit.get(context);
              return Center(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "سيتم تحول مبلغ ${cub.money?.toStringAsFixed(2)}\n بأسم ${cub.name}\n علي رقم ${cub.phone}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        " خلال 3 ايام ⏳",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Column(
              children: [
                Text(
                  "اسحب فلوسك عن طريق انستا باي او علي رقم محفظتك",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                // Text(
                //   "الحد الأدنى للسحب 100 جنية",
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //       fontSize: 17,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.green),
                // ),
                SizedBox(
                  height: 25,
                ),
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ListView(
                      //abdelcrossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "أدخل رقم موبايلك وحدد الرقم عليه انستا باي ولا محفظة",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              //fontSize: 18,
                              ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Form(
                          key: WithdrawCubit.get(context).phoneFormKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomTextFormField(
                                text: "أدخل اسمك",
                                onSaved: (value) {
                                  WithdrawCubit.get(context).name = value;
                                },
                                onValidate: (value) {
                                  if (value!.isEmpty) {
                                    return "أدخل الأسم";
                                  } else
                                    return null;
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CustomTextFormField(
                                keyboardType: TextInputType.phone,
                                text: "أدخل رقم الموبايل",
                                onSaved: (value) {
                                  WithdrawCubit.get(context).phone = value;
                                },
                                onValidate: (value) {
                                  if (value!.isEmpty) {
                                    return "أدخل رقم الموبايل";
                                  } else if (value.length != 11) {
                                    return "أدخل رقم صحيح 01xxxxxxxxx";
                                  } else
                                    return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "أختار بينهم",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              //fontSize: 18,
                              ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        BlocBuilder<WithdrawCubit, WithdrawState>(
                          builder: (context, state) {
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    WithdrawCubit.get(context)
                                        .setType(WithdrawType.instapay);
                                  },
                                  child: AnimatedContainer(
                                    width: double.infinity,
                                    duration: Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      color: WithdrawCubit.get(context).type ==
                                              WithdrawType.instapay
                                          ? mainColor
                                          : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                      // border: Border.all(
                                      //     color: Colors.grey.shade300,
                                      //     width: 2,
                                      //     )
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Center(
                                        child: Text(
                                          "انستا باي",
                                          style: TextStyle(
                                            fontSize: 17,
                                            //fontWeight: FontWeight.bold,
                                            color: WithdrawCubit.get(context)
                                                        .type ==
                                                    WithdrawType.instapay
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    WithdrawCubit.get(context)
                                        .setType(WithdrawType.wallet);
                                  },
                                  child: AnimatedContainer(
                                    width: double.infinity,
                                    duration: Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      color: WithdrawCubit.get(context).type ==
                                              WithdrawType.wallet
                                          ? mainColor
                                          : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                      // border: Border.all(
                                      //     color: Colors.grey.shade200,
                                      //     width: 2,
                                      //     )
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Center(
                                        child: Text(
                                          "محفظة",
                                          style: TextStyle(
                                            fontSize: 17,
                                            //fontWeight: FontWeight.bold,
                                            color: WithdrawCubit.get(context)
                                                        .type ==
                                                    WithdrawType.wallet
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("يمكنك السحب عند الوصول ل100 جنية"),
                BlocBuilder<WithdrawCubit, WithdrawState>(
                  builder: (context, state) {
                    if(state is WithdrawLoadingState){
                      return Center(
                        child: CircularProgressIndicator(
                          color: mainColor,
                        ),
                      );
                    }
                    else return CustomButton(
                      text: "سحب",
                      onPressed: HomeCubit.get(context).money >= 100.00
                          ? () {
                              WithdrawCubit.get(context).onWithdraw(context);
                            }
                          : null,
                    );
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    children: [
                      Text("By: Yofa"),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
