import 'package:flutter/material.dart';
import '../services/api.dart';
import '../constants/theme.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController internetSpeedController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final List<String> _units = ['Mbps', 'Gbps'];
  String? _selectedUnit;

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    internetSpeedController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final formData = {
      'name': nameController.text,
      'phone_number': phoneNumberController.text,
      'address': addressController.text,
      'internet_speed': internetSpeedController.text,
      'unit': _selectedUnit,
      'price': priceController.text,
    };

    final result = await ApiService.createCustomer(formData);
    setState(() => isLoading = false);

    if (result['success'] == true) {
      if (!mounted) return;
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Gagal menambahkan'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget buildLabeledTextField({
    required String label,
    required TextEditingController controller,
    bool requiredField = false,
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
            validator: (value) {
              if (requiredField && (value == null || value.isEmpty)) {
                return '$label wajib diisi';
              }
              if (isNumber &&
                  value != null &&
                  value.isNotEmpty &&
                  !RegExp(r'^\d+$').hasMatch(value)) {
                return '$label harus berupa angka';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: label,
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontFamily: 'PlusJakartaSans',
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.primaryOrange),
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
                _units.map((unit) {
                  return DropdownMenuItem(value: unit, child: Text(unit));
                }).toList(),
            onChanged: (value) => setState(() => _selectedUnit = value),
            validator:
                (value) =>
                    value == null || value.isEmpty
                        ? 'Unit wajib dipilih'
                        : null,
            decoration: InputDecoration(
              hintText: 'Pilih Unit',
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontFamily: 'PlusJakartaSans',
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.primaryOrange),
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
                      'Tambah Pelanggan',
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
              buildLabeledTextField(
                label: 'Nama',
                controller: nameController,
                requiredField: true,
              ),
              buildLabeledTextField(
                label: 'Nomor HP',
                controller: phoneNumberController,
                requiredField: true,
                isNumber: true,
              ),
              buildLabeledTextField(
                label: 'Alamat',
                controller: addressController,
                requiredField: true,
              ),
              buildLabeledTextField(
                label: 'Kecepatan Internet',
                controller: internetSpeedController,
                isNumber: true,
                requiredField: true,
              ),
              buildDropdownUnit(),
              buildLabeledTextField(
                label: 'Harga per Bulan',
                controller: priceController,
                isNumber: true,
                requiredField: true,
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                    height: 56,
                    child: InkWell(
                      onTap: _submit,
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
                            'SIMPAN',
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
