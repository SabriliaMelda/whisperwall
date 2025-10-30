import 'package:flutter/material.dart';
import 'package:whisperwall/pages/welcome_pages.dart';
import 'package:whisperwall/pages/register_pages.dart';
import 'package:whisperwall/pages/beranda.dart';
import 'package:whisperwall/shared/shared.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isHiddenPassword = true;
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();
  final SupabaseClient _supabaseClient = SupabaseClient(
      'https://gqufqkpovhxfoutlpzeu.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdxdWZxa3Bvdmh4Zm91dGxwemV1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUzNjk2MDcsImV4cCI6MjA1MDk0NTYwN30.yFvdOB_T1TU6PhI19hmOQZ-u6_CsA2-XTYRHfGD7GiM');

  void _togglePasswordView() {
    setState(() {
      _isHiddenPassword = !_isHiddenPassword;
    });
  }

  Future<void> _login() async {
    final email = _emailTextboxController.text.trim();
    final password = _passwordTextboxController.text;

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog("Email dan password tidak boleh kosong.");
      return;
    }

    try {
      // Mengambil data pengguna dari Supabase
      final response = await _supabaseClient
          .from('user')
          .select('*')
          .eq('email', email)
          .single();

      if (response['password'] == password) {
        // Kirim data pengguna ke Beranda setelah login berhasil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Beranda(
                userData: response), // Mengirim data pengguna ke Beranda
          ),
        );
      } else {
        _showErrorDialog(
            "Data tidak ditemukan, silakan lakukan registrasi terlebih dahulu.");
      }
    } catch (e) {
      _showErrorDialog("Terjadi kesalahan, silakan coba lagi.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bb.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: [
                Image.asset('assets/images/log.png', height: 400),
                SizedBox(height: 10),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome Back!",
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                        Text(
                          "Let's Get You Signed In",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    Spacer(),
                    Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WelcomePages()),
                          );
                        },
                        child: Icon(Icons.close, size: 30),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                TextField(
                  controller: _emailTextboxController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "example@gmail.com",
                    labelText: "email",
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  obscureText: _isHiddenPassword,
                  controller: _passwordTextboxController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "password",
                    labelText: "password",
                    suffixIcon: InkWell(
                      onTap: _togglePasswordView,
                      child: Icon(
                        _isHiddenPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width - 40,
                  child: ElevatedButton(
                    onPressed: _login,
                    child: Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(51, 122, 220, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()),
                        );
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
