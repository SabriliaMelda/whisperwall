import 'package:whisperwall/pages/login_pages.dart';
import 'package:flutter/material.dart';
import 'package:whisperwall/pages/gejala_pages.dart';
import 'package:whisperwall/pages/music_pages.dart';
import 'package:whisperwall/pages/about_pages.dart';
import 'package:whisperwall/pages/artikel_pages.dart';
import 'package:whisperwall/pages/catatan_pages.dart';
import 'package:whisperwall/pages/penanganan_pages.dart';
import 'package:whisperwall/pages/riwayat_pages.dart';
import 'package:whisperwall/pages/curhat_pages.dart';
import 'package:whisperwall/pages/account_pages.dart';

class Beranda extends StatelessWidget {
  final dynamic userData;

  Beranda({required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Whisper Wall',
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
                Icons.logout,
                color: Color.fromARGB(255, 1, 4, 96),
                size: 30.0,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bbb.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AccountPages(userData: userData),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: userData['photo_url'] != null &&
                                      userData['photo_url'].isNotEmpty
                                  ? NetworkImage(userData['photo_url'])
                                  : AssetImage('assets/images/default.jpeg')
                                      as ImageProvider,
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userData['nama'] ?? 'Nama Tidak Tersedia',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 1, 4, 96),
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    userData['email'] ?? 'Email Tidak Tersedia',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 1, 4, 96),
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Kamu di ciptakan untuk menjadi nyata, bukan menjadi sempurna!',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Color.fromARGB(255, 1, 4, 96),
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Menggunakan GridView untuk ikon
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // Mengatur jumlah kolom
                    crossAxisSpacing: 20, // Spasi horizontal antar ikon
                    mainAxisSpacing: 30, // Spasi vertikal antar ikon
                  ),
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    List<Map<String, dynamic>> menuItems = [
                      {
                        'icon': Icons.article,
                        'title': 'Artikel',
                        'route': '/artikel'
                      },
                      {
                        'icon': Icons.chat,
                        'title': 'Curhat',
                        'route': '/sesicurhat'
                      },
                      {
                        'icon': Icons.history,
                        'title': 'Riwayat',
                        'route': '/riwayat'
                      },
                      {
                        'icon': Icons.health_and_safety,
                        'title': 'Gejala',
                        'route': '/gejala'
                      },
                      {
                        'icon': Icons.medical_services,
                        'title': 'Penanganan',
                        'route': '/cara'
                      },
                      {
                        'icon': Icons.music_note,
                        'title': 'Music',
                        'route': '/music'
                      },
                      {
                        'icon': Icons.notes,
                        'title': 'Catatan',
                        'route': '/catatan'
                      },
                      {'icon': Icons.info, 'title': 'About', 'route': '/about'},
                    ];

                    return _buildIconInCircle(
                      context,
                      menuItems[index]['icon'],
                      menuItems[index]['title'],
                      menuItems[index]['route'],
                    );
                  },
                ),
                SizedBox(height: 15),

                // Jarak antara baris pertama dan kedua ikon
                SizedBox(height: 35),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 20),
                    Text(
                      'Kata-Kata Hari Ini',
                      style: TextStyle(
                        color: Color.fromARGB(255, 1, 4, 96),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: List.generate(10, (index) {
                      List<String> motivasi = [
                        'Jangan takut untuk memulai sesuatu yang baru.',
                        'Setiap langkah kecil membawa kita lebih dekat ke tujuan kita.',
                        'Keberhasilan adalah hasil dari ketekunan dan kerja keras.',
                        'Kegagalan adalah kesempatan untuk memulai lagi dengan lebih bijaksana.',
                        'Kamu lebih kuat dari yang kamu kira.',
                        'Berpikir positif membuka pintu untuk peluang baru.',
                        'Hidup adalah perjalanan, nikmati setiap momennya.',
                        'Kamu bisa melakukan lebih dari yang kamu bayangkan.',
                        'Bersyukurlah atas setiap hari yang diberikan.',
                        'Setiap hari adalah kesempatan untuk tumbuh dan berkembang.'
                      ];

                      return Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              motivasi[index],
                              style: TextStyle(
                                color: Color.fromARGB(255, 1, 4, 96),
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconInCircle(
      BuildContext context, IconData icon, String title, String route) {
    return GestureDetector(
      onTap: () {
        switch (route) {
          case '/artikel':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArtikelPages(userData: userData),
              ),
            );
            break;
          case '/sesicurhat':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CurhatPages(userData: userData),
              ),
            );
            break;
          case '/riwayat':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RiwayatPages(userData: userData),
              ),
            );
            break;
          case '/gejala':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GejalaPages(userData: userData),
              ),
            );
            break;
          case '/cara':
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PenangananPages(userData: userData)),
            );
            break;
          case '/music':
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MusicPages(userData: userData)),
            );
            break;
          case '/catatan':
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CatatanPages(userData: userData)),
            );
            break;
          case '/about':
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AboutPages(userData: userData)),
            );
            break;
        }
      },
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 254, 254, 255),
            ),
            child: Icon(
              icon,
              color: Color.fromARGB(255, 1, 4, 96),
              size: 40,
            ),
          ),
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              color: Color.fromARGB(255, 1, 4, 96),
              fontSize: 12, // Menyesuaikan ukuran font di bawah ikon
            ),
          ),
        ],
      ),
    );
  }
}
