import 'package:flutter/material.dart';
import 'api_service.dart';
import 'homepage.dart';
import 'package:deals_dray_b2b/globals.dart' as globals;

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();

  String? _email;
  String? _password;
  String? _referralCode;
  String? _apiMessage;


  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();


      String userId = globals.userId!;

      final response = await apiService.emailReferral(_email!, _password!, _referralCode ?? '', userId);


      setState(() {
        if (response != null && response['status'] == 1 && response['data']['message'] == "Successfully Added") {
          _apiMessage = response['data']['message'];


          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          _apiMessage = "Something went wrong. Please try again.";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 80),
              Container(
                height: 150,
                child: Image.asset('assets/logo2.png'),
              ),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(left: 45.0, right: 80),
                child: Column(
                  children: [
                    Text(
                      "Let's Begin!",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 18),
                    Text(
                      "Please enter your credentials to proceed",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Your Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Create Password',
                    suffixIcon: Icon(Icons.remove_red_eye),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Referral Code (optional)",
                  ),
                  onSaved: (value) {
                    _referralCode = value;
                  },
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text("Submit"),
              ),
              SizedBox(height: 20),

              if (_apiMessage != null)
                Text(
                  _apiMessage!,
                  style: TextStyle(
                    color: _apiMessage == "Successfully Added" ? Colors.green : Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


