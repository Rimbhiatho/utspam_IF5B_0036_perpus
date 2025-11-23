import 'package:flutter/material.dart';
import 'homepage.dart';
import 'registrasi.dart';
import 'data/repository/user_repository.dart';
import 'data/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 51, 58, 68),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/Logo-perpus.png', height: 250),
                Text(
                  "Titho e-Library",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 254, 236, 195),
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  "Silahkan login untuk dapat membuka e-library.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                SizedBox(height: 20),
                Form(
                  key: _formKey,

                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      TextFormField(
                        //Login Email
                        controller: _emailController,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Tidak boleh kosong";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          label: Text(
                            "Email atau NIK",
                            style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          hintText: "Masukkan Email atau NIK",
                          hintStyle: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),

                      SizedBox(height: 16),
                      TextFormField(
                        //Login Password
                        controller: _passwordController,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        obscureText: !_isPasswordVisible,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Tidak boleh kosong";
                          } else if (value.length < 8) {
                            return "Minimal 8 karakter";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: Text(
                            "Password",
                            style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          hintText: "Masukkan Password",
                          hintStyle: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final repo = UserRepository();
                              final user = await repo.getUserByIdentifier(
                                _emailController.text.trim(),
                              );
                              if (user == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('User tidak ditemukan'),
                                  ),
                                );
                                return;
                              }
                              if (user.password != _passwordController.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Password salah'),
                                  ),
                                );
                                return;
                              }
                              // set current user
                              AuthService.instance.signIn(user.id!);

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Homepage(),
                                ),
                                (route) => false,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              116,
                              145,
                              168,
                            ),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Login'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Apakah Belum punya akun? ",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 232, 203, 177),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegistrasiPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Daftar",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 171, 185, 223),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
