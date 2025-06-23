import 'package:flutter/material.dart';
import '../models/customer.dart';
import 'edit.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  final Customer customer;

  const DetailPage({super.key, required this.customer});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Customer customer;

  @override
  void initState() {
    super.initState();
    customer = widget.customer;
  }

  String formatRupiah(String? value) {
    if (value == null || value.isEmpty) return '-';
    try {
      final intPart = value.split('.')[0];
      final number = int.parse(intPart);
      final formatter = NumberFormat('#,###', 'id_ID');
      return 'Rp. ${formatter.format(number)}';
    } catch (_) {
      return 'Rp. $value';
    }
  }

  Future<void> _goToEditPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditPage(customer: customer)),
    );

    if (result == true && mounted) {
      Navigator.pop(context, true);
    }
  }

  Widget buildInfoCard(String label, String? value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1976D2), Color(0xFF0D47A1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontFamily: 'PlusJakartaSans',
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value?.isNotEmpty == true ? value! : '-',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'PlusJakartaSans',
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Detail Pelanggan',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: _goToEditPage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          buildInfoCard('Nama', customer.name),
          buildInfoCard('Nomor HP', customer.phoneNumber),
          buildInfoCard('Alamat', customer.address),
          buildInfoCard('Kecepatan Internet', customer.internetSpeed),
          buildInfoCard('Unit', customer.unit),
          buildInfoCard('Harga per bulan', formatRupiah(customer.price)),
        ],
      ),
    );
  }
}
