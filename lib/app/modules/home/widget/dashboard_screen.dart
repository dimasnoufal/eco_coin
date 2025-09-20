import 'package:eco_coin/app/helper/shared/app_color.dart';
import 'package:eco_coin/app/helper/shared/common_utils.dart';
import 'package:eco_coin/app/helper/shared/widget/local_image.dart';
import 'package:eco_coin/app/modules/home/provider/home_provider.dart';
import 'package:eco_coin/app/provider/firebase_auth_provider.dart';
import 'package:eco_coin/app/services/waste_detection_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final WasteDetectionService _wasteDetectionService = WasteDetectionService();

  Map<String, int> _categoryStats = {
    'organik': 0,
    'anorganik': 0,
    'residu': 0,
    'b3': 0,
    'elektronik': 0,
  };

  int _totalEcoCoins = 0;
  int _totalRecycledWaste = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final authProvider = context.read<FirebaseAuthProvider>();
    if (authProvider.user != null) {
      await authProvider.updateProfile();

      await _loadWasteStats(authProvider.user!.uid);
    }

    setState(() => _isLoading = false);
  }

  Future<void> _loadWasteStats(String userId) async {
    try {
      final stats = await _wasteDetectionService.getUserWasteStats(userId);

      if (mounted) {
        setState(() {
          _totalEcoCoins = stats.totalEcoCoins;
          _totalRecycledWaste = stats.totalRecycledWaste;
          _categoryStats = stats.categoryCount;
        });
      }
    } catch (e) {
      try {
        final categoryCount = await _wasteDetectionService
            .getCategoryCountStats(userId);
        final hasData = await _wasteDetectionService.hasWasteData(userId);

        if (mounted) {
          setState(() {
            _totalEcoCoins = 0;
            _totalRecycledWaste = hasData
                ? categoryCount.values.fold(0, (a, b) => a + b)
                : 0;
            _categoryStats = categoryCount;
          });
        }
      } catch (fallbackError) {
        if (mounted) {
          setState(() {
            _totalEcoCoins = 0;
            _totalRecycledWaste = 0;
            _categoryStats = {
              'organik': 0,
              'anorganik': 0,
              'residu': 0,
              'b3': 0,
              'elektronik': 0,
            };
          });

          if (!fallbackError.toString().contains('tidak ditemukan')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Gagal memuat data: $fallbackError'),
                backgroundColor: AppColor.rubyDefault,
              ),
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              ProfileContainer(
                totalEcoCoins: _totalEcoCoins,
                totalRecycledWaste: _totalRecycledWaste,
                isLoading: _isLoading,
              ),
              const FastActionContainer(),
              RecycleCategoryContainer(categoryStats: _categoryStats),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileContainer extends StatelessWidget {
  final int totalEcoCoins;
  final int totalRecycledWaste;
  final bool isLoading;

  const ProfileContainer({
    super.key,
    required this.totalEcoCoins,
    required this.totalRecycledWaste,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: AppColor.emeraldDefault),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Consumer<FirebaseAuthProvider>(
            builder: (context, authProvider, child) {
              final user = authProvider.userModel;
              final firstLetter = (user?.namaLengkap?.isNotEmpty == true)
                  ? user!.namaLengkap![0].toUpperCase()
                  : 'U';

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColor.neutralWhite.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child:
                            user?.profileImageUrl != null &&
                                user!.profileImageUrl!.isNotEmpty
                            ? ClipOval(
                                child: LocalImageWidget(
                                  imagePath: user.profileImageUrl,
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Center(
                                child: Text(
                                  firstLetter,
                                  style: AppColor.bold.copyWith(
                                    fontSize: 20,
                                    color: AppColor.neutralBlack,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selamat datang,',
                              style: AppColor.regular.copyWith(
                                color: AppColor.neutralWhite.withOpacity(0.8),
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              user?.namaLengkap ?? 'User',
                              style: AppColor.bold.copyWith(
                                fontSize: 18,
                                color: AppColor.neutralWhite,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: AppColor.neutral30,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: isLoading
                        ? const Center(
                            child: SizedBox(
                              height: 60,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Total EcoCoins',
                                      style: AppColor.regular.copyWith(
                                        fontSize: 14,
                                        color: AppColor.neutralWhite
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/ic_coins_yellow.png",
                                          width: 32,
                                          height: 32,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          totalEcoCoins.toString(),
                                          style: AppColor.bold.copyWith(
                                            fontSize: 24,
                                            color: AppColor.neutralWhite,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Sampah Didaur Ulang',
                                      style: AppColor.regular.copyWith(
                                        fontSize: 14,
                                        color: AppColor.neutralWhite
                                            .withOpacity(0.8),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/ic_recycler_green.png',
                                          width: 32,
                                          height: 32,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          totalRecycledWaste.toString(),
                                          style: AppColor.bold.copyWith(
                                            fontSize: 24,
                                            color: AppColor.neutralWhite,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class FastActionContainer extends StatelessWidget {
  const FastActionContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aksi Cepat',
              style: AppColor.bold.copyWith(
                fontSize: 18,
                color: AppColor.neutralBlack,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Material(
                    color: AppColor.emeraldDefault,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () {
                        final homeProvider = context.read<HomeProvider>();
                        homeProvider.currentIndex = 1;
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/ic_camera_outline_white.png',
                              width: 32,
                              height: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Scan Sampah',
                              style: AppColor.semibold.copyWith(
                                fontSize: 16,
                                color: AppColor.neutralWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Material(
                    color: AppColor.neutralWhite,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () => CommonUtils.showComingSoonSnackBar(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColor.emeraldDefault,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/ic_gift_outline_green.png',
                              width: 32,
                              height: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tukar Reward',
                              style: AppColor.semibold.copyWith(
                                fontSize: 16,
                                color: AppColor.emeraldDefault,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RecycleCategoryContainer extends StatelessWidget {
  final Map<String, int> categoryStats;

  const RecycleCategoryContainer({super.key, required this.categoryStats});

  Widget _recycleCategoryItem({
    required String imagePath,
    required Color backgroundColor,
    required String title,
    required int itemCount,
  }) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColor.neutralWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                imagePath,
                width: 52,
                height: 52,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppColor.semibold.copyWith(
                    fontSize: 14,
                    color: AppColor.neutralBlack,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$itemCount Item',
                  style: AppColor.regular.copyWith(
                    fontSize: 12,
                    color: AppColor.neutral40,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kategori Daur Ulang',
              style: AppColor.bold.copyWith(
                fontSize: 18,
                color: AppColor.neutralBlack,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
              children: [
                _recycleCategoryItem(
                  imagePath: 'assets/images/ic_organic.png',
                  backgroundColor: Colors.green.withOpacity(0.1),
                  title: 'Organik',
                  itemCount: categoryStats['organik'] ?? 0,
                ),
                _recycleCategoryItem(
                  imagePath: 'assets/images/ic_recycler_green.png',
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  title: 'Anorganik',
                  itemCount: categoryStats['anorganik'] ?? 0,
                ),
                _recycleCategoryItem(
                  imagePath: 'assets/images/ic_residu.png',
                  backgroundColor: Colors.brown.withOpacity(0.1),
                  title: 'Residu',
                  itemCount: categoryStats['residu'] ?? 0,
                ),
                _recycleCategoryItem(
                  imagePath: 'assets/images/ic_hazard.png',
                  backgroundColor: Colors.orange.withOpacity(0.1),
                  title: 'B3',
                  itemCount: categoryStats['b3'] ?? 0,
                ),
                _recycleCategoryItem(
                  imagePath: 'assets/images/ic_electronic.png',
                  backgroundColor: Colors.purple.withOpacity(0.1),
                  title: 'Elektronik',
                  itemCount: categoryStats['elektronik'] ?? 0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
