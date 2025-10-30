import 'package:whisperwall/pages/beranda.dart';
import 'package:whisperwall/pages/detail_music_pages.dart';
import 'package:flutter/material.dart'; // Package untuk memutar audio
import 'package:supabase_flutter/supabase_flutter.dart';

class MusicPages extends StatelessWidget {
  final dynamic userData;
  final String supabaseUrl = 'https://gqufqkpovhxfoutlpzeu.supabase.co';
  final String supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdxdWZxa3Bvdmh4Zm91dGxwemV1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUzNjk2MDcsImV4cCI6MjA1MDk0NTYwN30.yFvdOB_T1TU6PhI19hmOQZ-u6_CsA2-XTYRHfGD7GiM';

  MusicPages({required this.userData}); // Parameter userData

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Music',
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
            image: AssetImage(
                'assets/images/bb.jpeg'), // Ganti dengan path gambar latar belakang Anda
            fit: BoxFit.cover, // Agar gambar mengisi seluruh area
          ),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchMusic(), // Mendapatkan data musik
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Terjadi kesalahan: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Tidak ada musik ditemukan'));
            }

            final musicList = snapshot.data!;

            return GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Menampilkan 2 kolom
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: musicList.length,
              itemBuilder: (context, index) {
                final music = musicList[index];
                return _buildMusicContainer(context, music);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildMusicContainer(
      BuildContext context, Map<String, dynamic> music) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman Detail Musik
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MusicDetailPages(music: music),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(8), // Mengurangi padding agar box lebih kecil
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7), // Background sedikit transparan
          borderRadius: BorderRadius.circular(8), // Membuat sudut lebih kecil
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 4, // Mengurangi blur radius
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menambahkan gambar album atau foto musik dengan ukuran yang lebih kecil
            music['foto'] != null && music['foto'].isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      music['foto'], // Menampilkan gambar dari URL
                      width: double.infinity,
                      height: 100, // Menyesuaikan ukuran kotak foto lebih kecil
                      // Menyesuaikan gambar dengan kotak
                    ),
                  )
                : Container(),
            SizedBox(height: 8),
            // Menampilkan judul musik dengan overflow handling
            Text(
              music['judul'] ?? 'Judul tidak tersedia',
              style: TextStyle(
                fontSize: 14, // Menyesuaikan ukuran font
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 1, 4, 96),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchMusic() async {
    try {
      final client = SupabaseClient(supabaseUrl, supabaseKey);
      final response = await client.from('music').select(
              'id, judul, kata, deskripsi, audio_url, foto') // Mengambil data musik yang dibutuhkan
          as List<dynamic>;

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw 'Terjadi kesalahan: $e';
    }
  }
}
