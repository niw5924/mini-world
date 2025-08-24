enum StoreProduct {
  loseProtection3('lose_protection_3', '패배 보호권(3회)'),
  winBonus3('win_bonus_3', '승리 보너스(3회)');

  final String key;
  final String label;

  const StoreProduct(this.key, this.label);

  static StoreProduct fromKey(String key) {
    return StoreProduct.values.firstWhere((e) => e.key == key);
  }
}
