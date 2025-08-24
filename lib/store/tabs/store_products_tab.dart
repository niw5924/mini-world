import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mini_world/api/purchase_api.dart';
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

  @override
  void dispose() {
    _purchaseSub?.cancel();
    super.dispose();
  }

  void _buy(ProductDetails pd) {
    final param = PurchaseParam(productDetails: pd);
    InAppPurchase.instance.buyConsumable(
      purchaseParam: param,
      autoConsume: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProductDetailsResponse>(
      future: _productFuture,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('상품 불러오기 실패\n${snap.error}'));
        }
        final products = snap.data!.productDetails;
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
            final displayTitle =
                pd.title.replaceAll(' (Mini World: 1v1 Battle)', '').trim();

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
    );
  }
}
