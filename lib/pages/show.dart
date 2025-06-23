import 'package:flutter/material.dart';
import '../services/api.dart';
import '../models/customer.dart';
import 'package:intl/intl.dart';

class ShowPage extends StatelessWidget {
  final int id;
  const ShowPage({super.key, required this.id});

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

  Widget buildInfoCard(String label, String? value, {bool isPrice = false}) {
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
            isPrice ? formatRupiah(value) : (value ?? '-'),
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
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const Text(
                    'Detail Pelanggan',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<Customer>(
        future: ApiService.getCustomerById(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Gagal memuat data',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          final detail = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              buildInfoCard('Nama', detail.name),
              buildInfoCard('Nomor HP', detail.phoneNumber),
              buildInfoCard('Alamat', detail.address),
              buildInfoCard('Kecepatan Internet', detail.internetSpeed),
              buildInfoCard('Unit', detail.unit),
              buildInfoCard('Harga per Bulan', detail.price, isPrice: true),
            ],
          );
        },
      ),
    );
  }
}
