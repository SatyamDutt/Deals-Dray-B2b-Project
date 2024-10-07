import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://devapiv4.dealsdray.com/api/v2';

  Future<Map<String, dynamic>> addDevice(Map<String, dynamic> requestBody) async {
    final url = Uri.parse('$baseUrl/user/device/add');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to add device');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }



  Future<Map<String, dynamic>> sendOtp(String mobileNumber, String deviceId) async {
    final url = Uri.parse('$baseUrl/user/otp');
    final requestBody = {
      "mobileNumber": mobileNumber,
      "deviceId": deviceId
    };
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to send OTP');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }



  Future<Map<String, dynamic>> verifyOtp(String otp, String deviceId, String userId) async {
    final url = Uri.parse('$baseUrl/user/otp/verification');
    final requestBody = {
      "otp": otp,
      "deviceId": deviceId,
      "userId": userId
    };
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to verify OTP');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }


  Future<Map<String, dynamic>> emailReferral(String email, String password, String referralCode, String userId) async {
    final url = Uri.parse('$baseUrl/user/email/referral');
    final requestBody = {
      "email": email,
      "password": password,
      "referralCode": referralCode,
      "userId": userId
    };
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to submit email referral');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }



  Future<Map<String, dynamic>> getHomeDataWithoutPrice() async {
    final url = Uri.parse('$baseUrl/user/home/withoutPrice');
    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load home data');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

}
