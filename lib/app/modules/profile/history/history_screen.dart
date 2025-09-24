import 'package:eco_coin/app/helper/shared/app_color.dart';
// import 'package:eco_coin/app/helper/shared/logger.dart';
import 'package:eco_coin/app/provider/local_database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Widget _headerItemRow(String title, String value, String imgPath) {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8),
      padding: const EdgeInsets.all(16),
      height: 100,
      decoration: BoxDecoration(
        color: AppColor.kWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.kSoftBlack.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                value,
                style: AppColor.greyTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const Spacer(),
          Image.asset(imgPath, width: 40, height: 40),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<LocalDatabaseProvider>().loadAllWasteRecycling();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.emeraldDefault,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'History Recycling',
          style: AppColor.whiteTextStyle.copyWith(fontSize: 18),
        ),
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            color: AppColor.kWhite,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColor.kSoftBlack),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(color: AppColor.emeraldDefault),
            child: Row(
              children: [
                Expanded(
                  child: _headerItemRow(
                    'Total Points',
                    '${context.watch<LocalDatabaseProvider>().totalPoints} Points',
                    "assets/images/ic_coins_yellow.png",
                  ),
                ),
                Expanded(
                  child: _headerItemRow(
                    'Total Items',
                    '${context.watch<LocalDatabaseProvider>().totalItems} Items',
                    "assets/images/ic_recycler_green.png",
                  ),
                ),
              ],
            ),
          ),
          Consumer<LocalDatabaseProvider>(
            builder: (context, value, child) {
              final historyItems = value.itemsList;
              if (historyItems != null) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColor.kWhite,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.kSoftBlack.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            // printInfo('${historyItems[index].image}');
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.memory(
                                          historyItems[index].image,
                                          fit: BoxFit.cover,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Preview Gambar",
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleMedium,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text("Tutup"),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          leading: CircleAvatar(
                            backgroundColor: AppColor.emeraldLight,
                            child: Icon(
                              Icons.recycling,
                              color: AppColor.emeraldDefault,
                            ),
                          ),
                          title: Text(
                            historyItems![index].categoryName,
                            style: AppColor.blackTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            historyItems[index].date,
                            style: AppColor.greyTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          trailing: Text(
                            '+${historyItems[index].ecoPoints} Points',
                            style: TextStyle(
                              color: AppColor.emeraldDefault,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                      itemCount: historyItems?.length ?? 0,
                    ),
                  ),
                );
              } else {
                return Expanded(
                  child: Center(
                    child: Text(
                      'No history available',
                      style: AppColor.greyTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
