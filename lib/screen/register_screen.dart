import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/model/user.dart';
import 'package:story_app/provider/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  final Function() onRegister;
  final Function() onLogin;
  const RegisterScreen({
    super.key,
    required this.onRegister,
    required this.onLogin,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var txtEditName = TextEditingController();
  var txtEditEmail = TextEditingController();
  var txtEditPass = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    txtEditEmail.dispose();
    txtEditPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quotes App"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Text(
                    "Daftar Akun",
                    style: Theme.of(context).textTheme.titleLarge,
                  )),
                  const SizedBox(height: 8),
                  const Text(
                    "Masukkan nama, email, dan password kamu untuk mendaftar",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: txtEditName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "nama tidak boleh kosong";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        label: Text("Nama"),
                        labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                        hintText: "Masukkan nama",
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                        prefixIcon: Icon(
                          Icons.email_rounded,
                          color: Color(0xffEF6A37),
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffEF6A37))),
                        contentPadding: EdgeInsets.symmetric(vertical: 16)),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: txtEditEmail,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Nama tidak boleh kosong";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        label: Text("Email"),
                        labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                        hintText: "Masukkan email",
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                        prefixIcon: Icon(
                          Icons.email_rounded,
                          color: Color(0xffEF6A37),
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffEF6A37))),
                        contentPadding: EdgeInsets.symmetric(vertical: 16)),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    obscureText: true,
                    controller: txtEditPass,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password tidak boleh kosong";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        label: Text("Password"),
                        labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                        hintText: "Masukkan password",
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                        prefixIcon: Icon(
                          Icons.lock_outline_rounded,
                          color: Color(0xffEF6A37),
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffEF6A37))),
                        contentPadding: EdgeInsets.symmetric(vertical: 16)),
                  ),
                  const SizedBox(height: 50),
                  context.watch<AuthProvider>().isLoadingRegister
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final scaffoldMessenger =
                                  ScaffoldMessenger.of(context);
                              final User user = User(
                                name: txtEditName.text,
                                email: txtEditEmail.text,
                                password: txtEditPass.text,
                              );
                              final authRead = context.read<AuthProvider>();

                              final result = await authRead.register(user);
                              if (result) {
                                widget.onRegister();
                              } else {
                                if (context.mounted) {
                                  final loginError =
                                      context.read<AuthProvider>().errorMessage;
                                  scaffoldMessenger.showSnackBar(
                                    SnackBar(
                                      content: Text(loginError),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(
                              MediaQuery.of(context).size.width,
                              50,
                            ),
                            backgroundColor: const Color(0xffEF6A37),
                          ),
                          child: const Text(
                            "Register",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () => widget.onLogin(),
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(
                        MediaQuery.of(context).size.width,
                        50,
                      ),
                      backgroundColor: Colors.white,
                      side:
                          const BorderSide(color: Color(0xffEF6A37), width: 2),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
