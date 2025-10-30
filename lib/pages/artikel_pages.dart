import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whisperwall/pages/beranda.dart'; // Import Beranda
import 'package:url_launcher/url_launcher.dart';

class ArtikelPages extends StatelessWidget {
  final dynamic userData;

  final String supabaseUrl = 'https://gqufqkpovhxfoutlpzeu.supabase.co';
  final String supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdxdWZxa3Bvdmh4Zm91dGxwemV1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUzNjk2MDcsImV4cCI6MjA1MDk0NTYwN30.yFvdOB_T1TU6PhI19hmOQZ-u6_CsA2-XTYRHfGD7GiM';

  ArtikelPages({required this.userData});

  final List<String> imagePaths = [
    'assets/images/ar1.jpg',
    'assets/images/ar2.jpeg',
    'assets/images/ar3.jpg',
    'assets/images/ar4.jpeg',
    'assets/images/ar5.jpg',
    'assets/images/ar6.jpg',
    'assets/images/ar7.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Artikel',
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
          future: fetchArticles(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Terjadi kesalahan: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Tidak ada artikel ditemukan'));
            }

            final articles = snapshot.data!;

            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                final imagePath = index < imagePaths.length
                    ? imagePaths[index]
                    : imagePaths[imagePaths.length -
                        1]; // Gambar default jika melebihi jumlah gambar
                return _buildArtikelContainer(context, article, imagePath);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildArtikelContainer(
      BuildContext context, Map<String, dynamic> article, String imagePath) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.asset(
              imagePath,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article['desk'] ?? 'Deskripsi tidak tersedia',
                  maxLines: 2, // Batasi ke 2 baris
                  overflow: TextOverflow
                      .ellipsis, // Tambahkan "..." jika teks terlalu panjang
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    final link = article['link'];
                    if (link != null && link.isNotEmpty) {
                      launchUrl(link);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Link artikel tidak tersedia')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 1, 4, 96),
                  ),
                  child: Text('Baca Selengkapnya'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchArticles() async {
    try {
      final client = SupabaseClient(supabaseUrl, supabaseKey);

      // Query ke tabel 'artikel'
      final response =
          await client.from('artikel').select('desk, link') as List<dynamic>;
      ;

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw 'Terjadi kesalahan: $e';
    }
  }

  void launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
