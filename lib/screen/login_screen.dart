import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/model/user.dart';
import 'package:story_app/provider/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  final Function() onLogin;
  final Function() onRegister;
  const LoginScreen({
    super.key,
    required this.onLogin,
    required this.onRegister,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(backgroundColor: Colors.white),
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
                  "Masuk Akun",
                  style: Theme.of(context).textTheme.titleLarge,
                )),
                const SizedBox(height: 8),
                const Text(
                  "Masukkan email & password kamu untuk masuk ke aplikasi",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                const Text("Nomor HP atau email"),
                TextFormField(
                  controller: txtEditEmail,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email tidak boleh kosong";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
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
                const Text("Password"),
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
                const SizedBox(height: 24),
                const Row(
                  children: [
                    Spacer(),
                    Text("Lupa password?"),
                  ],
                ),
                const SizedBox(height: 24),
                context.watch<AuthProvider>().isLoadingLogin
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final scaffoldMessenger =
                                ScaffoldMessenger.of(context);
                            final User user = User(
                              email: txtEditEmail.text,
                              password: txtEditPass.text,
                            );
                            final authRead = context.read<AuthProvider>();

                            final result = await authRead.login(user);
                            if (result) {
                              widget.onLogin();
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
                          "Login",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => widget.onRegister(),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(
                      MediaQuery.of(context).size.width,
                      50,
                    ),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xffEF6A37), width: 2),
                  ),
                  child: const Text(
                    "Register",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
