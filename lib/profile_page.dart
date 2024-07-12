import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.pink, width: 4),
                  image: DecorationImage(
                    image: AssetImage('assets/images/default_profile.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.pink),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditDataPage(mode: EditMode.EditProfile),
                    ),
                  );
                },
                child: Text('Ubah Profil'),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.pink),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditDataPage(mode: EditMode.EditEmail),
                    ),
                  );
                },
                child: Text('Ubah Email Profil'),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.pink),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditDataPage(mode: EditMode.EditPassword),
                    ),
                  );
                },
                child: Text('Ubah Sandi Profil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum EditMode {
  EditProfile,
  EditEmail,
  EditPassword,
}

class EditDataPage extends StatelessWidget {
  final EditMode mode;
  final TextEditingController oldEmailController = TextEditingController();
  final TextEditingController newEmailController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  EditDataPage({required this.mode});

  Future<void> updateData(BuildContext context) async {
    String apiUrl =
        'http://192.168.42.224/api/update_password'; // Ganti dengan URL backend Anda
    Map<String, String> data = {};

    if (mode == EditMode.EditProfile) {
      data = {
        'new_name': newEmailController.text,
      };
      apiUrl =
          'http://10.0.2.2:5000/api/update_profile'; // Sesuaikan dengan endpoint untuk mengubah profil
    } else if (mode == EditMode.EditEmail) {
      if (oldEmailController.text.isEmpty || newEmailController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email tidak boleh kosong')),
        );
        return;
      }
      apiUrl = 'http://10.0.2.2:5000/api/update_email';
      data = {
        'old_email': oldEmailController.text,
        'new_email': newEmailController.text,
      };
    } else if (mode == EditMode.EditPassword) {
      if (oldPasswordController.text.isEmpty ||
          newPasswordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sandi tidak boleh kosong')),
        );
        return;
      }
      apiUrl = 'http://10.0.2.2:5000/api/update_password';
      data = {
        'old_password': oldPasswordController.text,
        'new_password': newPasswordController.text,
      };
    }

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data berhasil diperbarui')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui data')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal terhubung ke server')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = '';
    String labelText = '';

    if (mode == EditMode.EditProfile) {
      title = 'Ubah Profil';
      labelText = 'Nama Baru';
    } else if (mode == EditMode.EditEmail) {
      title = 'Ubah Email Profil';
      labelText = 'Email Baru';
    } else if (mode == EditMode.EditPassword) {
      title = 'Ubah Sandi Profil';
      labelText = 'Sandi Baru';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (mode == EditMode.EditEmail)
              Column(
                children: [
                  TextField(
                    controller: oldEmailController,
                    decoration: InputDecoration(
                      labelText: 'Email Lama',
                    ),
                  ),
                  TextField(
                    controller: newEmailController,
                    decoration: InputDecoration(
                      labelText: labelText,
                    ),
                  ),
                ],
              ),
            if (mode == EditMode.EditPassword)
              Column(
                children: [
                  TextField(
                    controller: oldPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Sandi Lama',
                    ),
                    obscureText: true,
                  ),
                  TextField(
                    controller: newPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Sandi Baru',
                    ),
                    obscureText: true,
                  ),
                ],
              ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.pink),
              ),
              onPressed: () {
                updateData(context);
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
