import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whisperwall/pages/beranda.dart';
import 'package:whisperwall/pages/welcome_pages.dart';

class AccountPages extends StatefulWidget {
  final dynamic userData;

  AccountPages({required this.userData});

  @override
  _AccountPagesState createState() => _AccountPagesState();
}

class _AccountPagesState extends State<AccountPages> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;
  late TextEditingController _passwordController;

  bool _isPasswordVisible =
      false; // Variabel untuk kontrol visibilitas password

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userData['nama']);
    _emailController = TextEditingController(text: widget.userData['email']);
    _dobController =
        TextEditingController(text: widget.userData['tanggal_lahir']);
    _passwordController =
        TextEditingController(text: widget.userData['password']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    final supabase = SupabaseClient(
      'https://gqufqkpovhxfoutlpzeu.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdxdWZxa3Bvdmh4Zm91dGxwemV1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUzNjk2MDcsImV4cCI6MjA1MDk0NTYwN30.yFvdOB_T1TU6PhI19hmOQZ-u6_CsA2-XTYRHfGD7GiM',
    );

    if (_formKey.currentState!.validate()) {
      try {
        final response = await supabase.from('user').update({
          'nama': _nameController.text,
          'email': _emailController.text,
          'tanggal_lahir': _dobController.text,
          'password': _passwordController.text,
        }).eq('id', widget.userData['id']);

        if (response.error == null) {
          // Update local data
          setState(() {
            widget.userData['nama'] = _nameController.text;
            widget.userData['email'] = _emailController.text;
            widget.userData['tanggal_lahir'] = _dobController.text;
            widget.userData['password'] = _passwordController.text;
          });

          // Kembalikan data terbaru ke halaman sebelumnya
          Navigator.pop(context,
              widget.userData); // Kembalikan data yang sudah diperbarui
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Failed to update profile: ${response.error?.message}'),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Data Diperbarui Logout dulu untuk melihat perubahan')),
        );
      }
    }
  }

  Future<void> _logout() async {
    final supabase = Supabase.instance.client;

    // Logout pengguna dari Supabase
    await supabase.auth.signOut();

    // Navigasi ke WelcomePages dan hapus semua rute sebelumnya
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => WelcomePages()),
      (Route<dynamic> route) => false, // Menghapus semua rute sebelumnya
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Akun',
              style: TextStyle(
                color: Color.fromARGB(255, 1, 4, 96),
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Text(
              'Selamat datang, ${widget.userData['nama']}!',
              style: TextStyle(
                color: Color.fromARGB(255, 1, 4, 96),
                fontSize: 14.0,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.home,
                color: Color.fromARGB(255, 1, 4, 96),
                size: 30.0,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Beranda(userData: widget.userData),
                  ),
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bb.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  Center(
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: widget.userData['photo_url'] != null &&
                              widget.userData['photo_url'].isNotEmpty
                          ? NetworkImage(widget.userData['photo_url'])
                          : AssetImage('assets/images/default.jpeg')
                              as ImageProvider,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Nama
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nama',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Silakan masukkan nama Anda';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  // Email
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Silakan masukkan email Anda';
                      }
                      if (!RegExp(
                              r"^[a-zA-Z0-9._%+-]+@[a-zA0-9.-]+\.[a-zA-Z]{2,}$")
                          .hasMatch(value)) {
                        return 'Silakan masukkan email yang valid';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  // Tanggal Lahir
                  TextFormField(
                    controller: _dobController,
                    decoration: InputDecoration(
                      labelText: 'Tanggal Lahir',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Silakan masukkan tanggal lahir Anda';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  // Password
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Silakan masukkan password Anda';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  // Tombol
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _updateProfile, // Update profil
                        child: Text('Update Profile'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 1, 4, 96),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _logout, // Logout pengguna
                        child: Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
