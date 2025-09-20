import 'package:eco_coin/app/helper/shared/app_color.dart';
import 'package:eco_coin/app/helper/shared/widget/shared_button.dart';
import 'package:eco_coin/app/helper/shared/widget/shared_text_form_field.dart';
import 'package:eco_coin/app/modules/splash/provider/shared_pref_provider.dart';
import 'package:eco_coin/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));

      final sharedPrefProvider = context.read<SharedPrefProvider>();
      await sharedPrefProvider.setHasLogin(true);

      if (mounted) {
        Navigator.pushReplacementNamed(context, Routes.home);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login gagal. Silakan coba lagi.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));

      final sharedPrefProvider = context.read<SharedPrefProvider>();
      await sharedPrefProvider.setHasLogin(true);

      if (mounted) {
        Navigator.pushReplacementNamed(context, Routes.home);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Google login gagal. Silakan coba lagi.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.emeraldDefault,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height:
                MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
            child: Column(
              children: [
                Expanded(flex: 3, child: _buildLogoSection()),
                Expanded(flex: 7, child: _buildFormCard()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Container(
      width: double.infinity,
      color: AppColor.emeraldDefault,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/ic_eco_coin_with_text.png',
            width: 120,
            height: 120,
          ),
          const SizedBox(height: 4),
          Text(
            "Selamat Datang!",
            style: AppColor.regular.copyWith(
              fontSize: 16,
              color: AppColor.neutralWhite.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColor.neutralWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                CustomTextFormField(
                  controller: _emailController,
                  labelText: "Email",
                  hintText: "Masukkan email anda",
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),

                const SizedBox(height: 16),

                PasswordFormField(
                  controller: _passwordController,
                  labelText: "Password",
                  hintText: "Masukkan password anda",
                  validator: Validators.password,
                ),

                const SizedBox(height: 24),

                PrimaryButton(
                  text: "Masuk",
                  onPressed: _handleLogin,
                  isLoading: _isLoading,
                ),

                const SizedBox(height: 20),

                const CustomDivider(text: "atau"),

                const SizedBox(height: 20),

                SecondaryButton.google(
                  text: "Masuk dengan Google",
                  onPressed: _handleGoogleLogin,
                  isLoading: _isLoading,
                ),

                const Spacer(),

                _buildRegisterLink(),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.register);
        },
        child: RichText(
          text: TextSpan(
            text: "Belum punya akun? ",
            style: AppColor.regular.copyWith(
              color: AppColor.neutral40,
              fontSize: 14,
            ),
            children: [
              TextSpan(
                text: "Daftar Sekarang",
                style: AppColor.semibold.copyWith(
                  color: AppColor.emeraldDefault,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
