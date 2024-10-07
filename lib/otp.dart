import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:deals_dray_b2b/globals.dart' as globals;
import 'package:deals_dray_b2b/homepage.dart';
import 'package:deals_dray_b2b/email.dart';
import 'api_service.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  int _remainingTime = 120;
  Timer? _timer;
  String? _otp;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }


  void _verifyOtp() async {

    if (_otp == null || _otp!.isEmpty || globals.deviceId == null || globals.userId == null) {
      print('Please enter valid OTP and ensure deviceId and userId are not null');
      return;
    }


    final response = await apiService.verifyOtp(_otp!, globals.deviceId!, globals.userId!);

    if (response != null && response['status'] == 1) {
      if (response['data']['registration_status'] == 'Incomplete') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EmailPage()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    } else {
      print('OTP verification failed');

    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secondsDisplay = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secondsDisplay';
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
        color: Colors.black,
      ),
      borderRadius: BorderRadius.circular(14),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
        border: Border.all(
          color: Colors.black,
        ),
      ),
    );

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 80),
          Padding(
            padding: const EdgeInsets.only(left: 0.0, right: 250, top: 25),
            child: Container(
              child: Image.asset('assets/otp.png'),
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 0.0, right: 150),
            child: Text(
              "OTP Verification",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, top: 20, right: 50),
            child: Text(
              "We have sent a unique OTP number to your mobile +91-9765232817",
              style: TextStyle(
                fontSize: 19,
              ),
            ),
          ),
          SizedBox(height: 25),
          // Display the Pinput fields
          Padding(
            padding: const EdgeInsets.only(left: 0.0, right: 50),
            child: Pinput(
              length: 4,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              submittedPinTheme: submittedPinTheme,
              showCursor: true,
              onCompleted: (pin) {
                setState(() {
                  _otp = pin;
                });
              },
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _verifyOtp,
            child: Text("Verify OTP"),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40.0, top: 15),
            child: Row(
              children: [
                Text(
                  _formatTime(_remainingTime),
                  style: TextStyle(fontSize: 18),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "SEND AGAIN",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
