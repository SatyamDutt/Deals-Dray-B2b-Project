import 'dart:async';
import 'package:deals_dray_b2b/phone.dart';
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'globals.dart' as globals;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _registerDevice();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Phone()),
      );
    });
  }

  Future<void> _registerDevice() async {

    Map<String, dynamic> requestBody = {
      "deviceType": "android",
      "deviceId": "C6179909526098",
      "deviceName": "Samsung-MT200",
      "deviceOSVersion": "2.3.6",
      "deviceIPAddress": "11.433.445.66",
      "lat": 9.9312,
      "long": 76.2673,
      "buyer_gcmid": "",
      "buyer_pemid": "",
      "app": {
        "version": "1.20.5",
        "installTimeStamp": "2022-02-10T12:33:30.696Z",
        "uninstallTimeStamp": "2022-02-10T12:33:30.696Z",
        "downloadTimeStamp": "2022-02-10T12:33:30.696Z"
      }
    };

    try {

      Map<String, dynamic> response = await _apiService.addDevice(requestBody);

      if (response['status'] == 1) {
        globals.deviceId = response['data']['deviceId'];
        print("Device ID stored globally: ${globals.deviceId}");
      } else {
        print("Failed to add device: ${response['data']['message']}");
      }
    } catch (error) {
      print("Error in device registration: $error");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Image.asset('assets/splash_screen_image.jpg'),
    );
  }
}


