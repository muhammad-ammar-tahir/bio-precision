import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/user_profile_provider.dart';

class FarmProfileScreen extends StatefulWidget {
  const FarmProfileScreen({super.key});

  @override
  State<FarmProfileScreen> createState() => _FarmProfileScreenState();
}

class _FarmProfileScreenState extends State<FarmProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _sizeCtrl;
  late TextEditingController _otherCtrl;
  late List<String> _selectedCrops;

  static const _predefinedCrops = [
    'Tomato', 'Maize', 'Wheat', 'Rice', 'Potato',
    'Cotton', 'Sugarcane', 'Pepper', 'Soybean', 'Onion',
    'Chickpea', 'Sunflower', 'Mango', 'Banana',
  ];

  @override
  void initState() {
    super.initState();
    final p = context.read<UserProfileProvider>();
    _nameCtrl = TextEditingController(text: p.farmName);
    _sizeCtrl = TextEditingController(text: p.farmSize);
    _selectedCrops = List.from(p.cropTypes);
    final others = _selectedCrops.where((c) => !_predefinedCrops.contains(c)).toList();
    _otherCtrl = TextEditingController(text: others.join(', '));
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _sizeCtrl.dispose();
    _otherCtrl.dispose();
    super.dispose();
  }

  void _toggleCrop(String crop) {
    setState(() {
      if (_selectedCrops.contains(crop)) {
        _selectedCrops.remove(crop);
      } else {
        _selectedCrops.add(crop);
      }
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    // Merge predefined + custom
    final others = _otherCtrl.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    final all = {..._selectedCrops, ...others}.toList();
    await context.read<UserProfileProvider>().saveFarmProfile(
          name: _nameCtrl.text,
          size: _sizeCtrl.text,
          cropTypes: all,
        );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Farm profile saved!'),
          backgroundColor: AppTheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: const Text('Farm Profile'),
        backgroundColor: AppTheme.surface,
        foregroundColor: AppTheme.onSurface,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _save,
            child: Text('Save', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Farm Name
            _SectionLabel('Farm Information'),
            const SizedBox(height: 12),
            _StyledField(
              controller: _nameCtrl,
              label: 'Farm Name',
              hint: 'e.g. Green Valley Farm',
              icon: Icons.agriculture,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Farm name is required' : null,
            ),
            const SizedBox(height: 16),
            _StyledField(
              controller: _sizeCtrl,
              label: 'Farm Size (acres)',
              hint: 'e.g. 25',
              icon: Icons.straighten,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 28),

            // Crop Types
            _SectionLabel('Crop Types'),
            const SizedBox(height: 4),
            Text('Select all crops you grow:', style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 13)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _predefinedCrops.map((crop) {
                final selected = _selectedCrops.contains(crop);
                return FilterChip(
                  label: Text(crop),
                  selected: selected,
                  onSelected: (_) => _toggleCrop(crop),
                  selectedColor: AppTheme.primaryFixedDim,
                  checkmarkColor: AppTheme.primary,
                  labelStyle: TextStyle(
                    color: selected ? AppTheme.primary : AppTheme.onSurfaceVariant,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  backgroundColor: AppTheme.surfaceContainerLow,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: BorderSide(color: selected ? AppTheme.primary : AppTheme.outline, width: 1.5),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            _StyledField(
              controller: _otherCtrl,
              label: 'Other Crops (comma separated)',
              hint: 'e.g. Guava, Mango',
              icon: Icons.add_circle_outline,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);
  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 2,
        color: AppTheme.primary,
      ),
    );
  }
}

class _StyledField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _StyledField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppTheme.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppTheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppTheme.primary, width: 2),
        ),
        filled: true,
        fillColor: AppTheme.surfaceContainerLow,
      ),
    );
  }
}
