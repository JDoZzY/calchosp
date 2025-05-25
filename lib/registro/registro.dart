import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'registro_two.dart';

class Registro extends StatefulWidget {
  final Map<String, dynamic>? datos;

  const Registro({super.key, this.datos});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  List<Map<String, dynamic>> listaPacientes = [];

  @override
  void initState() {
    super.initState();
    _cargarPacientes();
  }

  Future<void> _cargarPacientes() async {
    final prefs = await SharedPreferences.getInstance();
    final pacientesJson = prefs.getStringList('pacientes') ?? [];

    setState(() {
      listaPacientes = pacientesJson.map((json) {
        try {
          return Map<String, dynamic>.from(jsonDecode(json));
        } catch (e) {
          return <String, dynamic>{};
        }
      }).toList();
    });
  }

  Future<void> cargarPacientes() async {
    final prefs = await SharedPreferences.getInstance();
    final listaJson = prefs.getStringList('pacientes') ?? [];
    setState(() {
      listaPacientes = listaJson.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
    });
  }

  Future<void> agregarPaciente(Map<String, dynamic> nuevoPaciente) async {
    final prefs = await SharedPreferences.getInstance();

    listaPacientes.add(nuevoPaciente);
    final listaJson = listaPacientes.map((e) => jsonEncode(e)).toList();

    await prefs.setStringList('pacientes', listaJson);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Container(height: MediaQuery.of(context).padding.top, color: const Color(0xFF036666)),
              Container(
                height: 60,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF248277), Color(0xFF036666)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 4,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Base de Datos',
                        style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: listaPacientes.length,
                  itemBuilder: (context, index) {
                    final datos = listaPacientes[index];
                    return Dismissible(
                      key: Key(datos['numeroRegistro'] ?? UniqueKey().toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white, size: 30),
                      ),
                      onDismissed: (direction) async {
                        // Remover el item de la lista
                        setState(() {
                          listaPacientes.removeAt(index);
                        });

                        // Actualizar SharedPreferences
                        final prefs = await SharedPreferences.getInstance();
                        final listaJson = listaPacientes.map((e) => jsonEncode(e)).toList();
                        await prefs.setStringList('pacientes', listaJson);

                        // Mostrar snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Paciente ${datos['nombrePaciente']} eliminado'),
                            action: SnackBarAction(
                              label: 'Deshacer',
                              onPressed: () async {
                                // Reinsertar el item
                                setState(() {
                                  listaPacientes.insert(index, datos);
                                });

                                // Actualizar SharedPreferences
                                final listaJson = listaPacientes.map((e) => jsonEncode(e)).toList();
                                await prefs.setStringList('pacientes', listaJson);
                              },
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF248277), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            datos['nombrePaciente'] ?? 'Sin nombre',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('No. de Registro: ${datos['numeroRegistro'] ?? 'No especificado'}'),
                          trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF248277)),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RegistroTwo(datos: datos),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
