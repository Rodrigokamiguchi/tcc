import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicializa o Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cadastro FITMACRO',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const RegistrationScreen(),
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _handleRegistration() async {
    final nome = _nomeController.text.trim();
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    final db = FirebaseFirestore.instance;

    try {
      await db.collection('users').doc(email).set({
        'nome': nome,
        'email': email,
        'senha': senha,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
        centerTitle: true,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/tela_fundo.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.black,
                child: const Center(
                  child: Text(
                    "Erro ao carregar a imagem de fundo",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
          Container(color: Colors.black.withOpacity(0.6)),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    'Criar uma nova conta',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome Completo',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder:
                          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      focusedBorder:
                          UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder:
                          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      focusedBorder:
                          UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                  ),
                  TextField(
                    controller: _senhaController,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder:
                          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      focusedBorder:
                          UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                    ),
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _handleRegistration,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    child: const Text('Cadastrar', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 50),
                  Image.asset(
                    'assets/logo.png',
                    height: 100,
                    width: 200,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text(
                        'FITMACRO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
