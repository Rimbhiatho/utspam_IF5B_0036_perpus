import 'package:flutter/material.dart';
import '../data/auth/auth_service.dart';
import '../data/repository/user_repository.dart';
import '../data/model/user.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 51, 58, 68),
      body: FutureBuilder<UserModel?>(
        // Ambil data user yang sedang login
        future: () async {
          final id = AuthService.instance.currentUserId;
          if (id == null) return null;
          return UserRepository().getUserById(id);
        }(),
        builder: (context, snapshot) {
          // Tampilkan loading saat data belum selesai diambil
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data;

          // Tentukan nama yang ditampilkan
          final displayName =
              (user?.username != null && user!.username.isNotEmpty)
              ? user.username
              : (user?.name ?? 'Guest');

          return Column(
            children: [
              const _TopPortion(), // Bagian atas profil (foto dan background)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama pengguna
                      Center(
                        child: Text(
                          displayName,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Email pengguna
                      Center(
                        child: Text(
                          user?.email ?? '',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                      const Divider(height: 32, thickness: 1),

                      // Informasi detail pengguna
                      _infoRow("Nama Lengkap", user?.name),
                      _infoRow("Email", user?.email),
                      _infoRow("Alamat", user?.address),
                      _infoRow("No. Telepon", user?.phone),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Widget untuk menampilkan baris informasi profil
  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text("$label:", style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value?.isNotEmpty == true ? value! : "-",
              style: const TextStyle(color: Colors.white70),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// Bagian atas profil: background dan foto profil
class _TopPortion extends StatelessWidget {
  const _TopPortion();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background gradasi
          Container(
            margin: const EdgeInsets.only(bottom: 50),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color.fromARGB(255, 232, 203, 17),
                  Color.fromARGB(255, 254, 236, 195),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
          ),
          // Foto profil bulat di tengah bawah
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 150,
              height: 150,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Gambar profil
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/profile.jpg'),
                      ),
                    ),
                  ),
                  // Indikator status aktif (lingkaran hijau kecil)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Theme.of(
                        context,
                      ).scaffoldBackgroundColor,
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
