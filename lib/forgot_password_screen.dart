import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSend() {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, insira seu e-mail.';
      });
      return;
    }

    // Aqui você pode integrar Firebase Auth para envio de e-mail
    // Exemplo:
    // await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Instruções enviadas para $email')),
    );

    Navigator.pop(context); // Volta para a tela de login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Esqueci minha senha'),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    'Esqueci minha senha',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Insira seu e-mail para receber as instruções de recuperação de senha.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      labelStyle: const TextStyle(color: Colors.white),
                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                      errorText: _errorMessage,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _handleSend,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    child: const Text('Enviar', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 100),
                  Image.asset(
                    'assets/logo.png',
                    height: 100,
                    width: 200,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text(
                        'FITMACRO',
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
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
