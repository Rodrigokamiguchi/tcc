import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _userData; // Armazena os dados do usuário

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _userData = null;
    });

    final db = FirebaseFirestore.instance;
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final docSnapshot = await db.collection('users').doc(email).get();

      if (docSnapshot.exists) {
        final userData = docSnapshot.data()!;
        if (userData['senha'] == password) {
          setState(() {
            _userData = userData;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Bem-vindo, ${userData['nome']}!')),
          );

          // Aqui você pode navegar para outra tela e passar os dados do usuário
        } else {
          setState(() {
            _errorMessage = 'E-mail ou senha incorretos.';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'E-mail não encontrado.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao fazer login: $e';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 150),
                    _buildTextField(_emailController, 'E-mail', false),
                    const SizedBox(height: 20),
                    _buildTextField(_passwordController, 'Senha', true),
                    const SizedBox(height: 10),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.redAccent, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/register'),
                          child: const Text('Crie sua conta', style: TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
                          child: const Text('Esqueci minha senha', style: TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          disabledBackgroundColor: Colors.red.withOpacity(0.5),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Log-in', style: TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Exibe dados do usuário após login
                    if (_userData != null)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nome: ${_userData!['nome']}', style: const TextStyle(color: Colors.white, fontSize: 16)),
                            Text('E-mail: ${_userData!['email']}', style: const TextStyle(color: Colors.white, fontSize: 16)),
                            // Adicione mais campos do Firestore se desejar
                          ],
                        ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, bool obscure) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Por favor, insira $hint.';
        if (!obscure && !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) return 'Por favor, insira um e-mail válido.';
        return null;
      },
    );
  }
}
