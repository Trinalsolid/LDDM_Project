// RegisterPage.dart
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controllers para os campos de entrada
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Mantendo a mesma cor de fundo da LoginPage
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
                    onTap: () {
                      // Validação simples: verificar se as senhas coincidem
                      if (_passwordError == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Cadastro realizado com sucesso!")),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Corrija os erros antes de continuar.")),
                        );
                      }
                    },
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
                        // Voltar para a página de login
                        Navigator.pop(context); // Volta para a tela anterior
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
