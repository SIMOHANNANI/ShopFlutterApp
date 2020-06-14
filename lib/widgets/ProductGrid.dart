import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/product_item.dart';
import '../providers/products_provider.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavoriteOnly;
  ProductGrid(this.showFavoriteOnly);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductsProvider>(context);
    final loadedProducts = showFavoriteOnly ? productData.favoriteProducts : productData.products;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: loadedProducts.length,
      itemBuilder: (context, item) => ChangeNotifierProvider.value(
        value: loadedProducts[item],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0),
    );
  }
}