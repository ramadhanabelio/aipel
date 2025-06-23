import 'package:flutter/material.dart';
import '../constants/theme.dart';
import 'home.dart';
import 'login.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int currentIndex = 0;

  final List<Map<String, String>> pages = [
    {
      'image': 'images/avatar3.png',
      'title': 'AIPEL',
      'subtitle': 'Aplikasi Informasi Pelanggan PT. Central Digital Network.',
    },
    {
      'image': 'images/avatar1.png',
      'title': 'Informasi Pelanggan',
      'subtitle':
          'Menampilkan daftar seluruh pelanggan pada PT. Central Digital Network.',
    },
    {
      'image': 'images/avatar4.png',
      'title': 'Pantau dan Cari',
      'subtitle': 'Lihat semua kebutuhan anda pada aplikasi ini.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 3,
                child: PageView.builder(
                  onPageChanged:
                      (index) => setState(() => currentIndex = index),
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    final page = pages[index];
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 32,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(page['image']!, height: 320),
                            const SizedBox(height: 32),
                            Text(
                              page['title']!,
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'PlusJakartaSans',
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              page['subtitle']!,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                color: Colors.black54,
                                fontFamily: 'PlusJakartaSans',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        pages.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: currentIndex == index ? 16 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color:
                                currentIndex == index
                                    ? AppColors.primaryOrange
                                    : Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HomePage(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppColors.primaryOrange,
                            ),
                            foregroundColor: AppColors.primaryOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text('LIHAT DAFTAR PELANGGAN'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryOrange,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text('MASUK'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 40,
            right: 20,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                );
              },
              child: const Text(
                'LEWATI',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
