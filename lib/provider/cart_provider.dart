import 'package:flutter/material.dart';
import 'package:eproject_watchub/data/model/response/cart_model.dart';
import 'package:eproject_watchub/data/repository/cart_repo.dart';
import 'package:eproject_watchub/localization/app_localization.dart';
import 'package:eproject_watchub/view/base/custom_snackbar.dart';
class CartProvider extends ChangeNotifier {
  final CartRepo? cartRepo;
  CartProvider({required this.cartRepo});

  int _productSelect = 0;
  int get productSelect => _productSelect;



  void setSelect(int select, bool isNotify){
    _productSelect = select;
    if(isNotify) {
      notifyListeners();
    }
  }

  List<CartModel> _cartList = [];
  double _amount = 0.0;

  List<CartModel> get cartList => _cartList;
  double get amount => _amount;

  void getCartData({bool isUpdate = false}) {
    _cartList = [];
    _amount = 0.0;
    _cartList.addAll(cartRepo!.getCartList());
    for (var cart in _cartList) {
      _amount = _amount + (cart.discountedPrice! * cart.quantity!);
    }
    if(isUpdate){
      notifyListeners();
    }

  }

  void addToCart(CartModel cartModel) {
    _cartList.add(cartModel);
    cartRepo!.addToCartList(_cartList);
    _amount = _amount + (cartModel.discountedPrice! * cartModel.quantity!);
    notifyListeners();
  }

  void setQuantity(bool isIncrement, int? index, {bool showMessage = false, BuildContext? context}) {

    if (isIncrement) {
      _cartList[index!].quantity = _cartList[index].quantity! + 1;
      _amount = _amount + _cartList[index].discountedPrice!;
      if(showMessage) {
        showCustomSnackBar('quantity_increase_from_cart'.tr, isError: false);
      }
    } else {
      _cartList[index!].quantity = _cartList[index].quantity! - 1;
      _amount = _amount - _cartList[index].discountedPrice!;
      if(showMessage) {
        showCustomSnackBar('quantity_decreased_from_cart'.tr);
      }
    }
    cartRepo!.addToCartList(_cartList);

    notifyListeners();
  }

  void removeFromCart(int index, BuildContext context) {
    _amount = _amount - (cartList[index].discountedPrice! * cartList[index].quantity!);
    showCustomSnackBar('remove_from_cart'.tr);
    _cartList.removeAt(index);
    cartRepo!.addToCartList(_cartList);
    notifyListeners();
  }

  void clearCartList() {
    _cartList = [];
    _amount = 0;
    cartRepo!.addToCartList(_cartList);
    notifyListeners();
  }

  int? isExistInCart(CartModel? cartModel) {
    for(int index= 0; index<_cartList.length; index++) {
      if(_cartList[index].id == cartModel!.id
          && (_cartList[index].variation != null ? _cartList[index].variation!.type
          == cartModel.variation!.type : true)) {
        return index;
      }
    }
    return null;
  }


}
