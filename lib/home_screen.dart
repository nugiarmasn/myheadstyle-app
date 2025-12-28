import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'api_service.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isWanita = false;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _handleAction(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 70);
    if (pickedFile != null) {
      _processAnalysis(File(pickedFile.path));
    }
  }

  Future<void> _processAnalysis(File imageFile) async {
    setState(() => _isLoading = true);
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? "anonymous";
      final response = await ApiService.analyzeFace(
        imageFile: imageFile,
        gender: isWanita ? "Perempuan" : "Laki-laki",
        isHijab: isWanita,
        userId: userId,
      );

      if (response['status'] == 'success' && response['data'] != null) {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResultScreen(data: response['data'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'] ?? "Gagal")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Kita pakai Stack agar Bottom Nav bisa "mengambang" di posisi paling bawah
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFBF36FF), Color(0xFF6A1B9A)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // 1. KONTEN UTAMA (Bisa di-scroll agar tidak overflow)
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text("Beranda",
                        style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 30),

                    // Card Kamera
                    _buildMenuCard("Kamera", Icons.camera_alt_outlined, () => _handleAction(ImageSource.camera)),
                    const SizedBox(height: 20),

                    // Card Galeri
                    _buildMenuCard("Galeri", Icons.image_outlined, () => _handleAction(ImageSource.gallery)),
                    const SizedBox(height: 30),

                    // Switch Gender
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Pilih Gender",
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            const Text("Pria", style: TextStyle(color: Colors.white)),
                            Switch(
                              value: isWanita,
                              onChanged: (v) => setState(() => isWanita = v),
                              activeColor: Colors.white,
                            ),
                            const Text("Wanita", style: TextStyle(color: Colors.white)),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 150), // Beri ruang agar tidak tertutup Bottom Nav
                  ],
                ),
              ),

              // 2. CHATBOT AI (Floating di kanan bawah)
              Positioned(
                right: 20,
                bottom: 110, // Di atas Bottom Nav
                child: GestureDetector(
                  onTap: () => print("Buka Chatbot"),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(color: Color(0xFFE1BEE7), shape: BoxShape.circle),
                        child: const Icon(Icons.face_retouching_natural, size: 50, color: Colors.purple),
                      ),
                      const Text("Chatbot AI", style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
              ),

              // 3. BOTTOM NAVIGATION BAR (Fixed di bawah)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.home, color: Colors.white, size: 32),
                      Icon(Icons.auto_awesome, color: Colors.white, size: 32),
                      Icon(Icons.person, color: Colors.white, size: 32),
                    ],
                  ),
                ),
              ),

              // 4. LOADING OVERLAY
              if (_isLoading)
                Container(
                  color: Colors.black54,
                  child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color: const Color(0xFFCE93D8).withOpacity(0.9),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Icon(icon, size: 70, color: Colors.white),
          ],
        ),
      ),
    );
  }
}