import 'package:flutter_study/shrine/model/product.dart';
import 'package:flutter_study/shrine/model/products_repository.dart';
import 'package:scoped_model/scoped_model.dart';

double _salesTaxRate = 0.06;
double _shippingCostPerItem = 7.0;

class AppStateModel extends Model {
  List<Product> _availableProducts;
  Category _selectedCategory = Category.all;

  final Map<int, int> _productsInCart = <int, int>{};

  Map<int, int> get productsInCart => Map<int, int>.from(productsInCart);

  int get totalCartQuantity =>
      _productsInCart.values.fold(0, (int v, int e) => v + e);

  Category get selectedCategory => _selectedCategory;

  double get subtotalCost {
    return _productsInCart.keys
        .map((int id) => _availableProducts[id].price * _productsInCart[id])
        .fold(0.0, (double sum, int e) => sum + e);
  }

  double get shippingCost {
    return _shippingCostPerItem *
        _productsInCart.values.fold(0.0, (num sum, int e) => sum + e);
  }

  double get tax => subtotalCost * _salesTaxRate;

  double get totalCost => subtotalCost + shippingCost + tax;

  List<Product> getProducts() {
    if (_availableProducts == null) {
      return <Product>[];
    }
    if (_selectedCategory == Category.all) {
      return List<Product>.from(_availableProducts);
    } else {
      return _availableProducts
          .where((Product p) => p.category == _selectedCategory)
          .toList();
    }
  }

  void addProductToCart(int productId) {
    if (!_productsInCart.containsKey(productId)) {
      _productsInCart[productId] = 1;
    } else {
      _productsInCart[productId]++;
    }
    notifyListeners();
  }

  void removeItemFromCart(int productId) {
    if (_productsInCart.containsKey(productId)) {
      if (_productsInCart[productId] == 1) {
        _productsInCart.remove(productId);
      } else {
        _productsInCart[productId]--;
      }
    }
    notifyListeners();
  }

  Product getProductById(int id) {
    return _availableProducts.firstWhere((Product p) => p.id == id);
  }

  void clearCart() {
    _productsInCart.clear();
    notifyListeners();
  }

  void loadProducts() {
    _availableProducts = ProductsRepository.loadProducts(Category.all);
    notifyListeners();
  }

  void setCategory(Category newCategory) {
    _selectedCategory = newCategory;
    notifyListeners();
  }

  @override
  String toString() {
    return "AppStateModel (totalCost:$totalCost)";
  }
}
