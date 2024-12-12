import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:navegacao/Home/HomePage.dart';
import 'package:navegacao/database/DatabaseHelper.dart';
import 'dart:convert';

import 'package:navegacao/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controllers para os campos de entrada
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Variável para controle de erro na confirmação de senha
  String? _passwordError;

  // Função para validar a senha
  void _validatePassword() {
    setState(() {
      // Se as senhas não coincidirem, mostramos um erro
      if (_passwordController.text != _confirmPasswordController.text) {
        _passwordError = 'As senhas não coincidem';
      } else {
        _passwordError = null;
      }
    });
  }

  Future<void> addUser(String nome, String email, String senha) async {
    final url = Uri.parse(
        'http://127.0.0.1:5000/add_user'); // Substitua pelo IP do seu servidor
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nome': nome,
        'email': email,
        'senha': senha,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['message'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
      } else if (data['error'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['error'])),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao adicionar usuário')),
      );
    }
  }

  // Função para registrar o usuário
  Future<void> _registerUser() async {
    // Verificar se as senhas coincidem
    if (_passwordError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Corrija os erros antes de continuar.")),
      );
      return;
    }

    // Preparar os dados do usuário para envio
    final String nome = _nameController.text;
    final String email = _emailController.text;
    final String senha = _passwordController.text;
    print('$nome, $email, $senha \n');

    // Definir a URL do backend Flask
    try {
      // Enviar os dados para o backend
      int result =
          await DatabaseHelper.instance.registerUser(nome, email, senha);

      if (result != -1) {
        addUser(nome, email, senha);
        // Se a resposta for bem-sucedida, mostrar mensagem de sucesso
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString("email", email);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Inicio()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Cadastro realizado com sucesso!")),
        );
        // Voltar para a tela de login
        Navigator.pop(context);
      } else {
        // Se houver algum erro, mostrar mensagem de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar usuário')),
        );
      }
    } catch (error) {
      // Em caso de erro na requisição HTTP
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao tentar registrar: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Cadastro"),
        backgroundColor: Colors.grey[100],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_add_alt_1_outlined,
                  size: 100,
                ),
                SizedBox(height: 40),
                const Text(
                  'Crie sua conta',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
                ),
                SizedBox(height: 10),
                const Text(
                  'Preencha os campos abaixo',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 25),

                // Campo de Nome
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Nome',
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Campo de Email
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Campo de Senha
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Senha',
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Campo de Confirmar Senha
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        onChanged: (value) {
                          _validatePassword(); // Valida a senha ao digitar
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Confirmar Senha',
                          errorText: _passwordError, // Mostra o erro se houver
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Botão de Cadastro
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: _registerUser, // Chama a função para registrar
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Cadastrar',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Já tem uma conta? Login agora
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Já tem uma conta? ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Voltar para a tela de login
                      },
                      child: const Text(
                        'Login agora',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
