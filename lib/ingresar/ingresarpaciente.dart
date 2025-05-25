import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hospcalc/ingresar/widgets/calendario_widget.dart';
import 'package:hospcalc/ingresar/widgets/input_widgets.dart';
import 'package:hospcalc/ingresar/widgets/servicio_widget.dart';
import 'package:intl/intl.dart';
import '../registro/registro.dart';
import 'date_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'laboratorios_section.dart';

class IngresarPacientes extends StatefulWidget {
  const IngresarPacientes({super.key});

  @override
  State<IngresarPacientes> createState() => _IngresarPacientesState();
}

class _IngresarPacientesState extends State<IngresarPacientes> {
  bool? pesoReal;
  bool? tallaReal;

  final TextEditingController fechaController = TextEditingController();
  final TextEditingController edadController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController tallaController = TextEditingController();
  final TextEditingController rodillaController = TextEditingController();
  final TextEditingController cmbController = TextEditingController();
  final TextEditingController servicioController = TextEditingController();
  final TextEditingController camaController = TextEditingController();
  final TextEditingController registroController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController origenController = TextEditingController();
  final TextEditingController diagnosticoNutriController = TextEditingController();
  final TextEditingController diagnosticoMedicoController = TextEditingController();

  final List<Map<String, TextEditingController>> camposLaboratorios = [
    {
      'estudio': TextEditingController(),
      'referencia': TextEditingController(),
      'resultado': TextEditingController(),
    },
  ];

  final ScrollController _scrollController = ScrollController();

  String _calcularEdad(DateTime fechaNacimiento) {
    final hoy = DateTime.now();
    int anios = hoy.year - fechaNacimiento.year;
    int meses = hoy.month - fechaNacimiento.month;
    int dias = hoy.day - fechaNacimiento.day;
    if (meses < 0 || (meses == 0 && dias < 0)) anios--;
    if (meses < 0) meses += 12;
    if (dias < 0) {
      final ultimoDiaMesAnterior = DateTime(hoy.year, hoy.month - 1, 0).day;
      dias = ultimoDiaMesAnterior - fechaNacimiento.day + hoy.day;
      meses--;
    }
    return '${anios}a ${meses}m';
  }

  void _closeKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _mostrarSnackBarGuardado() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Consulta guardada correctamente'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _guardarConsulta() async {
    _closeKeyboard();

    final laboratorios = camposLaboratorios.map((mapa) {
      return {
        'estudio': mapa['estudio']!.text,
        'referencia': mapa['referencia']!.text,
        'resultado': mapa['resultado']!.text,
      };
    }).toList();

    final datosPaciente = {
      'numeroCama': camaController.text,
      'numeroRegistro': registroController.text,
      'servicio': servicioController.text,
      'nombrePaciente': nombreController.text,
      'fechaNacimiento': fechaController.text,
      'edad': edadController.text,
      'peso': pesoController.text,
      'pesoReal': pesoReal,
      'talla': tallaController.text,
      'tallaReal': tallaReal,
      'rodilla': rodillaController.text,
      'cmb': cmbController.text,
      'origen': origenController.text,
      'diagnosticoNutricional': diagnosticoNutriController.text,
      'diagnosticoMedico': diagnosticoMedicoController.text,
      'laboratorios': laboratorios,
    };

    // Guardar en SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    List<String> pacientes = prefs.getStringList('pacientes') ?? [];
    pacientes.add(jsonEncode(datosPaciente));
    await prefs.setStringList('pacientes', pacientes);

    // Limpiar campos
    _limpiarCampos();

