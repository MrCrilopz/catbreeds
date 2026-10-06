import 'package:flutter/material.dart';

class BreedSearchField extends StatelessWidget {
  const BreedSearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
    this.focusNode,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Buscar raza en inglés',
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: 'Limpiar búsqueda',
                onPressed: onClear,
                icon: const Icon(Icons.clear),
              ),
      ),
    );
  }
}
