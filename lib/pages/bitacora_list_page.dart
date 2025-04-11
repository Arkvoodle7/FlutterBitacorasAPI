import 'package:flutter/material.dart';
import '../services/bitacora_service.dart';
import '../models/bitacora_dto.dart';
import 'bitacora_create_page.dart';

class BitacoraListPage extends StatefulWidget {
  const BitacoraListPage({Key? key}) : super(key: key);

  @override
  State<BitacoraListPage> createState() => _BitacoraListPageState();
}

class _BitacoraListPageState extends State<BitacoraListPage> {
  List<BitacoraDto> bitacoras = [];
  final usuarioController = TextEditingController();
  DateTime? selectedDate;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Fecha inicial "hoy"
    selectedDate = DateTime.now();
    _applyFilters();
  }

  Future<void> _applyFilters() async {
    try {
      int? usuario = usuarioController.text.isNotEmpty
          ? int.parse(usuarioController.text)
          : null;

      final result = await BitacoraService.getBitacorasFiltered(usuario, selectedDate);
      setState(() {
        bitacoras = result;
        errorMessage = '';
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _clearDate() {
    setState(() {
      selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateString = selectedDate == null
        ? 'No seleccionado'
        : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultar bitácoras'),
        centerTitle: true,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BitacoraCreatePage()),
              );
              _applyFilters(); // al volver, se mantienen los filtros
            },
          ),
        ],
      ),
      // FONDO DEGRADADO
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFEDE7F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            if (errorMessage.isNotEmpty)
              Container(
                width: double.infinity,
                color: Colors.red[100],
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            // Card con los filtros
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      // Campo de usuario
                      TextField(
                        controller: usuarioController,
                        decoration: const InputDecoration(
                          labelText: 'Usuario (ID)',
                          prefixIcon: Icon(Icons.person),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),

                      // Sección de fecha y filtro
                      Row(
                        // ANCLA LA FECHA A LA IZQUIERDA
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Texto clickable de la fecha
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.date_range),
                                const SizedBox(width: 6),
                                Text('Fecha: $dateString'),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: _clearDate,
                          ),
                          const Spacer(),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.search),
                            label: const Text('Filtrar'),
                            onPressed: _applyFilters,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Lista de bitácoras
            Expanded(
              child: ListView.builder(
                itemCount: bitacoras.length,
                itemBuilder: (context, index) {
                  final b = bitacoras[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Card(
                      elevation: 2,
                      child: ListTile(
                        leading: const Icon(Icons.bookmark),
                        title: Text(
                          'Usuario: ${b.idUsuario}, Desc: ${b.descripcion}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Fecha: ${b.fechaBitacora}'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}