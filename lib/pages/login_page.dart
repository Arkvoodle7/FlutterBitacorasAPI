import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'bitacora_list_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Precargar (opcional)
    emailController.text = "richard.redondo.ramirez@cuc.cr";
    passwordController.text = "12345";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar con estilo
      appBar: AppBar(
        title: const Text('Login Bitácoras'),
        centerTitle: true,
        elevation: 4,
      ),
      body: Container(
        // Fondo con gradiente
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFE0F7FA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (errorMessage.isNotEmpty)
                      Container(
                        color: Colors.red[100],
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    const Text(
                      'Bienvenido',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _doLogin,
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _doLogin() async {
    final email = emailController.text.trim();
    final pass = passwordController.text.trim();

    final success = await AuthService.login(email, pass);

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BitacoraListPage()),
      );
    } else {
      setState(() {
        errorMessage = 'Usuario y/o contraseña incorrectos';
      });
    }
  }
}
