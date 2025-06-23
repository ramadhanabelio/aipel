import 'package:flutter/material.dart';
import '../constants/theme.dart';
import '../models/user.dart';
import '../models/customer.dart';
import '../services/api.dart';
import 'home.dart';
import 'detail.dart';
import 'create.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  User? user;
  List<Customer> customers = [];
  List<Customer> filteredCustomers = [];
  List<String> addresss = ['Semua Alamat'];
  String selectedAddress = 'Semua Alamat';
  String searchQuery = '';
  String? errorMessage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final userData = await ApiService.getUser();
      final contactData = await ApiService.getCustomers();
      final deptList = [
        'Semua Alamat',
        ...{for (var item in contactData) item.address ?? 'Lainnya'}
          ..removeWhere((e) => e.isEmpty),
      ];

      setState(() {
        user = userData;
        customers = contactData;
        addresss = deptList;
        filteredCustomers = contactData;
        errorMessage = null;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal memuat data. Silakan coba lagi.';
        isLoading = false;
      });
    }
  }

  void _filterCustomers() {
    final query = searchQuery.toLowerCase();
    setState(() {
      filteredCustomers =
          customers.where((item) {
            final matchesSearch =
                item.name.toLowerCase().contains(query) ||
                (item.phoneNumber?.toLowerCase() ?? '').contains(query) ||
                (item.address?.toLowerCase() ?? '').contains(query);

            final matchesDept =
                selectedAddress == 'Semua Alamat' ||
                (item.address ?? '').toLowerCase() ==
                    selectedAddress.toLowerCase();

            return matchesSearch && matchesDept;
          }).toList();
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text(
              'Pilih Alamat',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                      width: double.maxFinite,
                      child: ListView(
                        shrinkWrap: true,
                        children:
                            addresss.map((dept) {
                              return ListTile(
                                title: Text(dept),
                                onTap: () {
                                  setState(() {
                                    selectedAddress = dept;
                                    _filterCustomers();
                                  });
                                  Navigator.pop(context);
                                },
                              );
                            }).toList(),
                      ),
                    ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedAddress = 'Semua Alamat';
                    _filterCustomers();
                  });
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.black),
                child: const Text('Reset'),
              ),
            ],
          ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text(
              "Konfirmasi",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text("Apakah Anda yakin ingin keluar?"),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: const Text("Batal"),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: const Text("Keluar"),
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  await ApiService.logout();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomePage()),
                      (route) => false,
                    );
                  }
                },
              ),
            ],
          ),
    );
  }

  Future<void> _goToCreatePage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreatePage()),
    );

    if (result == true) {
      await _loadData();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pelanggan berhasil ditambahkan'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF295CA3),
                    Color.fromARGB(255, 43, 129, 221),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Image.asset('images/white.png', width: 50, height: 50),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Memuat...',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          user?.email ?? '',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: _confirmLogout,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      onChanged: (val) {
                        searchQuery = val;
                        _filterCustomers();
                      },
                      decoration: InputDecoration(
                        hintText: "Pencarian...",
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.primaryOrange,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF29C52), Color(0xFFE68837)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.filter_list, color: Colors.white),
                      onPressed: _showFilterDialog,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadData,
                child:
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : errorMessage != null
                        ? Center(
                          child: Text(
                            errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: filteredCustomers.length,
                          itemBuilder: (context, index) {
                            final item = filteredCustomers[index];
                            return Dismissible(
                              key: Key(item.id.toString()),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              confirmDismiss: (_) async {
                                return await showDialog(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: const Text(
                                          'Konfirmasi',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content: const Text(
                                          'Apakah Anda yakin ingin menghapus pelanggan ini?',
                                        ),
                                        actions: [
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 12,
                                                  ),
                                            ),
                                            onPressed:
                                                () => Navigator.of(
                                                  context,
                                                ).pop(false),
                                            child: const Text('Batal'),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.primaryOrange,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 12,
                                                  ),
                                            ),
                                            onPressed:
                                                () => Navigator.of(
                                                  context,
                                                ).pop(true),
                                            child: const Text('Hapus'),
                                          ),
                                        ],
                                      ),
                                );
                              },
                              onDismissed: (_) async {
                                final result = await ApiService.deleteCustomer(
                                  item.id,
                                );
                                if (result['success'] == true) {
                                  setState(() {
                                    customers.removeWhere(
                                      (t) => t.id == item.id,
                                    );
                                    _filterCustomers();
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Pelanggan berhasil dihapus',
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        result['message'] ??
                                            'Gagal menghapus pelanggan',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF1976D2),
                                      Color(0xFF0D47A1),
                                    ],
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
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(14),
                                  title: Text(
                                    item.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(
                                        'Nomor HP: ${item.phoneNumber ?? '-'}',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                      if (item.address != null)
                                        Text(
                                          'Alamat: ${item.address}',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                    ],
                                  ),
                                  trailing: const Padding(
                                    padding: EdgeInsets.only(right: 18),
                                    child: Icon(
                                      Icons.contacts,
                                      color: Colors.white,
                                      size: 42,
                                    ),
                                  ),
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => DetailPage(customer: item),
                                      ),
                                    );
                                    await _loadData();
                                  },
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          onPressed: _goToCreatePage,
          shape: const CircleBorder(),
          backgroundColor: Colors.transparent,
          elevation: 2,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFFF29C52), Color(0xFFE68837)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ),
        ),
      ),
    );
  }
}
