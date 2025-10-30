import 'package:flutter/material.dart';
import 'package:whisperwall/pages/beranda.dart'; // Import Beranda
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart'; // Import untuk meluncurkan URL

class RiwayatPages extends StatelessWidget {
  final dynamic userData;

  final String supabaseUrl = 'https://gqufqkpovhxfoutlpzeu.supabase.co';
  final String supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdxdWZxa3Bvdmh4Zm91dGxwemV1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUzNjk2MDcsImV4cCI6MjA1MDk0NTYwN30.yFvdOB_T1TU6PhI19hmOQZ-u6_CsA2-XTYRHfGD7GiM';

  RiwayatPages({required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Riwayat',
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
          future: fetchRiwayat(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Terjadi kesalahan: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Tidak ada riwayat ditemukan'));
            }

            final riwayatList = snapshot.data!;

            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: riwayatList.length,
              itemBuilder: (context, index) {
                final riwayat = riwayatList[index];
                return _buildRiwayatContainer(context, riwayat);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildRiwayatContainer(
      BuildContext context, Map<String, dynamic> riwayat) {
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
          Text(
            'Nama Admin: ${riwayat['curhat']['nama'] ?? 'Tidak tersedia'}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 1, 4, 96),
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Durasi: ${riwayat['durasi']} Jam',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Harga Total: Rp${riwayat['harga']}',
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Waktu: ${riwayat['waktu']}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          // Tombol untuk menampilkan popup
          ElevatedButton(
            onPressed: () => _showCetakBuktiPopup(context, riwayat),
            child: Text('Cetak Bukti'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 1, 4, 96),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchRiwayat() async {
    try {
      final client = SupabaseClient(supabaseUrl, supabaseKey);

      // Query untuk mengambil data booking dan relasi dengan curhat
      final response = await client
          .from('booking')
          .select('id, durasi, harga, waktu, curhat(nama)')
          .eq('id_user', userData['id']) as List<dynamic>;

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw 'Terjadi kesalahan: $e';
    }
  }

  void _showCetakBuktiPopup(
      BuildContext context, Map<String, dynamic> riwayat) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bukti Pembayaran'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Nama Admin: ${riwayat['curhat']['nama'] ?? 'Tidak tersedia'}'),
                Text('Durasi: ${riwayat['durasi']} Jam'),
                Text('Harga Total: Rp${riwayat['harga']}'),
                Text('Waktu: ${riwayat['waktu']}'),
                SizedBox(height: 10),
                Text(
                  'Untuk melakukan pembayaran, silakan hubungi admin melalui WhatsApp:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Nomor WhatsApp: +62xxxxxx (Admin)'),
                Text('Pesan: "SS untuk melakukan pembayaran"'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tutup'),
            ),
            TextButton(
              onPressed: () => _launchWhatsApp(),
              child: Text('Chat'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk membuka WhatsApp
  void _launchWhatsApp() async {
    final phoneNumber = '+62xxxxxx'; // Ganti dengan nomor WhatsApp yang sesuai
    final message = 'SS untuk melakukan pembayaran';
    final url =
        'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Tidak dapat membuka WhatsApp';
    }
  }
}
