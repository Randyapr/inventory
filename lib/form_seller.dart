import 'package:flutter/material.dart';

class FormSeller extends StatefulWidget {
  final Function(String, String, String, String) createSale;
  final VoidCallback refreshData;

  const FormSeller({required this.createSale, required this.refreshData, Key? key}) : super(key: key);

  @override
  _FormSellerState createState() => _FormSellerState();
}

class _FormSellerState extends State<FormSeller> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _buyerController;
  late TextEditingController _phoneController;
  late TextEditingController _dateController;
  late TextEditingController _statusController;

  @override
  void initState() {
    super.initState();
    _buyerController = TextEditingController();
    _phoneController = TextEditingController();
    _dateController = TextEditingController();
    _statusController = TextEditingController();
  }

  @override
  void dispose() {
    _buyerController.dispose();
    _phoneController.dispose();
    _dateController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dateController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<void> _createSale() async {
    try {
      await widget.createSale(
        _buyerController.text,
        _phoneController.text,
        _dateController.text,
        _statusController.text,
      );
      widget.refreshData(); // Refresh data on parent page
      Navigator.pop(context); // Navigate back to sales page
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Gagal membuat transaksi: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Transaksi Penjualan'),
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
                  controller: _buyerController,
                  label: 'Pembeli',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Pembeli wajib diisi';
                    }
                    return null;
                  },
                ),
                _buildTextFormField(
                  controller: _phoneController,
                  label: 'Telepon',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Telepon wajib diisi';
                    }
                    return null;
                  },
                ),
                _buildTextFormField(
                  controller: _dateController,
                  label: 'Tanggal',
                  icon: Icons.calendar_today,
                  keyboardType: TextInputType.datetime,
                  hintText: 'Pilih Tanggal',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today, color: Colors.teal),
                    onPressed: () => _selectDate(context),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tanggal wajib diisi';
                    }
                    return null;
                  },
                ),
                _buildTextFormField(
                  controller: _statusController,
                  label: 'Status',
                  icon: Icons.check_circle,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Status wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _createSale();
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
