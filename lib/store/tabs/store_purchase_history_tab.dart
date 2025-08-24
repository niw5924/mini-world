import 'package:flutter/material.dart';
import 'package:mini_world/api/user_api.dart';
import 'package:mini_world/auth/auth_service.dart';
import 'package:mini_world/constants/app_colors.dart';
import 'package:mini_world/constants/store_enums.dart';
import 'package:mini_world/utils/datetime_utils.dart';

class StorePurchaseHistoryTab extends StatefulWidget {
  const StorePurchaseHistoryTab({super.key});

  @override
  State<StorePurchaseHistoryTab> createState() =>
      _StorePurchaseHistoryTabState();
}

class _StorePurchaseHistoryTabState extends State<StorePurchaseHistoryTab> {
  String? error;
  bool isLoading = true;

  List<Map<String, dynamic>> myPurchaseHistory = [];

  @override
  void initState() {
    super.initState();
    loadPurchaseHistory();
  }

  Future<void> loadPurchaseHistory() async {
    setState(() {
      error = null;
      isLoading = true;
    });

    try {
      final firebaseUser = AuthService().currentUser!;
      final firebaseIdToken = await AuthService().getIdToken(firebaseUser);

      final myData = await UserApi.purchaseHistory(firebaseIdToken);

      setState(() {
        isLoading = false;
        myPurchaseHistory = myData;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Widget _buildPurchaseTile(Map<String, dynamic> record) {
    final productId = record['product_id'];
    final purchaseTime = record['purchase_time'];
    final product = StoreProduct.fromKey(productId);

    return Card(
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        title: Text(
          product.label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('구매일시: ${DateTimeUtils.format(purchaseTime)}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Center(child: Text('에러: $error'));
    }

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (myPurchaseHistory.isEmpty) {
      return const Center(child: Text('구매 기록이 없습니다.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: myPurchaseHistory.length,
      itemBuilder: (context, index) {
        return _buildPurchaseTile(myPurchaseHistory[index]);
      },
    );
  }
}
