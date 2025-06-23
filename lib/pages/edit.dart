import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../services/api.dart';

class EditPage extends StatefulWidget {
  final Customer customer;

  const EditPage({super.key, required this.customer});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _addressController;
  late TextEditingController _internetSpeedController;
  late TextEditingController _priceController;
  final List<String> _units = ['Mbps', 'Gbps'];
  String? _selectedUnit;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer.name);
    _phoneNumberController = TextEditingController(
      text: widget.customer.phoneNumber,
    );
    _addressController = TextEditingController(text: widget.customer.address);
    _internetSpeedController = TextEditingController(
      text: widget.customer.internetSpeed,
    );
    _priceController = TextEditingController(text: widget.customer.price);
    _selectedUnit = widget.customer.unit;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _internetSpeedController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() != true) return;

    final data = {
      'name': _nameController.text,
      'phone_number': _phoneNumberController.text,
      'address': _addressController.text,
      'internet_speed': _internetSpeedController.text,
      'unit': _selectedUnit,
      'price': _priceController.text,
    };

    final result = await ApiService.updateCustomer(widget.customer.id, data);

    if (result['success'] == true) {
      if (!mounted) return;
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pelanggan berhasil diedit'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Gagal mengedit pelanggan'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget buildField({
    required TextEditingController controller,
    required String label,
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'PlusJakartaSans',
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              hintText: label,
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontFamily: 'PlusJakartaSans',
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 248, 146, 57),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            style: const TextStyle(fontFamily: 'PlusJakartaSans'),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Tidak boleh kosong';
              if (isNumber && !RegExp(r'^\d+$').hasMatch(value)) {
                return 'Harus berupa angka';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget buildDropdownUnit() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Unit',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'PlusJakartaSans',
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedUnit,
            items:
                _units
                    .map(
                      (unit) =>
                          DropdownMenuItem(value: unit, child: Text(unit)),
                    )
                    .toList(),
            onChanged: (value) {
              setState(() {
                _selectedUnit = value;
              });
            },
            validator:
                (value) =>
                    value == null || value.isEmpty ? 'Pilih satuan unit' : null,
            decoration: InputDecoration(
              hintText: 'Pilih Unit',
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontFamily: 'PlusJakartaSans',
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 248, 146, 57),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF295CA3), Color.fromARGB(255, 43, 129, 221)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 12,
                right: 12,
                top: 16,
                bottom: 20,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Edit Pelanggan',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildField(controller: _nameController, label: 'Nama'),
              buildField(
                controller: _phoneNumberController,
                label: 'Nomor HP',
                isNumber: true,
              ),
              buildField(controller: _addressController, label: 'Alamat'),
              buildField(
                controller: _internetSpeedController,
                label: 'Kecepatan Internet',
                isNumber: true,
              ),
              buildDropdownUnit(),
              buildField(controller: _priceController, label: 'Harga'),
              const SizedBox(height: 20),
              SizedBox(
                height: 56,
                child: InkWell(
                  onTap: _submitForm,
                  borderRadius: BorderRadius.circular(16),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF29C52), Color(0xFFE68837)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'SIMPAN PERUBAHAN',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'PlusJakartaSans',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
