import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicDetailPages extends StatefulWidget {
  final Map<String, dynamic> music;

  MusicDetailPages({required this.music});

  @override
  _MusicDetailPagesState createState() => _MusicDetailPagesState();
}

class _MusicDetailPagesState extends State<MusicDetailPages> {
  late AudioPlayer player;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
  }

  @override
  void dispose() {
    player.dispose(); // Pastikan untuk membersihkan player saat halaman ditutup
    super.dispose();
  }

  Future<void> _playPauseMusic() async {
    final audioUrl = widget.music['audio_url'];

    if (isPlaying) {
      await player.pause(); // Pause musik jika sedang diputar
    } else {
      if (audioUrl != null && audioUrl.isNotEmpty) {
        await player
            .play(UrlSource(audioUrl)); // Memutar audio jika belum diputar
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('URL audio tidak ditemukan')),
        );
      }
    }

    setState(() {
      isPlaying = !isPlaying; // Toggle status pemutaran
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Musik',
          style: TextStyle(
            color: Color.fromARGB(255, 1, 4, 96),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bb.jpeg'), // Background image
            fit: BoxFit.cover, // Mengatur agar gambar mengisi layar
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .center, // Menjaga agar elemen tetap di tengah
              children: [
                // Menampilkan foto musik
                widget.music['foto'] != null && widget.music['foto'].isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          widget.music['foto'], // Foto musik
                          width: double.infinity,
                          height: 150,
                        ),
                      )
                    : Container(),
                SizedBox(height: 16),

                // Judul Musik
                Center(
                  child: Text(
                    widget.music['judul'] ?? 'Judul tidak tersedia',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 1, 4, 96),
                    ),
                  ),
                ),
                SizedBox(height: 8),

                // Kata atau Keterangan (Dengan gaya miring)
                Center(
                  child: Text(
                    widget.music['kata'] ?? 'Kata tidak tersedia',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontStyle:
                          FontStyle.italic, // Menambahkan miring pada teks
                    ),
                    textAlign: TextAlign.center, // Menyelaraskan teks di tengah
                  ),
                ),
                SizedBox(height: 20),

                // Tombol Putar/Pause Musik
                Center(
                  child: ElevatedButton(
                    onPressed: _playPauseMusic,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 1, 4, 96),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      isPlaying ? 'Pause Music' : 'Play Music',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Deskripsi Musik
                Center(
                  child: Text(
                    widget.music['deskripsi'] ?? 'Deskripsi tidak tersedia',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center, // Menyelaraskan teks di tengah
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
