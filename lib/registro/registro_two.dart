import 'package:flutter/material.dart';
import 'seguimiento.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RegistroTwo extends StatefulWidget {
  final Map<String, dynamic>? datos;
  const RegistroTwo({super.key, this.datos});

  @override
  State<RegistroTwo> createState() => _RegistroTwoState();
}


class _RegistroTwoState extends State<RegistroTwo> {
  List<Map<String, dynamic>> _followUps = [];
  int _currentFollowUpIndex = -1; // -1 means base record, 0+ means follow-ups

  @override
  Widget build(BuildContext context) {
    // Determine which data to display (base or follow-up)
    Map<String, dynamic> currentData = _currentFollowUpIndex == -1
        ? widget.datos ?? {}
        : _followUps[_currentFollowUpIndex];

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/background.png', fit: BoxFit.cover),
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
                        'Registro de Datos',
                        style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  children: [
                  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        widget.datos?['nombrePaciente']?.toString() ?? 'Nombre no disponible',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF036666),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: GestureDetector(
                        onTap: () => _mostrarDialogo(context),
                        child: const Icon(Icons.visibility, color: Color(0xFF036666)),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Registro No. ${widget.datos?['numeroRegistro']?.toString() ?? '-'}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF036666),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Seguimiento',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
    Container(
    height: 200,
    decoration: BoxDecoration(
    color: const Color(0xFF248277).withOpacity(0.5),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: const Color(0xFF248277)),
    ),
    child: Center(
    child: Text(
    _currentFollowUpIndex == -1
    ? 'Registro Inicial'
        : 'Seguimiento ${_currentFollowUpIndex + 1}',
    style: TextStyle(
    fontStyle: FontStyle.italic,
    color: Color(0xFF036666),
    fontSize: 18,
    ),
    ),
    ),
    ),
    const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: _agregarNuevoRegistro,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF248277),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text(
                              'Agregar Registro',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 6),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _currentFollowUpIndex = -1;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _currentFollowUpIndex == -1
                                  ? const Color(0xFF036666)
                                  : const Color(0xFF248277),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('1', style: TextStyle(color: Colors.white)),
                          ),
                          ..._followUps.asMap().entries.map((entry) {
                            int index = entry.key;
                            return Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _currentFollowUpIndex = index;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _currentFollowUpIndex == index
                                      ? const Color(0xFF036666)
                                      : const Color(0xFF248277),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                    '${index + 2}',
                                    style: const TextStyle(color: Colors.white)),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildCard('Antropometría', [
                    _buildDato(currentData['pesoReal'] == true ? 'Peso Real' : 'Peso Estimado',
                        '${currentData['peso']?.toString() ?? 'No especificado'} Kg'),
                    _buildDato(currentData['tallaReal'] == true ? 'Talla Real' : 'Talla Estimada',
                        '${currentData['talla']?.toString() ?? 'No especificado'} Cm'),
                    _buildDato('Altura de Rodilla',
                        '${currentData['rodilla']?.toString() ?? 'No especificado'} Cm'),
                    _buildDato('CMB',
                        '${currentData['cmb']?.toString() ?? 'No especificado'} Cm'),
                  ]),
                  _buildCard('Diagnósticos', [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Diagnóstico Médico',
                                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
                              Text(currentData['diagnosticoMedico']?.toString() ?? 'No especificado',
                                  style: TextStyle(color: Colors.black54)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Diagnóstico Nutricional',
                                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
                              Text(currentData['diagnosticoNutricional']?.toString() ?? 'No especificado',
                                  style: TextStyle(color: Colors.black54)),
                            ],
                          ),
                        ),
                      ],
                    )
                  ]),
                  _buildCard('Laboratorios', [
                    if (currentData['laboratorios'] != null)
                      ..._buildLaboratorios(currentData['laboratorios'] as List<dynamic>)
                    else
                      const Text('No se ingresaron laboratorios',
                          style: TextStyle(color: Colors.grey)),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadFollowUps();
  }

  void _loadFollowUps() async {
    if (widget.datos == null || widget.datos!['numeroRegistro'] == null) return;

    final prefs = await SharedPreferences.getInstance();
    final String? pacientesString = prefs.getString('pacientes');

    if (pacientesString != null) {
      try {
        final pacientesList = jsonDecode(pacientesString) as List;
        final paciente = pacientesList.firstWhere(
              (p) => p['numeroRegistro'] == widget.datos!['numeroRegistro'],
          orElse: () => null,
        );

        if (paciente != null && paciente['seguimientos'] != null) {
          setState(() {
            _followUps = List<Map<String, dynamic>>.from(paciente['seguimientos']);
            print('${_followUps.length} seguimientos cargados');
          });
        }
      } catch (e) {
        print('Error cargando seguimientos: $e');
      }
    }
  }

  void _agregarNuevoRegistro() async {
    final newFollowUpData = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => SeguimientoScreen(initialData: widget.datos),
      ),
    );

    if (newFollowUpData != null) {
      setState(() {
        _followUps.add({
          ...newFollowUpData,
          'fecha': DateTime.now().toString(),
          'id_unico': DateTime.now().millisecondsSinceEpoch,
        });
        _currentFollowUpIndex = _followUps.length - 1;
      });

      // Guardar inmediatamente y verificar
      await _saveFollowUps();
      _verificarGuardado();
    }
  }

  void _verificarGuardado() async {
    final prefs = await SharedPreferences.getInstance();
    final pacientesString = prefs.getString('pacientes');

    if (pacientesString != null) {
      try {
        final pacientes = jsonDecode(pacientesString) as List;
        final paciente = pacientes.firstWhere(
              (p) => p['numeroRegistro'] == widget.datos!['numeroRegistro'],
          orElse: () => null,
        );

        if (paciente != null) {
          print('Verificación: ${paciente['seguimientos']?.length ?? 0} seguimientos guardados');
        }
      } catch (e) {
        print('Error verificando guardado: $e');
      }
    }
  }

  Future<void> _saveFollowUps() async {
    if (widget.datos == null || widget.datos!['numeroRegistro'] == null) return;

    final prefs = await SharedPreferences.getInstance();
    final pacientesString = prefs.getString('pacientes');
    List<dynamic> pacientesList = pacientesString != null ? jsonDecode(pacientesString) : [];

    // Crear copia profunda de los datos actuales
    final pacienteActualizado = {
      ...widget.datos!,
      'seguimientos': _followUps.map((f) => {...f}).toList(),
    };

    bool encontrado = false;
    for (int i = 0; i < pacientesList.length; i++) {
      if (pacientesList[i]['numeroRegistro'] == widget.datos!['numeroRegistro']) {
        pacientesList[i] = pacienteActualizado;
        encontrado = true;
        break;
      }
    }

    if (!encontrado) {
      pacientesList.add(pacienteActualizado);
    }

    await prefs.setString('pacientes', jsonEncode(pacientesList));
    print('Datos guardados: ${pacienteActualizado['seguimientos']?.length ?? 0} seguimientos');
  }

  void _mostrarDialogo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF248277), width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    widget.datos?['nombrePaciente']?.toString() ?? 'Nombre no disponible',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF036666),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _filaDoble('No. Registro', widget.datos?['numeroRegistro']?.toString(),
                          'No. Cama', widget.datos?['numeroCama']?.toString()),
                      const SizedBox(height: 8),
                      _filaDoble('F. Nacimiento', widget.datos?['fechaNacimiento']?.toString(),
                          'Edad', widget.datos?['edad']?.toString()),
                      const SizedBox(height: 8),
                      _filaSimple('Lugar de Origen', widget.datos?['origen']),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _filaDoble(String titulo1, dynamic valor1, String titulo2, dynamic valor2) {
    return Row(
      children: [
        Expanded(child: _datoTexto(titulo1, valor1)),
        const SizedBox(width: 12),
        Expanded(child: _datoTexto(titulo2, valor2)),
      ],
    );
  }

  Widget _filaSimple(String titulo, dynamic valor) {
    return _datoTexto(titulo, valor);
  }

  Widget _datoTexto(String titulo, dynamic valor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF036666))),
        Text(valor?.toString() ?? 'No disponible', style: const TextStyle(color: Colors.black87)),
      ],
    );
  }

  Widget _buildCard(String titulo, List<Widget> contenido) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF248277), width: 1),
      ),
      color: Colors.white.withOpacity(0.9),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                titulo,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF036666)),
              ),
            ),
            const SizedBox(height: 4),
            ...contenido,
          ],
        ),
      ),
    );
  }

  Widget _buildDato(String titulo, dynamic valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
                titulo,
                style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
          ),
          Expanded(
            flex: 3,
            child: Text(
                valor?.toString() ?? 'No especificado',
                style: const TextStyle(color: Colors.black54)),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildLaboratorios(List<dynamic> labs) {
    return labs.map((lab) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDato('Estudio', lab['estudio']),
          _buildDato('Referencia', lab['referencia']),
          _buildDato('Resultado', lab['resultado']),
          const Divider(thickness: 1),
        ],
      );
    }).toList();
  }
}
