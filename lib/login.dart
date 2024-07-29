import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:odeng_store/main.dart';
import 'dart:convert';
import 'package:odeng_store/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  Future<String?> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Show the loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Dialog(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text("Loading..."),
                ],
              ),
            ),
          );
        },
      );

      try {
        final response = await http.post(
          Uri.parse('https://app-api-seven.vercel.app/user/login'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'username': _username,
            'password': _password,
          }),
        );

        // Dismiss the loading dialog
        Navigator.of(context).pop();

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          return responseData[
              '_id']; // Adjust this based on actual API response
        } else {
          throw Exception('ເຂົ້າສູ່ລະບົບບໍ່ສຳເລັດ');
        }
      } catch (e) {
        // Dismiss the loading dialog
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ເຂົ້າສູ່ລະບົບລົ້ມເຫຼວ: $e')),
        );
        rethrow;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ເຂົ້າສູ່ລະບົບ')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 0), // Add some space at the top
              Image.asset(
                'asset/icons/odeng.jpeg',
                height: 120, // Adjust the height as needed
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'ຊື່ຜູ້ໃຊ້',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ກະລຸນາປ້ອນຊື່ຜູ້ໃຊ້';
                  }
                  return null;
                },
                onSaved: (value) => _username = value!,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'ລະຫັດຜ່ານ',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ກະລຸນະປ້ອນລະຫັດຜ່ານ';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final id = await _login();
                    if (id != null) {
                      // Navigate to HomePage with userId
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyHomePage(userId: id)),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('ເຂົ້າສູ່ລະບົບລົ້ມເຫຼວ: $e')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      const Size(double.infinity, 50), // full-width button
                ),
                child: const Text('ເຂົ້າສູ່ລະບົບ'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Navigate to RegisterPage
                  // You need to create this page and add the navigation
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterPage()),
                  );
                },
                style: TextButton.styleFrom(
                  minimumSize:
                      const Size(double.infinity, 50), // full-width button
                ),
                child: const Text('ລົງທະບຽນ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
