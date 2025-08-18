import 'package:flutter/material.dart';
import 'package:mini_world/constants/app_colors.dart';

import 'tabs/store_products_tab.dart';
import 'tabs/store_purchase_history_tab.dart';

class StoreTab extends StatelessWidget {
  const StoreTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: AppColors.accent,
            labelColor: AppColors.accent,
            unselectedLabelColor: Colors.black,
            tabs: [Tab(text: '상품'), Tab(text: '구매내역')],
          ),
          Expanded(
            child: TabBarView(
              children: [StoreProductsTab(), StorePurchaseHistoryTab()],
            ),
          ),
        ],
      ),
    );
  }
}
