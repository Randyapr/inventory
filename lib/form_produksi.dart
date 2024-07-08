import 'package:flutter/material.dart';

class FormProduksi extends StatefulWidget {
  final Future<void> Function(String, double, int, String, double) saveProduction;
  final VoidCallback refreshData;

  const FormProduksi({required this.saveProduction, required this.refreshData, super.key});

  @override
  _FormProduksiState createState() => _FormProduksiState();
}

class _FormProduksiState extends State<FormProduksi> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _qtyController;
  late TextEditingController _attrController;
  late TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _qtyController = TextEditingController();
    _attrController = TextEditingController();
    _weightController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _qtyController.dispose();
    _attrController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _saveProduction() async {
    try {
      await widget.saveProduction(
        _nameController.text,
        double.parse(_priceController.text),
        int.parse(_qtyController.text),
        _attrController.text,
        double.parse(_weightController.text),
      );
      widget.refreshData(); // Refresh data on parent page
      Navigator.pop(context); // Navigate back to production page
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Gagal menyimpan produksi: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produksi'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildTextFormField(
                  controller: _nameController,
                  label: 'Nama Produk',
                  icon: Icons.label,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama produk wajib diisi';
                    }
                    return null;
                  },
                ),
                _buildTextFormField(
                  controller: _priceController,
                  label: 'Harga',
                  icon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harga wajib diisi';
                    }
                    return null;
                  },
                ),
                _buildTextFormField(
                  controller: _qtyController,
                  label: 'Jumlah',
                  icon: Icons.format_list_numbered,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Jumlah wajib diisi';
                    }
                    return null;
                  },
                ),
                _buildTextFormField(
                  controller: _attrController,
                  label: 'Atribut',
                  icon: Icons.info,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Atribut wajib diisi';
                    }
                    return null;
                  },
                ),
                _buildTextFormField(
                  controller: _weightController,
                  label: 'Berat',
                  icon: Icons.line_weight,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Berat wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _saveProduction();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? hintText,
    Widget? suffixIcon,
    required FormFieldValidator<String> validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.teal),
          hintText: hintText,
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: suffixIcon,
        ),
        validator: validator,
      ),
    );
  }
}
