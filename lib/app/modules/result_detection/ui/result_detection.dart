import 'dart:io';
import 'dart:typed_data';
import 'package:eco_coin/app/data/models/recycling_item.dart';
import 'package:eco_coin/app/helper/shared/app_color.dart';
import 'package:eco_coin/app/helper/shared/dialogs.dart';
import 'package:eco_coin/app/helper/shared/logger.dart';
import 'package:eco_coin/app/modules/home/provider/home_provider.dart';
import 'package:eco_coin/app/modules/home/provider/image_classification_provider.dart';
import 'package:eco_coin/app/provider/local_database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultDetection extends StatefulWidget {
  final Map<String, dynamic>? arguments;

  const ResultDetection({super.key, this.arguments});

  @override
  State<ResultDetection> createState() => _ResultDetectionState();
}

class _ResultDetectionState extends State<ResultDetection> {
  String? _imagePath;
  String? strDate;

  @override
  void initState() {
    super.initState();

    _imagePath = widget.arguments?['imagePath'] as String?;

    printInfo('Image path received: $_imagePath');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ImageClassificationProvider>();
      if (_imagePath != null && _imagePath!.isNotEmpty) {
        provider.runClassificationFromFile(_imagePath!);
      }
    });
  }

  Widget _itemErrorTips(String tittle, String description) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColor.kGrey2.withOpacity(0.3),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tittle,
            style: AppColor.blackTextStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(description),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageClassificationProvider>(
      builder: (context, provider, _) {
        if (provider.classifications.isEmpty && provider.status) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColor.emeraldDefault,
              title: Text(
                'Hasil Deteksi',
                style: AppColor.whiteTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  color: AppColor.kWhite,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      context.read<HomeProvider>().currentIndex = 0;
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColor.kSoftBlack,
                    ),
                  ),
                ),
              ),
            ),
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColor.emeraldDefault,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text('Memproses deteksi...'),
                ],
              ),
            ),
          );
        }

        if (provider.classifications.isNotEmpty && provider.status) {
          final confidencePercentage =
              (provider.classifications.entries.first.value * 100)
                  .toStringAsFixed(1);

          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColor.emeraldDefault,
              title: Text(
                'Hasil Deteksi',
                style: AppColor.whiteTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  color: AppColor.kWhite,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      context.read<HomeProvider>().currentIndex = 0;
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColor.kSoftBlack,
                    ),
                  ),
                ),
              ),
            ),
            body: Column(
              children: [
                Container(
                  height: 110,
                  decoration: BoxDecoration(color: AppColor.emeraldDefault),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.emeraldBgLight.withOpacity(0.5),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(36),
                        ),
                      ),
                      child: IntrinsicWidth(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 32,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Deteksi Berhasil',
                              style: AppColor.whiteTextStyle.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColor.kWhite,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            'Sampah Terdeteksi',
                            style: AppColor.blackTextStyle.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),

                          Text(
                            provider.classifications.entries.first.key
                                .toString(),
                            textAlign: TextAlign.center,
                            style: AppColor.blackTextStyle.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColor.emeraldDefault,
                            ),
                          ),
                          const SizedBox(height: 4),

                          Text(
                            'Confidence: $confidencePercentage%',
                            style: AppColor.greyTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 16),

                          Container(
                            height: 250,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                              color: AppColor.kGrey2.withOpacity(0.3),
                              border: Border.all(
                                color: AppColor.kGrey2.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: _imagePath != null
                                ? ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    child: Image.file(
                                      File(_imagePath!),
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.image_not_supported,
                                                    size: 48,
                                                    color: AppColor.kGrey2,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    'Gambar tidak dapat dimuat',
                                                    style:
                                                        AppColor.greyTextStyle,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                    ),
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.image,
                                          size: 48,
                                          color: AppColor.kGrey2,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Tidak ada gambar',
                                          style: AppColor.greyTextStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 24),

                          Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: AppColor.kGrey2.withOpacity(0.5),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundColor: AppColor.kInfoBoxColor,
                                        backgroundImage: const AssetImage(
                                          'assets/images/ic_glass.png',
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Kategori: ${provider.classifications.entries.first.key.trim()}',
                                              style: AppColor.blackTextStyle
                                                  .copyWith(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              _hintFromLabel(
                                                provider
                                                    .classifications
                                                    .entries
                                                    .first
                                                    .key,
                                              ),
                                              style: AppColor.greyTextStyle
                                                  .copyWith(fontSize: 12),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: AppColor.kGrey.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8.0,
                                            ),
                                            child: Text.rich(
                                              TextSpan(
                                                text: 'Rewards EcoCoin ',
                                                style: AppColor.blackTextStyle,
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '+' +
                                                        _rewardFromLabel(
                                                          provider
                                                              .classifications
                                                              .entries
                                                              .first
                                                              .key,
                                                        ).toString(),
                                                    style: TextStyle(
                                                      color: AppColor
                                                          .emeraldDefault,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8.0),

                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColor.kInfoColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month_outlined,
                                    color: AppColor.kBlueInfo,
                                  ),
                                  const SizedBox(width: 8.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Tanggal Deteksi',
                                        style: AppColor.blackTextStyle.copyWith(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        _formatNow(),
                                        style: AppColor.blackTextStyle.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),

                          Consumer<LocalDatabaseProvider>(
                            builder: (context, dbProvider, _) {
                              return ElevatedButton(
                                onPressed: () async {
                                  strDate = _formatNow();
                                  if (_imagePath != null) {
                                    Uint8List imageBytes =
                                        await imagePathToUint8List(_imagePath!);

                                    await context
                                        .read<LocalDatabaseProvider>()
                                        .doWasteRecycling(
                                          RecyclingItem(
                                            categoryName: provider
                                                .classifications
                                                .entries
                                                .first
                                                .key,
                                            confidence: confidencePercentage,
                                            image: imageBytes,
                                            date: strDate!,
                                            ecoPoints: _rewardFromLabel(
                                              provider
                                                  .classifications
                                                  .entries
                                                  .first
                                                  .key,
                                            ),
                                          ),
                                        );

                                    // ✅ Status akan otomatis ter-update karena Consumer
                                    if (dbProvider.status) {
                                      await Dialogs.showSuccessDialog(
                                        context: context,
                                        category: provider
                                            .classifications
                                            .entries
                                            .first
                                            .key
                                            .toString(),
                                        ecoCoins:
                                            '${_rewardFromLabel(provider.classifications.entries.first.key)}',
                                        onBackToHome: () {
                                          Navigator.popUntil(
                                            context,
                                            (route) => route.isFirst,
                                          );
                                          context
                                                  .read<HomeProvider>()
                                                  .currentIndex =
                                              0;
                                        },
                                      );
                                    } else {
                                      // ✅ Tampilkan error message jika gagal
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(dbProvider.message),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.emeraldDefault,
                                  minimumSize: const Size.fromHeight(48),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Daur Ulang Sampah',
                                  style: AppColor.whiteTextStyle.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (provider.classifications.isEmpty && !provider.status) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColor.rubyDefault,
              title: Text(
                'Hasil Deteksi',
                style: AppColor.whiteTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  color: AppColor.kWhite,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      context.read<HomeProvider>().currentIndex = 0;
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColor.kSoftBlack,
                    ),
                  ),
                ),
              ),
            ),
            body: Column(
              children: [
                Container(
                  height: 110,
                  decoration: BoxDecoration(color: AppColor.rubyDefault),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.emeraldBgLight.withOpacity(0.5),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(36),
                        ),
                      ),
                      child: IntrinsicWidth(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 32,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Deteksi Tidak Berhasil',
                              style: AppColor.whiteTextStyle.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColor.kWhite,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            'Tips agar terdeteksi berhasil',
                            style: AppColor.blackTextStyle.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),

                          _itemErrorTips(
                            'Pencahayaan yang baik',
                            'Pastikan ada cukup cahaya saat mengambil foto',
                          ),

                          const SizedBox(height: 8),

                          _itemErrorTips(
                            'Jarak yang Tepat',
                            'Letakkan sampah 20-30 cm dari kamera anda',
                          ),

                          const SizedBox(height: 8),

                          _itemErrorTips(
                            'Fokus pada objek',
                            'Pastikan sampah berada di tengah frame',
                          ),

                          const SizedBox(height: 8),

                          _itemErrorTips(
                            'Latar belakang bersih',
                            'Gunakan latar belakang yang kontras dan bersih agar sampah terlihat',
                          ),

                          const Spacer(),

                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.emeraldDefault,
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Coba Scan Lagi',
                              style: AppColor.whiteTextStyle.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              context.read<HomeProvider>().currentIndex = 0;
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.kGrey2,
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              side: BorderSide(color: AppColor.kSoftBlack),
                            ),
                            child: Text(
                              'Kembali ke Beranda',
                              style: AppColor.blackTextStyle.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColor.emeraldDefault,
            title: Text(
              'Hasil Deteksi',
              style: AppColor.whiteTextStyle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                color: AppColor.kWhite,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    context.read<HomeProvider>().currentIndex = 0;
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColor.kSoftBlack,
                  ),
                ),
              ),
            ),
          ),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColor.emeraldDefault,
                  ),
                ),
                SizedBox(height: 16),
                Text('Memproses deteksi...'),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatNow() {
    final now = DateTime.now();
    const bulan = [
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
    final jam = now.hour.toString().padLeft(2, '0');
    final menit = now.minute.toString().padLeft(2, '0');
    return '${now.day} ${bulan[now.month - 1]} ${now.year}, $jam:$menit';
  }

  String _hintFromLabel(String? label) {
    final cat = label?.trim() ?? '';
    printInfo('Determined category: $cat from label: $label');
    switch (cat) {
      case 'Sampah B3':
        return 'Plastik tertentu dapat didaur ulang, bersihkan terlebih dahulu.';
      case 'Sampah Elektronik':
        return 'Pisahkan kaca bening & berwarna, hati-hati pecahan.';
      case 'Sampah Residu':
        return 'Kertas kering & bersih lebih mudah didaur ulang.';
      case 'Sampah Anorganik':
        return 'Kaleng & aluminium bernilai tinggi untuk daur ulang.';
      case 'Sampah Organik':
        return 'Limbah organik perlu dibawa ke drop-point khusus.';
      default:
        return 'Ikuti panduan bank sampah setempat.';
    }
  }

  int _rewardFromLabel(String? label) {
    final cat = label?.trim() ?? '';
    switch (cat) {
      case 'Sampah B3':
        return 50;
      case 'Sampah Elektronik':
        return 40;
      case 'Sampah Residu':
        return 30;
      case 'Sampah Anorganik':
        return 15;
      case 'Sampah Organik':
        return 5;
      default:
        return 5;
    }
  }

  Future<Uint8List> imagePathToUint8List(String imagePath) async {
    final file = File(imagePath);
    return await file.readAsBytes();
  }
}
