import 'package:flutter/material.dart';

class FormSeller extends StatefulWidget {
  final Function(String, String, String, String) createSale;
  final VoidCallback refreshData;

  FormSeller({required this.createSale, required this.refreshData});

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
        _dateController.text = picked.toString().substring(0, 10);
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
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Gagal membuat transaksi: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Transaksi Penjualan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _buyerController,
                decoration: InputDecoration(labelText: 'Pembeli'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pembeli wajib diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Telepon'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Telepon wajib diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  labelText: 'Tanggal',
                  hintText: 'Pilih Tanggal',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () {
                      _selectDate(context);
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal wajib diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _statusController,
                decoration: InputDecoration(labelText: 'Status'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Status wajib diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _createSale();
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
