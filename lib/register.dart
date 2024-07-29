import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  final String _role = 'user';

  Future<void> _register() async {
    final response = await http.post(
      Uri.parse('https://app-api-seven.vercel.app/user/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': _username,
        'password': _password,
        'role': _role,
      }),
    );

    if (response.statusCode == 201) {
      // Registration successful
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ລົງທະບຽນສຳເລັດ. ກະລຸນາເຂົ້າສູ່ລະບົບ.')),
      );
      Navigator.pop(context);
    } else {
      // Registration failed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ລົງທະບຽນລົ້ມເຫຼວ. ກະລຸນາລອງອີກຄັ້ງ.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ລົງທະບຽນ'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'ຊື່ຜູ້ໃຊ້'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ກະລຸນາປ້ອນເຊື່ອຜູ້ໃຊ້';
                  }
                  return null;
                },
                onSaved: (value) => _username = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'ລະຫັດຜ່ານ'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ກະລຸນາປ້ອນລະຫັດຜ່ານ';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              // DropdownButtonFormField<String>(
              //   value: _role,
              //   decoration: InputDecoration(labelText: 'ສິດ'),
              //   items: <String>['user', 'admin'].map((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(value),
              //     );
              //   }).toList(),
              //   onChanged: (String? newValue) {
              //     setState(() {
              //       _role = newValue!;
              //     });
              //   },
              // ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('ລົງທະບຽນ'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _register();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
