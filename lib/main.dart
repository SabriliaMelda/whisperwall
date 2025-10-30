import 'package:flutter/material.dart';
import 'package:whisperwall/pages/welcome_pages.dart';
import 'package:whisperwall/shared/shared.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: "${dotenv.env['SUPABASE_URL']}",
    anonKey: "${dotenv.env['SUPABASE_ANON_KEY']}",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: ColorPallate.purpleColor,
        primaryColor: primaryColor,
        canvasColor: Colors.transparent,
      ),
      home: SplashScreen(), // Menambahkan SplashScreen di sini
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToWelcome();
  }

  // Fungsi untuk menunggu beberapa detik sebelum navigasi ke halaman utama
  void _navigateToWelcome() async {
    await Future.delayed(
        Duration(seconds: 3)); // Tampilkan splash selama 3 detik
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => WelcomePages()), // Ganti ke WelcomePages
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Image.asset('assets/images/w.png',
            height: 300), // Menampilkan logo 'w.png'
      ),
    );
  }
}
