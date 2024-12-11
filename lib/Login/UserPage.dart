import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginPage.dart';  // Importe a página de login, caso precise navegar de volta

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String _email = '';
  String _name = '';

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Carregar os dados do usuário assim que a página for carregada
  }

  // Função para carregar os dados do usuário (nome e email)
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString('email') ?? 'Email não encontrado';
      _name = prefs.getString('name') ?? 'Nome não encontrado';
    });
  }

  // Função para logout
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email'); // Remove o e-mail
    await prefs.remove('name');  // Remove o nome
    await prefs.remove('token'); // Remova também o token, caso esteja usando um

    // Exibir pop-up de sucesso
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Desconectado com sucesso'),
          content: Text('Você foi desconectado da sua conta.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página do Usuário'),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Exibir nome e e-mail do usuário
              Text(
                'Bem-vindo, $_name',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Email: $_email',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 40),
              // Botão de logout
              ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Cor vermelha para o botão de logout
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
