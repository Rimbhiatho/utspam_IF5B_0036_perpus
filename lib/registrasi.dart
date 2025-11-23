import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data/repository/user_repository.dart';
import 'data/model/user.dart';
import 'widgets/page_header.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({super.key});

  @override
  State<RegistrasiPage> createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  // Form key untuk validasi
  final _formKey = GlobalKey<FormState>();

  // Controller untuk setiap input field
  final _nameController = TextEditingController();
  final _nikdController = TextEditingController();
  final _emailController = TextEditingController();
  final _alamatController = TextEditingController();
  final _noteleponController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Dispose controller saat widget dihancurkan
  @override
  void dispose() {
    _nameController.dispose();
    _nikdController.dispose();
    _emailController.dispose();
    _alamatController.dispose();
    _noteleponController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrasi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header halaman registrasi
              const PageHeader(
                icon: Icons.app_registration,
                title: 'Create New Account',
              ),

              // Input Nama
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Input NIK
              TextFormField(
                controller: _nikdController,
                decoration: const InputDecoration(labelText: 'NIK'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'NIK tidak boleh kosong';
                  }
                  final digitsOnly = RegExp(r'^[0-9]+$');
                  if (!digitsOnly.hasMatch(value)) {
                    return 'NIK harus angka';
                  }
                  if (value.length != 16) {
                    return 'harus 16 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Input Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tidak boleh kosong';
                  }
                  if (!value.contains('@gmail.com')) {
                    return 'Format email tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Input Password
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tidak boleh kosong';
                  }
                  if (value.length < 8) {
                    return 'Minimal 8 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Konfirmasi Password
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Konfirmasi Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tidak boleh kosong';
                  }
                  if (value != _passwordController.text) {
                    return 'Password tidak cocok';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Input Username
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Input No. Telepon
              TextFormField(
                controller: _noteleponController,
                decoration: const InputDecoration(labelText: 'No. Telepon'),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(13),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'No. Telepon tidak boleh kosong';
                  }
                  final digitsOnly = RegExp(r'^[0-9]{11,13}$');
                  if (!digitsOnly.hasMatch(value)) {
                    return 'No. Telepon harus angka dan panjang 11-13';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Input Alamat
              TextFormField(
                controller: _alamatController,
                decoration: const InputDecoration(labelText: 'Alamat'),
                keyboardType: TextInputType.streetAddress,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Tombol Daftar
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final userRepo = UserRepository();
                    final user = UserModel(
                      name: _nameController.text.trim(),
                      nik: _nikdController.text.trim(),
                      username: _usernameController.text.trim(),
                      email: _emailController.text.trim(),
                      password: _passwordController.text,
                      phone: _noteleponController.text.trim(),
                      address: _alamatController.text.trim(),
                    );

                    // Simpan user ke database
                    userRepo
                        .createUser(user)
                        .then((value) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Registrasi berhasil, silakan login',
                              ),
                            ),
                          );
                        })
                        .catchError((e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Gagal registrasi: $e')),
                          );
                        });
                  }
                },
                child: const Text('Daftar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
