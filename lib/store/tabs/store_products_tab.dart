import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mini_world/api/purchase_api.dart';
import 'package:mini_world/api/user_api.dart';
import 'package:mini_world/auth/auth_service.dart';
import 'package:mini_world/constants/store_enums.dart';
import 'package:mini_world/widgets/mini_world_button.dart';
import 'package:mini_world/widgets/rainbow_border.dart';

class StoreProductsTab extends StatefulWidget {
  const StoreProductsTab({super.key});

  @override
  State<StoreProductsTab> createState() => _StoreProductsTabState();
}

class _StoreProductsTabState extends State<StoreProductsTab> {
  final Set<String> _orderedIds = StoreProduct.values.map((e) => e.key).toSet();
  late Future<ProductDetailsResponse> _productFuture;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;

  @override
  void initState() {
    super.initState();
    _productFuture = InAppPurchase.instance.queryProductDetails(_orderedIds);
    _purchaseSub = InAppPurchase.instance.purchaseStream.listen((
      purchases,
    ) async {
      for (final p in purchases) {
        if ((p.status == PurchaseStatus.purchased ||
                p.status == PurchaseStatus.restored) &&
            p.pendingCompletePurchase) {
          try {
            final firebaseUser = AuthService().currentUser!;
            final firebaseIdToken = await AuthService().getIdToken(
              firebaseUser,
            );

            await PurchaseApi.purchase(
              firebaseIdToken: firebaseIdToken,
              productId: p.productID,
            );
            await InAppPurchase.instance.completePurchase(p);
          } catch (e) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('문제가 발생했습니다 ($e)')));
          }
        }
      }
    });
  }

  void _buy(ProductDetails pd) {
    final param = PurchaseParam(productDetails: pd);
    InAppPurchase.instance.buyConsumable(
      purchaseParam: param,
      autoConsume: true,
    );
  }

  Future<Map<String, dynamic>> loadItems() async {
    final firebaseUser = AuthService().currentUser!;
    final firebaseIdToken = await AuthService().getIdToken(firebaseUser);

    return UserApi.items(firebaseIdToken);
  }

  @override
  void dispose() {
    _purchaseSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<Map<String, dynamic>>(
          future: loadItems(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('아이템 불러오기 오류: ${snapshot.error}'));
            }

            final items = snapshot.data!;
            return Container(
              color: Colors.teal,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shield, color: Colors.deepPurple),
                  const SizedBox(width: 4),
                  Text('패배 보호권 X ${items['lose_protection_3']}'),
                  const SizedBox(width: 24),
                  const Icon(Icons.emoji_events, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text('승리 보너스 X ${items['win_bonus_3']}'),
                ],
              ),
            );
          },
        ),
        Expanded(
          child: FutureBuilder<ProductDetailsResponse>(
            future: _productFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('상품 불러오기 오류: ${snapshot.error}'));
              }

              final products = snapshot.data!.productDetails;
              if (products.isEmpty) {
                return const Center(child: Text('표시할 상품이 없습니다.'));
              }

              final ordered =
                  _orderedIds
                      .map((id) => products.where((p) => p.id == id))
                      .expand((e) => e)
                      .toList();
              return ListView.separated(
                padding: const EdgeInsets.all(24),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: ordered.length,
                itemBuilder: (context, index) {
                  final pd = ordered[index];

                  /// pd.title에는 스토어 앱 이름이 함께 붙기 때문에 직접 사용하지 않음
                  final productEnum = StoreProduct.fromKey(pd.id);
                  final displayTitle = productEnum.label;

                  return RainbowBorder(
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      title: Text(displayTitle),
                      subtitle: Text(pd.description),
                      trailing: MiniWorldButton(
                        width: 100,
                        text: pd.price,
                        onPressed: () => _buy(pd),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
