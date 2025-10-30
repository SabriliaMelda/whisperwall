import 'package:whisperwall/pages/beranda.dart';
import 'package:flutter/material.dart';

class AboutPages extends StatefulWidget {
  final dynamic userData; // Menerima userData sebagai parameter

  AboutPages(
      {required this.userData}); // Menambahkan constructor untuk userData

  @override
  _AboutPagesState createState() => _AboutPagesState();
}

class _AboutPagesState extends State<AboutPages> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'About Us',
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
        child: Column(
          children: [
            SizedBox(height: 10),
            Container(
              height: 200,
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  Image.asset('assets/images/L.jpeg'),
                  Image.asset('assets/images/BL.jpeg'),
                  Image.asset('assets/images/exo.png'),
                ],
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    if (_currentPage > 0) {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    if (_currentPage < 2) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  Text(
                    'Company Profile',
                    style: TextStyle(
                      color: Color.fromARGB(
                          255, 1, 4, 96), // Mengubah warna menjadi biru
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Whisper Wall adalah sebuah aplikasi yang menyediakan layanan curhat untuk mereka yang sedang mencari tempat untuk didengarkan, berbagi cerita, atau bahkan sekadar melepaskan perasaan. Kami hadir untuk memberikan ruang aman bagi setiap individu untuk mengungkapkan perasaan dan beban emosional mereka tanpa takut dihakimi.\n\nKami percaya bahwa berbicara dan mendengarkan adalah cara yang efektif untuk meredakan stres dan meningkatkan kesejahteraan mental. Dengan Whisper Wall, Anda dapat merasa didukung, dihargai, dan didengarkan. Aplikasi ini memberikan kesempatan untuk berbagi cerita dengan orang yang mungkin bisa memberikan perspektif yang berbeda dan membantu Anda merasa lebih baik.\n\nSebagai bagian dari komunitas ini, kami berharap Whisper Wall dapat menjadi tempat yang nyaman dan aman bagi siapa saja yang membutuhkan dukungan emosional dan mental.\n\nWhisper Wall adalah tempat Anda bisa berbicara tanpa rasa takut atau cemas, dan kami siap mendengarkan setiap cerita Anda.',
                    style: TextStyle(
                      color: Color.fromARGB(255, 1, 4, 96),
                      fontSize: 18.0,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 36),
                  Text('All Right Reserved @2025 \nArliven',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(255, 1, 4, 96),
                        fontSize: 11,
                      )),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
