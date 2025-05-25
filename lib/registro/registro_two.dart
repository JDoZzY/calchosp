import 'package:flutter/material.dart';

class RegistroTwo extends StatelessWidget {
  final Map<String, dynamic>? datos;
  const RegistroTwo({super.key, this.datos});

  @override
  Widget build(BuildContext context) {
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
              // Aquí va el contenido scrollable
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            datos?['nombrePaciente']?.toString() ?? 'Nombre no disponible',
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
                      'Registro No. ${datos?['numeroRegistro']?.toString() ?? '-'}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF036666),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Seguimiento',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
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
                      child: const Center(
                        child: Text(
                          'Contenedor Personalizable',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF036666),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),
                    _buildCard('Antropometría', [
                      _buildDato('Peso (Kg)', datos?['peso']),
                      _buildDato('Peso Real', datos?['pesoReal'] == true ? 'Sí' : 'No'),
                      _buildDato('Talla (Cm)', datos?['talla']),
                      _buildDato('Talla Real', datos?['tallaReal'] == true ? 'Sí' : 'No'),
                      _buildDato('Altura de Rodilla', datos?['rodilla']),
                      _buildDato('CMB', datos?['cmb']),
                    ]),
                    _buildCard('Datos Clínicos', [
                      _buildDato('Diagnóstico Nutricional', datos?['diagnosticoNutricional']),
                      _buildDato('Diagnóstico Médico', datos?['diagnosticoMedico']),
                    ]),
                    _buildCard('Laboratorios', [
                      if (datos?['laboratorios'] != null)
                        ..._buildLaboratorios(datos?['laboratorios'] as List<dynamic>)
                      else
                        const Text('No se ingresaron laboratorios', style: TextStyle(color: Colors.grey)),
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
                    datos?['nombrePaciente']?.toString() ?? 'Nombre no disponible',
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
                      _filaDoble('No. Registro', datos?['numeroRegistro'], 'No. Cama', datos?['numeroCama']),
                      const SizedBox(height: 8),
                      _filaDoble('F. Nacimiento', datos?['fechaNacimiento'], 'Edad', datos?['edad']),
                      const SizedBox(height: 8),
                      _filaSimple('Lugar de Origen', datos?['origen']),
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
            Text(
              titulo,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF036666)),
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
              style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              valor?.toString() ?? 'No especificado',
              style: const TextStyle(color: Colors.black54),
            ),
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
