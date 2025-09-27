import 'package:eco_coin/app/helper/shared/app_color.dart';
import 'package:eco_coin/app/helper/shared/widget/local_image.dart';
import 'package:eco_coin/app/helper/shared/widget/shared_text_form_field.dart';
import 'package:eco_coin/app/model/user_model.dart';
import 'package:eco_coin/app/provider/firebase_auth_provider.dart';
import 'package:eco_coin/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaLengkapController = TextEditingController();
  final _namaPanggilanController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentProfileData();
  }

  void _loadCurrentProfileData() {
    final authProvider = context.read<FirebaseAuthProvider>();
    final userModel = authProvider.userModel;

    if (userModel != null) {
      _namaLengkapController.text = userModel.namaLengkap;
      _namaPanggilanController.text = userModel.namaPanggilan;
      _emailController.text = userModel.email;
      _phoneNumberController.text = userModel.phoneNumber ?? '';
      _addressController.text = userModel.address ?? '';
      _bioController.text = userModel.bio ?? '';
    }
  }

  @override
  void dispose() {
    _namaLengkapController.dispose();
    _namaPanggilanController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final namaLengkap = _namaLengkapController.text.trim();
    final namaPanggilan = _namaPanggilanController.text.trim();
    final phoneNumber = _phoneNumberController.text.trim();
    final address = _addressController.text.trim();
    final bio = _bioController.text.trim();

    if (email.isNotEmpty &&
        namaLengkap.isNotEmpty &&
        namaPanggilan.isNotEmpty) {
      final firebaseAuthProvider = context.read<FirebaseAuthProvider>();
      final navigator = Navigator.of(context);
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      final currentUser = firebaseAuthProvider.userModel;
      if (currentUser == null) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Data user tidak ditemukan'),
            backgroundColor: AppColor.rubyDefault,
          ),
        );
        return;
      }

      final updatedUser = UserModel(
        uid: currentUser.uid,
        email: email,
        namaLengkap: namaLengkap,
        namaPanggilan: namaPanggilan,
        phoneNumber: phoneNumber.isNotEmpty ? phoneNumber : null,
        address: address.isNotEmpty ? address : null,
        bio: bio.isNotEmpty ? bio : null,
        createdAt: currentUser.createdAt,
        updatedAt: DateTime.now(),
      );

      final success = await firebaseAuthProvider.updateUserProfile(updatedUser);

      if (success) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Profile berhasil diperbarui!'),
            backgroundColor: AppColor.emeraldDefault,
          ),
        );

        navigator.pushNamedAndRemoveUntil(
          Routes.home,
          (route) => false,
          arguments: {'initialIndex': 3},
        );
      } else {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
              firebaseAuthProvider.message ?? "Update profile gagal",
            ),
            backgroundColor: AppColor.rubyDefault,
          ),
        );
      }
    } else {
      const message = "Lengkapi semua field yang wajib diisi";
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(message),
          backgroundColor: AppColor.rubyDefault,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.emeraldDefault,
        title: Text(
          'Edit Profile',
          style: AppColor.whiteTextStyle.copyWith(fontSize: 18),
        ),
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            color: AppColor.kWhite,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(color: AppColor.emeraldDefault),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        LocalProfileAvatar(radius: 50, imagePath: ''),
                        const SizedBox(height: 36),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(16),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColor.kWhite,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: AppColor.emeraldDefault,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Informasi Pribadi',
                                    style: AppColor.blackTextStyle.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomTextFormField(
                                      controller: _namaLengkapController,
                                      labelText: "Nama Lengkap",
                                      hintText: "Masukkan nama lengkap",
                                      textCapitalization:
                                          TextCapitalization.words,
                                      validator: (value) => Validators.required(
                                        value,
                                        "Nama lengkap",
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    CustomTextFormField(
                                      controller: _namaPanggilanController,
                                      labelText: "Nama Panggilan",
                                      hintText: "Masukkan nama panggilan",
                                      textCapitalization:
                                          TextCapitalization.words,
                                      validator: (value) => Validators.required(
                                        value,
                                        "Nama panggilan",
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    CustomTextFormField(
                                      controller: _emailController,
                                      labelText: "Email",
                                      hintText: "Masukkan email anda",
                                      keyboardType: TextInputType.emailAddress,
                                      validator: Validators.email,
                                      isReadOnly: true,
                                    ),

                                    const SizedBox(height: 12),

                                    CustomTextFormField(
                                      controller: _phoneNumberController,
                                      labelText: "Nomor Telepon",
                                      hintText: "Masukkan nomor telepon",
                                      keyboardType: TextInputType.phone,
                                      prefixText: "+62 ",
                                      validator: Validators.phone,
                                    ),

                                    const SizedBox(height: 12),

                                    CustomTextFormField(
                                      controller: _addressController,
                                      labelText: "Alamat",
                                      hintText: "Masukkan alamat",
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      maxLines: 2,
                                    ),

                                    const SizedBox(height: 12),

                                    CustomTextFormField(
                                      controller: _bioController,
                                      labelText: "Bio",
                                      hintText: "Masukkan bio",
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      maxLines: 3,
                                      maxLength: 100,
                                      validator: Validators.bio,
                                    ),

                                    const SizedBox(height: 12),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _handleUpdateProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.emeraldDefault,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.save, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Simpan Perubahan',
                    style: AppColor.whiteTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
