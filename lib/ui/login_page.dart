import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makefriend/core/FitnessAppTheme.dart';
import 'package:makefriend/core/service.dart';
import 'package:makefriend/core/widget.dart';
import 'package:makefriend/data/repository/auth_repository.dart';
import 'package:makefriend/logic/auth/auth_bloc.dart';
import 'package:makefriend/logic/auth/auth_event.dart';
import 'package:makefriend/logic/auth/auth_state.dart';
import 'package:makefriend/ui/main_page.dart';
import 'package:makefriend/ui/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController.text = "phuong13@gmail.com";
    passwordController.text = "123456";
  }
  void _login() {
    if (_formKey.currentState!.validate()) {
      // TODO: Thực hiện logic đăng nhập ở đây, ví dụ gọi API
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Logging in...')),
      // );
      context.read<AuthBloc>().add(AuthLogin(email: emailController.text, password: passwordController.text));
      // Ví dụ chuyển đến trang ProfilePage nếu đăng nhập thành công
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProfilePage()));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget _buildTextField(
      {required TextEditingController controller,
        required String label,
        required IconData icon,
        bool obscureText = false,
        String? Function(String?)? validator,
        Widget? suffixIcon}) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: FitnessAppTheme.colorAppBar,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state){
          if(state is AuthSuccess){
            showCustomSnackBar(context: context, message: "Đăng nhập thành công", contentType: ContentType.success);
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MainPage()));
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
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FitnessAppTheme.colorAppBar,
                    fixedSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {

                    Navigator.push(context, MaterialPageRoute(builder: (_) =>
                        BlocProvider(
                          create: (context) => AuthBloc(repository: AuthRepository(apiService: ApiService())),
                            child: RegisterPage()
                        )));
                  },
                  child: const Text("Don't have an account? Register here"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
