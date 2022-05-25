import 'package:flutter/material.dart';
import 'package:muskan_shop/providers/cart.dart';
import 'package:provider/provider.dart';

import 'itemQuantityCounter.dart';

class CartProductCard extends StatefulWidget {
  final CartItem cartItem;
  const CartProductCard({Key? key, required this.cartItem}) : super(key: key);

  @override
  _CartProductCardState createState() => _CartProductCardState();
}

class _CartProductCardState extends State<CartProductCard> {
  @override
  Widget build(BuildContext context) {
    final cartProviderObject = Provider.of<CartProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Flexible(
          flex: 5,
          child: Image.network(widget.cartItem.imageUrl,
              height: 80, width: 100, fit: BoxFit.cover),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          flex: 7,
          fit: FlexFit.tight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.cartItem.title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Rs.${widget.cartItem.totalPrice}',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
        Flexible(
          flex: 5,
          child: Container(
            height: 30,
            child: CountButtonView(
                itemId: widget.cartItem.id,
                onChange: (count) => {
                      if (count == 0)
                        {
                          cartProviderObject.removeItem(widget.cartItem.id),
                        }
                      else if (count > 0)
                        {
                          cartProviderObject.addItem(
                              widget.cartItem.id,
                              widget.cartItem.price,
                              count,
                              widget.cartItem.title,
                              widget.cartItem.imageUrl,
                              widget.cartItem.parentCategoryType)
                        }
                    }),
          ),
        )
      ]),
    );
  }
}
