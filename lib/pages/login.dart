import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../constants/theme.dart';
import '../services/api.dart';
import 'dashboard.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool isLoading = false;

  void login() async {
    FocusScope.of(context).unfocus();
    if (loginController.text.isEmpty || passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Username/Email dan Password wajib diisi');
      return;
    }

    setState(() => isLoading = true);
    final result = await ApiService.login(
      loginController.text.trim(),
      passwordController.text.trim(),
    );

    setState(() => isLoading = false);

    if (result['success'] == true) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    } else {
      Fluttertoast.showToast(msg: result['message'] ?? 'Login gagal');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(image: AssetImage('images/brand.png'), width: 240),
                const SizedBox(height: 32),
                const Text(
                  "Masuk",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Aplikasi Informasi Pelanggan",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: loginController,
                  decoration: InputDecoration(
                    hintText: "Email / Username",
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontFamily: 'PlusJakartaSans',
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.primaryOrange,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                  ),
                  style: const TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontFamily: 'PlusJakartaSans',
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.primaryOrange,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  style: const TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child:
                        isLoading
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Text(
                              "MASUK",
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => const HomePage()));
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
              child: Icon(Icons.contacts, color: Colors.white, size: 28),
            ),
          ),
        ),
      ),
    );
  }
}
