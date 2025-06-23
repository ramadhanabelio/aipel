import 'package:flutter/material.dart';
import '../services/api.dart';
import '../constants/theme.dart';
import '../models/customer.dart';
import 'login.dart';
import 'show.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Customer> customers = [];
  List<Customer> filteredCustomers = [];
  List<String> addresss = ['Semua Alamat'];
  String selectedAddress = 'Semua Alamat';
  String searchQuery = '';
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await ApiService.getCustomers();
      final deptList = [
        'Semua Alamat',
        ...{for (var item in data) item.address ?? 'Lainnya'}
          ..removeWhere((e) => e.isEmpty),
      ];

      setState(() {
        customers = data;
        addresss = deptList;
        filteredCustomers = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal memuat data pelanggan';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 160,
              width: double.infinity,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/white.png', width: 150),
                  const SizedBox(height: 10),
                  const Text(
                    'PT. Central Digital Network',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'PlusJakartaSans',
                    ),
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
            if (isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (errorMessage != null)
              Expanded(
                child: Center(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              )
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadCustomers,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: filteredCustomers.length,
                    itemBuilder: (context, index) {
                      final item = filteredCustomers[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ShowPage(id: item.id),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  'Nomor HP: ${item.phoneNumber ?? '-'}',
                                  style: const TextStyle(color: Colors.white70),
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
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => const LoginPage()));
          },
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
              child: Icon(Icons.manage_accounts, color: Colors.white, size: 28),
            ),
          ),
        ),
      ),
    );
  }
}
