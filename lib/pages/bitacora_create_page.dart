import 'package:flutter/material.dart';
import '../models/create_bitacora_request.dart';
import '../services/bitacora_service.dart';

class BitacoraCreatePage extends StatefulWidget {
  const BitacoraCreatePage({Key? key}) : super(key: key);

  @override
  State<BitacoraCreatePage> createState() => _BitacoraCreatePageState();
}

class _BitacoraCreatePageState extends State<BitacoraCreatePage> {
  final usuarioController = TextEditingController();
  final descripcionController = TextEditingController();
  String errorMessage = '';
  String successMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar bitácora de prueba')),
      // FONDO LISO (sin degradado)
      body: Container(
        color: Colors.white, // o cualquier otro color
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
                children: [
                  if (errorMessage.isNotEmpty)
                    Container(
                      width: double.infinity,
                      color: Colors.red[100],
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  if (successMessage.isNotEmpty)
                    Container(
                      width: double.infinity,
                      color: Colors.green[100],
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        successMessage,
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),
                  TextField(
                    controller: usuarioController,
                    decoration: const InputDecoration(
                      labelText: 'ID Usuario',
                      prefixIcon: Icon(Icons.person),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descripcionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      prefixIcon: Icon(Icons.edit_note),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _createBitacora,
                    child: const Text('Crear Bitácora'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _createBitacora() async {
    final idUsuario = int.tryParse(usuarioController.text) ?? 0;
    final desc = descripcionController.text.trim();

    final request = CreateBitacoraRequest(idUsuario: idUsuario, descripcion: desc);

    try {
      final result = await BitacoraService.createBitacora(request);
      setState(() {
        successMessage = 'Bitácora creada con ID ${result.idBitacora} en fecha ${result.fechaBitacora}';
        errorMessage = '';
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        successMessage = '';
      });
    }
  }
}
