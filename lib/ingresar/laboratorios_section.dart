import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LaboratoriosSection extends StatefulWidget {
  final List<Map<String, TextEditingController>> campos;
  final VoidCallback onSave;

  const LaboratoriosSection({
    super.key,
    required this.campos,
    required this.onSave,
  });

  @override
  State<LaboratoriosSection> createState() => _LaboratoriosSectionState();
}

class _LaboratoriosSectionState extends State<LaboratoriosSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: Text(
            'Laboratorios',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: const [
            Expanded(flex: 2, child: Text('Examen')),
            SizedBox(width: 8),
            Expanded(child: Text('Referencia')),
            SizedBox(width: 8),
            Expanded(child: Text('Resultado')),
          ],
        ),
        const SizedBox(height: 2),
        ...widget.campos.map((campo) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Expanded(
                flex:2,
                child: TextField(
                  controller: campo['estudio'],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.8),
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                  onChanged: (_) => widget.onSave(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: campo['referencia'],
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 áéíóúÁÉÍÓÚñÑ.,-]')),
                  ],
                  onChanged: (_) => widget.onSave(),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withAlpha(200),
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: campo['resultado'],
                  keyboardType: TextInputType.numberWithOptions(
                    signed: true,
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[-+0-9.,]')),
                  ],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.8),
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                ),
              ),
            ],
          ),
        )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                if (widget.campos.length > 1) {
                  setState(() {
                    widget.campos.removeLast();
                  });
                  widget.onSave();
                }
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: Colors.red,
              ),
              child: const Text('Quitar campo'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.campos.add({
                    'estudio': TextEditingController(),
                    'referencia': TextEditingController(),
                    'resultado': TextEditingController(),
                  });
                });
                widget.onSave();
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: Colors.green,
              ),
              child: const Text('Agregar campo'),
            ),
          ],
        ),
      ],
    );
  }
}