    _mostrarSnackBarGuardado();
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _limpiarCampos() {
    camaController.clear();
    registroController.clear();
    servicioController.clear();
    nombreController.clear();
    fechaController.clear();
    edadController.clear();
    pesoController.clear();
    tallaController.clear();
    rodillaController.clear();
    cmbController.clear();
    origenController.clear();
    diagnosticoNutriController.clear();
    diagnosticoMedicoController.clear();

    for (var lab in camposLaboratorios) {
      lab['resultado']?.clear();
    }

    setState(() {
      pesoReal = null;
      tallaReal = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _cargarDatosLaboratorio();
  }

  void _guardarDatosLaboratorio() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, String>> datos = camposLaboratorios.map((mapa) {
      return {
        'estudio': mapa['estudio']!.text,
        'referencia': mapa['referencia']!.text,
      };
    }).toList();
    await prefs.setString('lab_datos', jsonEncode(datos));
  }

  void _cargarDatosLaboratorio() async {
    final prefs = await SharedPreferences.getInstance();
    final datosGuardados = prefs.getString('lab_datos');
    if (datosGuardados != null) {
      final datos = jsonDecode(datosGuardados) as List;
      camposLaboratorios.clear();
      for (var elemento in datos) {
        camposLaboratorios.add({
          'estudio': TextEditingController(text: elemento['estudio']),
          'referencia': TextEditingController(text: elemento['referencia']),
          'resultado': TextEditingController(text: ''),
        });
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _closeKeyboard,
        child: Stack(
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
                          'Ingresar Paciente',
                          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Positioned(
                        right: 4,
                        child: IconButton(
                          icon: const Icon(Icons.folder, color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Registro()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Datos Personales',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: const [
                            Expanded(child: Text('Número de Cama')),
                            SizedBox(width: 16),
                            Expanded(child: Text('No. de Registro')),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: camaController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.hotel, color: Colors.teal),
                                  contentPadding: EdgeInsets.all(8),
                                  filled: true,
                                  fillColor: Colors.white.withAlpha(200),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF248277)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: registroController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.numbers, color: Colors.teal),
                                  contentPadding: EdgeInsets.all(8),
                                  filled: true,
                                  fillColor: Colors.white.withAlpha(200),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF248277)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text('Servicio'),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () async {
                            final seleccion = await mostrarSelectorServicio(context, servicioController.text);
                            if (seleccion != null) {
                              setState(() {
                                servicioController.text = seleccion;
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: InputWidgets.buildInputFieldCustom(servicioController, Icons.local_hospital),
                          ),
                        ),

                        const SizedBox(height: 8),
                        const Text('Nombre del Paciente'),
                        const SizedBox(height: 4),
                        InputWidgets.buildInputField(nombreController, Icons.person),

                        const SizedBox(height: 8),
                        const Text('Peso (Kg)'),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            SizedBox(
                              width: 140,
                              child: InputWidgets.buildNumericInput(pesoController, Icons.monitor_weight),
                            ),
                            const SizedBox(width: 8),
                            InputWidgets.buildRadioSelector(
                              context: context,
                              tipo: 'peso',
                              groupValue: pesoReal,
                              onChanged: (value) => setState(() => pesoReal = value),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),
                        const Text('Talla (Cm)'),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            SizedBox(
                              width: 140,
                              child: InputWidgets.buildNumericInput(tallaController, Icons.height),
                            ),
                            const SizedBox(width: 8),
                            InputWidgets.buildRadioSelector(
                              context: context,
                              tipo: 'talla',
                              groupValue: tallaReal,
                              onChanged: (value) => setState(() => tallaReal = value),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),
                        Row(
                          children: const [
                            Expanded(child: Text('Altura de Rodilla')),
                            SizedBox(width: 16),
                            Expanded(child: Text('CMB')),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(child: InputWidgets.buildNumericInput(rodillaController, Icons.accessibility)),
                            const SizedBox(width: 16),
                            Expanded(child: InputWidgets.buildNumericInput(cmbController, Icons.circle)),
                          ],
                        ),

                        const SizedBox(height: 8),
                        Row(
                          children: const [
                            Expanded(child: Text('Fecha de Nacimiento')),
                            SizedBox(width: 16),
                            Expanded(child: Text('Edad')),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  TextField(
                                    controller: fechaController,
                                    keyboardType: TextInputType.datetime,
                                    inputFormatters: [DateInputFormatter()],
                                    decoration: InputDecoration(
                                      prefixIcon: IconButton(
                                        icon: const Icon(Icons.calendar_today, color: Colors.teal),
                                        onPressed: () async {
                                          final selectedDate = await showDialog<DateTime>(
                                            context: context,
                                            builder: (context) => CalendarioWidget(
                                              fechaActual: fechaController.text.isNotEmpty
                                                  ? DateFormat('dd-MM-yyyy').parse(fechaController.text)
                                                  : DateTime.now(),
                                              onFechaSeleccionada: (fecha) {
                                                Navigator.of(context).pop(fecha);
                                              },
                                            ),
                                          );
                                          if (selectedDate != null) {
                                            final formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
                                            setState(() {
                                              fechaController.text = formattedDate;
                                              edadController.text = _calcularEdad(selectedDate);
                                            });
                                          }
                                        },
                                      ),
                                      contentPadding: const EdgeInsets.all(8),
                                      filled: true,
                                      fillColor: Colors.white.withAlpha(200),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Color(0xFF248277)),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      hintText: 'dd-mm-aaaa',
                                    ),
                                    onChanged: (value) {
                                      if (value.length == 10) {
                                        try {
                                          final date = DateFormat('dd-MM-yyyy').parseStrict(value);
                                          setState(() {
                                            edadController.text = _calcularEdad(date);
                                          });
                                        } catch (e) {
                                          setState(() {
                                            edadController.text = '';
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          edadController.text = '';
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: InputWidgets.buildNumericInput(edadController, Icons.cake, readOnly: true),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),
                        const Text('Lugar de Origen'),
                        const SizedBox(height: 4),
                        InputWidgets.buildInputField(origenController, Icons.location_on),

                        const SizedBox(height: 8),
                        const Center(
                          child: Text(
                            'Diagnosticos',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),

                        const SizedBox(height: 8),
                        const Text('Diagnóstico Nutricional'),
                        const SizedBox(height: 4),
                        InputWidgets.buildInputField(diagnosticoNutriController, Icons.apple),

                        const SizedBox(height: 8),
                        const Text('Diagnóstico Médico'),
                        const SizedBox(height: 4),
                        InputWidgets.buildInputField(diagnosticoMedicoController, Icons.healing),
                        const SizedBox(height: 8),

                        LaboratoriosSection(
                          campos: camposLaboratorios,
                          onSave: _guardarDatosLaboratorio,
                        ),

                        const SizedBox(height: 8),
                        Center(
                          child: ElevatedButton(
                            onPressed: _guardarConsulta,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF248277),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Guardar Consulta', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
