import 'dart:convert';
import 'package:flutter/material.dart';
import 'chat_screen.dart'; // Pastikan import Chatbot kamu

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const ResultScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final String faceShape = data['face_shape'] ?? 'Tidak Terdeteksi';
    final String confidence = data['confidence'] ?? '0%';
    final List<dynamic> recommendations = data['recommendations'] ?? [];
    final String base64Image = data['photo_base64'] ?? '';
    final String gender = data['gender'] ?? 'User';

    const Color primaryPurple = Color(0xFFBF36FF);
    const Color darkPurple = Color(0xFF6A1B9A);

    return Scaffold(
      // KUNCI: Menambahkan tombol Chatbot melayang di halaman hasil
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE1BEE7),
        onPressed: () {
          // Navigasi ke Chatbot sambil membawa hasil screening
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(initialContext: data),
            ),
          );
        },
        child: const Icon(Icons.face_retouching_natural, color: Colors.purple, size: 35),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [primaryPurple, darkPurple],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Tombol Kembali
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      // FOTO HASIL
                      Container(
                        width: 250,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: base64Image.isNotEmpty
                              ? Image.memory(base64Decode(base64Image), fit: BoxFit.cover)
                              : const Icon(Icons.person, size: 100, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 25),

                      // HASIL SKRINING
                      Text(
                        "Bentuk Wajah: $faceShape",
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Akurasi: $confidence",
                        style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 20),

                      // TOMBOL KONSULTASI (Langsung di bawah hasil)
                      ElevatedButton.icon(
                        icon: const Icon(Icons.chat_outlined, size: 20),
                        label: const Text("Tanyakan hasil ini ke AI"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(initialContext: data),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // KOTAK REKOMENDASI
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: recommendations.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_outline, color: Colors.greenAccent),
                                const SizedBox(width: 10),
                                Text(item.toString(), style: const TextStyle(color: Colors.white, fontSize: 16)),
                              ],
                            ),
                          )).toList(),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // TOMBOL NEXT (Pindah ke Edit/Lanjut)
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD354FF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          onPressed: () {
                            // Sesuai keinginanmu, nanti di sini ke halaman edit
                            print("Pindah ke Halaman Edit");
                          },
                          child: const Text("Next", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}