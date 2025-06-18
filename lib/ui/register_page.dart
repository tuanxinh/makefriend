import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makefriend/core/FitnessAppTheme.dart';
import 'package:makefriend/core/widget.dart';
import 'package:makefriend/logic/auth/auth_bloc.dart';
import 'package:makefriend/logic/auth/auth_event.dart';
import 'package:makefriend/logic/auth/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      // TODO: Thực hiện logic đăng ký ở đây, ví dụ gọi API
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Registering...')),
      // );
      context.read<AuthBloc>().add(AuthRegister(email: emailController.text, password: passwordController.text, hoten: usernameController.text));
      // Ví dụ tự động chuyển sang trang Login
      //Navigator.pop(context);
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        foregroundColor: Colors.white,
        backgroundColor: FitnessAppTheme.colorAppBar,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state){
          if(state is AuthRegisterSuccess){
            showCustomSnackBar(context: context, message: state.message, contentType: ContentType.success);
            Navigator.pop(context);
          }
          if(state is AuthFailure){
            showCustomSnackBar(context: context, message: state.message, contentType: ContentType.warning);
          }
        },
        builder: (context, state) => Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildTextField(
                  controller: usernameController,
                  label: "Họ Và Tên",
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Name cannot be empty';
                    if (value.length < 3) return 'Name must be at least 3 characters';
                    return null;
                  },
                ),
                _buildTextField(
                  controller: emailController,
                  label: "Email",
                  icon: Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Email cannot be empty';
                    if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value)) {
                      return 'Invalid email format';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  controller: passwordController,
                  label: "Password",
                  icon: Icons.lock,
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Password cannot be empty';
                    if (value.length < 6) return 'Password must be at least 6 characters';
                    return null;
                  },
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FitnessAppTheme.colorAppBar,
                    fixedSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Quay lại trang Login
                  },
                  child: const Text("Already have an account? Login here"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
