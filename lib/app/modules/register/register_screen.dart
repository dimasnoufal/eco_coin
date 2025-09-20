import 'package:eco_coin/app/helper/shared/app_color.dart';
import 'package:eco_coin/app/helper/shared/widget/shared_button.dart';
import 'package:eco_coin/app/helper/shared/widget/shared_text_form_field.dart';
import 'package:eco_coin/app/modules/splash/provider/shared_pref_provider.dart';
import 'package:eco_coin/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaLengkapController = TextEditingController();
  final _namaPanggilanController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _namaLengkapController.dispose();
    _namaPanggilanController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));

      final sharedPrefProvider = context.read<SharedPrefProvider>();
      await sharedPrefProvider.setHasLogin(true);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrasi berhasil! Selamat datang di EcoCoin'),
            backgroundColor: AppColor.emeraldDefault,
          ),
        );

        Navigator.pushReplacementNamed(context, Routes.home);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrasi gagal. Silakan coba lagi.'),
            backgroundColor: AppColor.rubyDefault,
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
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(child: SingleChildScrollView(child: _buildFormCard())),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: AppColor.emeraldDefault,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColor.neutralWhite,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios),
              color: AppColor.neutralBlack,
              iconSize: 20,
            ),
          ),

          const SizedBox(width: 16),

          Text(
            "Daftar Akun",
            style: AppColor.bold.copyWith(
              fontSize: 20,
              color: AppColor.neutralWhite,
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
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.7,
        ),
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
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),

                _buildCardHeader(),

                const SizedBox(height: 24),

                CustomTextFormField(
                  controller: _namaLengkapController,
                  labelText: "Nama Lengkap",
                  hintText: "Masukkan nama lengkap",
                  textCapitalization: TextCapitalization.words,
                  validator: (value) =>
                      Validators.required(value, "Nama lengkap"),
                ),

                const SizedBox(height: 12),

                CustomTextFormField(
                  controller: _namaPanggilanController,
                  labelText: "Nama Panggilan",
                  hintText: "Masukkan nama panggilan",
                  textCapitalization: TextCapitalization.words,
                  validator: (value) =>
                      Validators.required(value, "Nama panggilan"),
                ),

                const SizedBox(height: 12),

                CustomTextFormField(
                  controller: _emailController,
                  labelText: "Email",
                  hintText: "Masukkan email anda",
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),

                const SizedBox(height: 12),

                PasswordFormField(
                  controller: _passwordController,
                  labelText: "Password",
                  hintText: "Masukkan password anda",
                  validator: Validators.password,
                ),

                const SizedBox(height: 12),

                PasswordFormField(
                  controller: _confirmPasswordController,
                  labelText: "Konfirmasi Password",
                  hintText: "Masukkan konfirmasi password",
                  validator: (value) => Validators.confirmPassword(
                    value,
                    _passwordController.text,
                  ),
                ),

                const SizedBox(height: 32),

                PrimaryButton(
                  text: "Daftar Sekarang",
                  onPressed: _handleRegister,
                  isLoading: _isLoading,
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Bergabung Dengan EcoCoin",
          style: AppColor.bold.copyWith(
            fontSize: 24,
            color: AppColor.neutralBlack,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          "Mulai perjalanan ramah lingkungan Anda",
          style: AppColor.regular.copyWith(
            fontSize: 16,
            color: AppColor.neutral40,
          ),
        ),
      ],
    );
  }
}
