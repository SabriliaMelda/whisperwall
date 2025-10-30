import 'package:flutter/material.dart';
import 'package:whisperwall/pages/beranda.dart'; // Import Beranda
import 'package:intl/intl.dart'; // Untuk format waktu
import 'package:supabase_flutter/supabase_flutter.dart';

class CurhatPages extends StatelessWidget {
  final dynamic userData;

  final String supabaseUrl = 'https://gqufqkpovhxfoutlpzeu.supabase.co';
  final String supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdxdWZxa3Bvdmh4Zm91dGxwemV1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUzNjk2MDcsImV4cCI6MjA1MDk0NTYwN30.yFvdOB_T1TU6PhI19hmOQZ-u6_CsA2-XTYRHfGD7GiM';

  CurhatPages(
      {required this.userData}); // Menandai userData sebagai parameter wajib

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Curhat',
              style: TextStyle(
                color: Color.fromARGB(255, 1, 4, 96),
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Text(
              'Selamat datang, ${userData['nama']}!',
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
                    builder: (context) => Beranda(userData: userData),
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
          future: fetchCurhat(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Terjadi kesalahan: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Tidak ada data ditemukan'));
            }

            final curhatList = snapshot.data!;

            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: curhatList.length,
              itemBuilder: (context, index) {
                final curhat = curhatList[index];
                return _buildCurhatContainer(context, curhat);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildCurhatContainer(
      BuildContext context, Map<String, dynamic> curhat) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/default.jpeg',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      curhat['nama'] ?? 'Nama tidak tersedia',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 1, 4, 96),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      curhat['fandom'] ?? 'Fandom tidak tersedia',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      curhat['motto'] ?? 'Motto tidak tersedia',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price: Rp10,000/Jam',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 1, 4, 96),
                ),
              ),
              ElevatedButton(
                onPressed: () => _showBookingForm(context, curhat),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 1, 4, 96),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Booking',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showBookingForm(BuildContext context, Map<String, dynamic> curhat) {
    final String idCurhat = curhat['id'].toString();
    final String namaAdmin = curhat['nama'];
    final TextEditingController durasiController =
        TextEditingController(text: "1");

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            int durasi = int.tryParse(durasiController.text) ?? 1;
            int hargaTotal = durasi * 10000;

            return AlertDialog(
              title: Text('Form Booking'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: TextEditingController(text: userData['nama']),
                    readOnly: true,
                    decoration: InputDecoration(labelText: 'Nama Anda'),
                  ),
                  TextField(
                    controller: TextEditingController(text: namaAdmin),
                    readOnly: true,
                    decoration: InputDecoration(labelText: 'Nama Admin'),
                  ),
                  TextField(
                    controller: durasiController,
                    decoration: InputDecoration(labelText: 'Durasi (Jam)'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        durasi = int.tryParse(value) ?? 1;
                        hargaTotal = durasi * 10000;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Harga Total: Rp$hargaTotal',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => _bookCurhat(
                    context,
                    userData['id'].toString(),
                    idCurhat,
                    durasi,
                    hargaTotal.toString(),
                  ),
                  child: Text('Pesan'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Batal'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _bookCurhat(BuildContext context, String idUser, String idCurhat,
      int durasi, String harga) async {
    try {
      final client = SupabaseClient(supabaseUrl, supabaseKey);
      final waktuSekarang =
          DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

      await client.from('booking').insert({
        'id_user': int.parse(idUser),
        'id_curhat': int.parse(idCurhat),
        'durasi': durasi,
        'harga': harga,
        'waktu': waktuSekarang,
      });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Booking berhasil! Silakan cek riwayat untuk melihat detail.')),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  Future<List<Map<String, dynamic>>> fetchCurhat() async {
    try {
      final client = SupabaseClient(supabaseUrl, supabaseKey);
      final response = await client
          .from('curhat')
          .select('id, nama, fandom, motto') as List<dynamic>;

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw 'Terjadi kesalahan: $e';
    }
  }
}
