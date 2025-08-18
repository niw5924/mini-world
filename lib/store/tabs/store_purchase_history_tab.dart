import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mini_world/api/user_api.dart';
import 'package:mini_world/auth/auth_service.dart';
import 'package:mini_world/constants/app_colors.dart';

class StorePurchaseHistoryTab extends StatefulWidget {
  const StorePurchaseHistoryTab({super.key});

  @override
  State<StorePurchaseHistoryTab> createState() =>
      _StorePurchaseHistoryTabState();
}

class _StorePurchaseHistoryTabState extends State<StorePurchaseHistoryTab> {
  List<Map<String, dynamic>> myPurchaseHistory = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadPurchaseHistory();
  }

  Future<void> loadPurchaseHistory() async {
    try {
      final firebaseUser = AuthService().currentUser!;
      final firebaseIdToken = await AuthService().getIdToken(firebaseUser);
      final myData = await UserApi.purchaseHistory(firebaseIdToken);
      setState(() {
        myPurchaseHistory = myData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Widget _buildPurchaseTile(Map<String, dynamic> record) {
    final formattedTime = DateFormat(
      'yyyy-MM-dd HH:mm',
    ).format(DateTime.parse(record['purchase_time']).toLocal());
    final productId = record['product_id'];

    return Card(
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          productId,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('구매일시: $formattedTime'),
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

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: myPurchaseHistory.length,
      itemBuilder: (context, index) {
        return _buildPurchaseTile(myPurchaseHistory[index]);
      },
    );
  }
}
