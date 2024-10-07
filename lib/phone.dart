import 'package:deals_dray_b2b/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'otp.dart';
import 'api_service.dart';

class Phone extends StatefulWidget {
  const Phone({super.key});

  @override
  State<Phone> createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  String selectedButton = 'Phone';
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 70),
            Container(height: 150, child: Image.asset('assets/logo2.png')),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 100, right: 100),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.grey,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedButton = 'Phone';
                          });
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: selectedButton == 'Phone' ? Colors.red : Colors.grey,
                          ),
                          child: Center(
                            child: Text(
                              "Phone",
                              style: TextStyle(
                                color: selectedButton == 'Phone' ? Colors.white : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedButton = 'Email';
                            Navigator.pushNamed(context, '/email');
                          });
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: selectedButton == 'Email' ? Colors.red : Colors.grey,
                          ),
                          child: Center(
                            child: Text(
                              "Email",
                              style: TextStyle(
                                color: selectedButton == 'Email' ? Colors.white : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.only(left: 45.0, right: 100),
              child: Column(
                children: [
                  Text(
                    "Glad to See you!    ",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 18),
                  Text(
                    "Please Provide your phone number",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(35.0),
              child: TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: "Phone",
                  // border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(35.0),
              child: Container(
                width: double.infinity,
                child: MaterialButton(
                  height: 60,
                  color: Colors.pink[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: _isLoading ? null : _sendOtp, // Call _sendOtp
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "SEND CODE",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendOtp() async {
    setState(() {
      _isLoading = true;
    });
    String phone = _phoneController.text.trim();

    if (phone.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid phone number')),
      );
      return;
    }

    try {

      Map<String, dynamic> response = await _apiService.sendOtp(phone, globals.deviceId!);


      if (response['status'] == 1) {
        globals.userId = response['data']['userId'];
        globals.deviceId = response['data']['deviceId'];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP sent successfully')),
        );


        Navigator.push(context, MaterialPageRoute(builder: (context) => OtpPage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send OTP')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
