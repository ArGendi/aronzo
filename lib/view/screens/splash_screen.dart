// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:typewritertext/typewritertext.dart';
import 'package:video_player/video_player.dart';
import 'package:yofa/constants.dart';
import 'package:yofa/view/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = VideoPlayerController.asset('assets/images/splash_video.mp4');
    controller.initialize().then((value){
      controller.addListener(() {                       //custom Listner
        setState(() {
          if (!controller.value.isPlaying &&controller.value.isInitialized &&
              (controller.value.duration ==controller.value.position)) { //checking the duration and position every time
            if(mounted){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
            }
          }
        });
      });
      // setState(() {
        
      // });
    });
    controller.play();
  }

  @override
  Widget build(BuildContext context) {

    // Timer.periodic(Duration(milliseconds: 3000), (t){
    //   if(mounted){
    //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    //   }
    // });

    return Scaffold(
      backgroundColor: mainColor,
      body: Center(
        child: Stack(
          children: [
            SizedBox(
              width: 300,
              height: 700,
              child: VideoPlayer(controller),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 200,
                height: 100,
                color: mainColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }
}