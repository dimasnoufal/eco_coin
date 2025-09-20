import 'package:eco_coin/app/helper/shared/app_color.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileContainer(),
            FastActionContainer(),
            RecycleCategoryContainer(),
          ],
        ),
      ),
    );
  }
}

class ProfileContainer extends StatelessWidget {
  const ProfileContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: AppColor.emeraldDefault),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColor.kInfoBoxColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        'A',
                        style: AppColor.blackTextStyle.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selamat datang,',
                        style: TextStyle(
                          color: AppColor.kGrey2,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Dimasnoufal',
                        style: AppColor.whiteTextStyle.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: AppColor.emeraldBgLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Total EcoCoins',
                            style: AppColor.greyTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/ic_coins_yellow.png',
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '1.250',
                                style: AppColor.blackTextStyle.copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
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
                            style: AppColor.greyTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.recycling,
                                color: AppColor.kSuccessColor,
                                size: 24,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '1.250',
                                style: AppColor.blackTextStyle.copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
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
              style: AppColor.blackTextStyle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Material(
                    color: AppColor.emeraldDefault,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () {
                        // Navigate to the scan screen
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        width: 175,
                        height: 95,
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
                            const SizedBox(height: 4),
                            Text(
                              'Scan Sampah',
                              style: AppColor.whiteTextStyle.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
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
                    color: AppColor.kWhite,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () {
                        // Navigate to the rewards screen
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        width: 175,
                        height: 95,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColor.emeraldDefault),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/ic_gift_outline_green.png',
                              width: 32,
                              height: 32,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tukar Reward',
                              style: TextStyle(
                                color: AppColor.kPrimaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
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
  const RecycleCategoryContainer({super.key});

  Widget _recycleCategoryItem({
    required String imgPath,
    required Color colorBg,
    required String title,
    required String amountTotal,
  }) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColor.kWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(shape: BoxShape.circle, color: colorBg),
            child: Center(child: Image.asset(imgPath, width: 24, height: 24)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppColor.blackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  amountTotal,
                  style: AppColor.greyTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
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
              style: AppColor.blackTextStyle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
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
              childAspectRatio: 1.8,
              children: [
                _recycleCategoryItem(
                  imgPath: 'assets/images/ic_bottle.png',
                  colorBg: AppColor.kBlueInfo.withOpacity(0.2),
                  title: 'Plastik',
                  amountTotal: 'Total: 1.250',
                ),
                _recycleCategoryItem(
                  imgPath: 'assets/images/ic_paper.png',
                  colorBg: AppColor.orangeLight.withOpacity(0.2),
                  title: 'Kertas',
                  amountTotal: 'Total: 1.250',
                ),
                _recycleCategoryItem(
                  imgPath: 'assets/images/ic_metal.png',
                  colorBg: AppColor.kInfoBoxColor,
                  title: 'Logam',
                  amountTotal: 'Total: 1.250',
                ),
                _recycleCategoryItem(
                  imgPath: 'assets/images/ic_glass.png',
                  colorBg: AppColor.kTeal.withOpacity(0.2),
                  title: 'Kaca',
                  amountTotal: 'Total: 1.250',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
