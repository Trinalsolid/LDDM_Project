import "package:flutter/material.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:navegacao/database/DatabaseHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'Map/Mapa.dart';
import 'Login/LoginPage.dart';
import 'Login/UserPage.dart';
import 'News/noticias.dart';
import 'Home/HomePage.dart';
import 'gpt/chatScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Necessário para async no início

  await dotenv.load(fileName: 'assets/.env');

  // Verificar estado de login
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: isLoggedIn ? Inicio() : LoginPage(),
  ));
}

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int _indiceAtual = 0;
  late List<Widget> _telas;

  @override
  void initState() {
    super.initState();
    _telas = [
      HomePage(),
      ChatScreen(),
      Mapa(),
      UserPage(), // You'll need to modify LoginPage to work with DatabaseHelper
    ];
  }

  void onTabTapped(int index) {
    setState(() {
      _indiceAtual = index;
      print(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
      ),
      body: _telas[_indiceAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Início",
              backgroundColor: Colors.lightBlue),
          BottomNavigationBarItem(
              icon: Icon(Icons.assistant_rounded),
              label: "IA",
              backgroundColor: Colors.lightBlue),
          BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: "Sua Região",
              backgroundColor: Colors.lightBlue),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: "Perfil",
              backgroundColor: Colors.lightBlue),
        ],
      ),
    );
  }
}

class Home extends StatelessWidget {
  final String texto;

  Home(this.texto);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(texto),
      ),
    );
  }
}
