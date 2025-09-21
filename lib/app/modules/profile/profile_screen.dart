import 'package:eco_coin/app/helper/firebase_auth_status.dart';
import 'package:eco_coin/app/helper/shared/app_color.dart';
import 'package:eco_coin/app/helper/shared/common_utils.dart';
import 'package:eco_coin/app/provider/firebase_auth_provider.dart';
import 'package:eco_coin/app/provider/shared_pref_provider.dart';
import 'package:eco_coin/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.emeraldDefault,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 4),
                decoration: const BoxDecoration(
                  color: AppColor.neutralWhite,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: _buildContent(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Consumer<FirebaseAuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.userModel;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                "Profile Saya",
                style: AppColor.bold.copyWith(
                  fontSize: 20,
                  color: AppColor.neutralWhite,
                ),
              ),

              const SizedBox(height: 24),

              LocalProfileAvatar(
                radius: 50,
                onTap: () {
                  Navigator.pushNamed(context, Routes.editProfile);
                },
              ),

              const SizedBox(height: 4),

              Text(
                user?.namaLengkap ?? 'User',
                style: AppColor.whiteTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                user?.email ?? '',
                style: AppColor.regular.copyWith(
                  fontSize: 14,
                  color: AppColor.neutralWhite,
                ),
              ),

              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColor.neutralWhite.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: AppColor.neutralWhite.withOpacity(0.8),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Bergabung ${_formatJoinDate(user?.createdAt)}",
                      style: AppColor.medium.copyWith(
                        fontSize: 14,
                        color: AppColor.neutralBlack,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 12.0),
      child: Column(
        children: [
          _buildMenuItem(
            context,
            imagePath: 'assets/images/ic_pencil_grey.png',
            title: "Edit Profile",
            subtitle: "Ubah informasi pribadi",
            onTap: () => Navigator.pushNamed(context, Routes.editProfile),
          ),

          _buildMenuItem(
            context,
            imagePath: 'assets/images/ic_coins_grey.png',
            title: "Tukar Koin",
            subtitle: "Tukar EcoCoin dengan reward",
            onTap: () => CommonUtils.showComingSoonSnackBar(context),
          ),

          _buildMenuItem(
            context,
            imagePath: 'assets/images/ic_teams_grey.png',
            title: "Gabung dengan Komunitas",
            subtitle: "Bergabung dengan komunitas eco-friendly",
            onTap: () => CommonUtils.launchCommunityWebsite(context),
          ),

          _buildMenuItem(
            context,
            imagePath: 'assets/images/ic_history_grey.png',
            title: "History",
            subtitle: "Lihat riwayat aktivitas sebelumnya",
            onTap: () => Navigator.pushNamed(context, Routes.history),
            showDivider: false,
          ),

          const SizedBox(height: 40),

          // Logout Button
          _buildLogoutButton(context),

          const SizedBox(height: 16),

          // App Version
          Text(
            "EcoCoin v.1.0.0",
            style: AppColor.regular.copyWith(
              fontSize: 14,
              color: AppColor.neutral40,
            ),
          ),

          const SizedBox(height: 40), // Extra bottom padding for safety
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String imagePath,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColor.neutral10,
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Image.asset(imagePath, width: 24, height: 24),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppColor.semibold.copyWith(
                          fontSize: 16,
                          color: AppColor.neutralBlack,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: AppColor.regular.copyWith(
                          fontSize: 14,
                          color: AppColor.neutral40,
                        ),
                      ),
                    ],
                  ),
                ),

                Icon(Icons.chevron_right, color: AppColor.neutral40, size: 24),
              ],
            ),
          ),
        ),

        if (showDivider)
          Divider(height: 1, color: AppColor.neutral20, indent: 64),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Consumer2<FirebaseAuthProvider, SharedPrefProvider>(
      builder: (context, authProvider, sharedPrefProvider, child) {
        return InkWell(
          onTap: () => _handleLogout(context, authProvider, sharedPrefProvider),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.rubyDefault),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, color: AppColor.rubyDefault, size: 20),
                const SizedBox(width: 8),
                Text(
                  authProvider.authStatus == FirebaseAuthStatus.signingOut
                      ? "Keluar..."
                      : "Keluar",
                  style: AppColor.semibold.copyWith(
                    fontSize: 16,
                    color: AppColor.rubyDefault,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleLogout(
    BuildContext context,
    FirebaseAuthProvider authProvider,
    SharedPrefProvider sharedPrefProvider,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColor.rubyDefault),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await sharedPrefProvider.setHasLogin(false);

      await authProvider.signOutUser();

      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.login,
          (route) => false,
        );
      }
    }
  }

  String _formatJoinDate(DateTime? date) {
    if (date == null) return 'Tanggal tidak diketahui';

    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${months[date.month - 1]} ${date.year}';
  }
}

class LocalProfileAvatar extends StatelessWidget {
  final double radius;
  final VoidCallback? onTap;

  const LocalProfileAvatar({super.key, this.radius = 50, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Consumer<FirebaseAuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.userModel;
          final firstLetter = (user?.namaLengkap?.isNotEmpty == true)
              ? user!.namaLengkap![0].toUpperCase()
              : 'U';

          return CircleAvatar(
            radius: radius,
            backgroundColor: AppColor.neutral20,
            child: Text(
              firstLetter,
              style: AppColor.bold.copyWith(
                fontSize: radius * 0.6,
                color: AppColor.neutralBlack,
              ),
            ),
          );
        },
      ),
    );
  }
}
