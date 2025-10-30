import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whisperwall/pages/login_pages.dart';
import 'package:whisperwall/pages/welcome_pages.dart';
import 'package:whisperwall/shared/shared.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isHiddenPassword = true;
  bool _isHiddenConfirmPassword = true;

  final _nameTextboxController = TextEditingController();
  final _birthdateTextboxController = TextEditingController();
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();
  final _confirmPasswordTextboxController = TextEditingController();

  String _emailError = '';
  String _passwordError = '';
  String _confirmPasswordError = '';
  String _birthdateError = '';

  final supabaseClient = SupabaseClient(
    'https://gqufqkpovhxfoutlpzeu.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdxdWZxa3Bvdmh4Zm91dGxwemV1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUzNjk2MDcsImV4cCI6MjA1MDk0NTYwN30.yFvdOB_T1TU6PhI19hmOQZ-u6_CsA2-XTYRHfGD7GiM',
  );

  @override
  void initState() {
    super.initState();
    _emailTextboxController.addListener(_validateEmail);
    _confirmPasswordTextboxController.addListener(_validatePasswordMatch);
    _passwordTextboxController.addListener(_validatePassword);
    _birthdateTextboxController.addListener(_validateBirthdate);
  }

  void _validateEmail() {
    setState(() {
      final email = _emailTextboxController.text.trim();
      if (email.isNotEmpty && !email.endsWith("@gmail.com")) {
        _emailError = "Email must include @gmail.com.";
      } else {
        _emailError = '';
      }
    });
  }

  void _validatePassword() {
    setState(() {
      final password = _passwordTextboxController.text.trim();
      if (password.isNotEmpty &&
          (password.length < 8 || !RegExp(r'\d').hasMatch(password))) {
        _passwordError =
            "Password must be at least 8 characters long and include numbers.";
      } else {
        _passwordError = '';
      }
    });
  }

  void _validatePasswordMatch() {
    setState(() {
      final password = _passwordTextboxController.text.trim();
      final confirmPassword = _confirmPasswordTextboxController.text.trim();
      if (confirmPassword.isNotEmpty && password != confirmPassword) {
        _confirmPasswordError = "Passwords do not match.";
      } else {
        _confirmPasswordError = '';
      }
    });
  }

  void _validateBirthdate() {
    setState(() {
      final birthdate = _birthdateTextboxController.text.trim();
      if (birthdate.isNotEmpty &&
          !RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(birthdate)) {
        _birthdateError = "Invalid date format. Use dd/mm/yyyy.";
      } else {
        _birthdateError = '';
      }
    });
  }

  @override
  void dispose() {
    _nameTextboxController.dispose();
    _birthdateTextboxController.dispose();
    _emailTextboxController.dispose();
    _passwordTextboxController.dispose();
    _confirmPasswordTextboxController.dispose();
    super.dispose();
  }

  void _registerUser() async {
    final name = _nameTextboxController.text.trim();
    final birthdate = _birthdateTextboxController.text.trim();
    final email = _emailTextboxController.text.trim();
    final password = _passwordTextboxController.text.trim();
    final confirmPassword = _confirmPasswordTextboxController.text.trim();

    // Clear previous errors
    setState(() {
      _emailError = '';
      _passwordError = '';
      _confirmPasswordError = '';
      _birthdateError = '';
    });

    // Validate fields
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nama wajib diisi!')),
      );
      return;
    }

    if (birthdate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tanggal lahir wajib diisi!')),
      );
      return;
    }

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email wajib diisi!')),
      );
      return;
    } else if (_emailError.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_emailError)),
      );
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kata sandi wajib diisi!')),
      );
      return;
    } else if (_passwordError.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_passwordError)),
      );
      return;
    }

    if (confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Konfirmasi kata sandi wajib diisi!')),
      );
      return;
    } else if (_confirmPasswordError.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_confirmPasswordError)),
      );
      return;
    }

    // Jika semua valid, daftarkan pengguna
    try {
      await supabaseClient.from('user').insert({
        'nama': name,
        'tanggal_lahir': birthdate,
        'email': email,
        'password': password,
        'profile_url':
            'default.jpeg', // Menambahkan profile_url dengan default value
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Sukses!'),
          content: Text('Registrasi berhasil! Silakan masuk.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan, silakan coba lagi!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/b.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListView(
              padding: EdgeInsets.symmetric(horizontal: defaultMargin),
              children: [
                Image.asset('assets/images/re.png', height: 400),
                SizedBox(height: 10),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome! Everyone Deserves to Be Heard.",
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                        Text(
                          "Create Your Account",
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
                SizedBox(height: 15),
                TextField(
                  controller: _nameTextboxController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Enter your full name",
                    labelText: "Name",
                    suffixIcon: Icon(Icons.person_outline),
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );

                    if (selectedDate != null) {
                      setState(() {
                        final formattedDate =
                            "${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}";
                        _birthdateTextboxController.text = formattedDate;
                      });
                    }
                  },
                  child: IgnorePointer(
                    child: TextField(
                      controller: _birthdateTextboxController,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "DD/MM/YYYY",
                        labelText: "Date of Birth",
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(Icons.calendar_today_outlined),
                        ),
                      ),
                    ),
                  ),
                ),
                if (_birthdateError.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      _birthdateError,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                SizedBox(height: 20),
                TextField(
                  controller: _emailTextboxController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "example@gmail.com",
                    labelText: "Email",
                    suffixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                if (_emailError.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      _emailError,
                      style: TextStyle(color: Colors.red, fontSize: 14),
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
                    hintText: "Enter your password",
                    labelText: "Password",
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          _isHiddenPassword = !_isHiddenPassword;
                        });
                      },
                      child: Icon(_isHiddenPassword
                          ? Icons.lock_outline
                          : Icons.lock_open_outlined),
                    ),
                  ),
                ),
                if (_passwordError.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      _passwordError,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                SizedBox(height: 20),
                TextField(
                  obscureText: _isHiddenConfirmPassword,
                  controller: _confirmPasswordTextboxController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Confirm your password",
                    labelText: "Confirm Password",
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          _isHiddenConfirmPassword = !_isHiddenConfirmPassword;
                        });
                      },
                      child: Icon(_isHiddenConfirmPassword
                          ? Icons.lock_outline
                          : Icons.lock_open_outlined),
                    ),
                    errorText: _confirmPasswordError.isNotEmpty
                        ? _confirmPasswordError
                        : null,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width - 40,
                  child: ElevatedButton(
                    onPressed: _registerUser,
                    child: Text(
                      'Register',
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
                      "Already have an account?",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
