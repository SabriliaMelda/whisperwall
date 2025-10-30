import 'package:whisperwall/pages/beranda.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GejalaPages extends StatefulWidget {
  final dynamic userData; // Tambahkan parameter userData

  GejalaPages({required this.userData});

  @override
  _GejalaPagesState createState() => _GejalaPagesState();
}

class _GejalaPagesState extends State<GejalaPages> {
  final String supabaseUrl = 'https://gqufqkpovhxfoutlpzeu.supabase.co';
  final String supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdxdWZxa3Bvdmh4Zm91dGxwemV1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUzNjk2MDcsImV4cCI6MjA1MDk0NTYwN30.yFvdOB_T1TU6PhI19hmOQZ-u6_CsA2-XTYRHfGD7GiM';

  List<bool> isChecked = [];
  List<String> selectedDiagnoses = [];
  ScrollController _scrollController = ScrollController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Gejala Sementara',
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bb.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchDiagnosa(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Terjadi kesalahan: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Tidak ada diagnosa ditemukan'));
            }

            final diagnosaList = snapshot.data!;

            if (isChecked.length != diagnosaList.length) {
              isChecked = List.generate(diagnosaList.length, (index) => false);
            }

            return ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              itemCount: diagnosaList.length,
              itemBuilder: (context, index) {
                final diagnosa = diagnosaList[index];
                return _buildDiagnosaContainer(context, diagnosa, index);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildDiagnosaContainer(
      BuildContext context, Map<String, dynamic> diagnosa, int index) {
    return Container(
      key: ValueKey(index),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    diagnosa['deskripsi'] ?? 'Deskripsi tidak tersedia',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 1, 4, 96),
                    ),
                  ),
                ),
                Checkbox(
                  value: isChecked[index],
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked[index] = value!;
                      _updateSelectedDiagnoses(diagnosa, index);
                    });
                  },
                  activeColor: Color.fromARGB(255, 1, 4, 96),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            if (isChecked[index])
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Kategori: ${diagnosa['kategori'] ?? 'Tidak ada kategori'}',
                  style: TextStyle(
                      fontSize: 14, color: Color.fromARGB(255, 1, 4, 96)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _updateSelectedDiagnoses(Map<String, dynamic> diagnosa, int index) {
    if (isChecked[index]) {
      selectedDiagnoses
          .add(diagnosa['deskripsi'] ?? 'Deskripsi tidak tersedia');
    } else {
      selectedDiagnoses.remove(diagnosa['deskripsi']);
    }
  }

  Future<List<Map<String, dynamic>>> fetchDiagnosa() async {
    try {
      final client = SupabaseClient(supabaseUrl, supabaseKey);
      final response = await client
          .from('diagnosa')
          .select('deskripsi, kategori') as List<dynamic>;

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw 'Terjadi kesalahan: $e';
    }
  }
}
