import 'package:flutter/material.dart';
import 'package:muskan_shop/models/flavour.dart';
import 'package:muskan_shop/providers/categories_provider.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:provider/provider.dart';

class CakeCustomizePopup extends StatefulWidget {
  final String? itemId;
  final String? itemName;
  final String? cakeFlavour;
  final String? ReferencePrice;
  final String? designCategory;
  final dynamic minPounds;
  final String? imgUrl;

  const CakeCustomizePopup(
      {Key? key,
      this.cakeFlavour,
      this.designCategory,
      this.itemId,
      this.itemName,
      this.minPounds,
      this.imgUrl,
      this.ReferencePrice})
      : super(key: key);

  @override
  _CakeCustomizePopupState createState() => _CakeCustomizePopupState();
}

class _CakeCustomizePopupState extends State<CakeCustomizePopup> {
  String? price;
  List<String>? flavours = [];
  String? selectedFlavour = "pineapple";
  bool? showFlavourDropdown = false;

  bool _isFirstTime = true;

  dynamic minimumPounds;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   setState(() {
  //     this.price = widget.ReferencePrice;
  //   });
  // }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isFirstTime) {
      this.flavours =
          Provider.of<CategoriesProvider>(context, listen: false).flavourNames;
      print(flavours);
      if (widget.cakeFlavour!.toUpperCase() == "ALL FLAVOURS") {
        setState(() {
          showFlavourDropdown = true;
        });
      } else {
        setState(() {
          showFlavourDropdown = false;
        });
      }
      this.selectedFlavour =
          showFlavourDropdown! ? "pineapple" : widget.cakeFlavour;

      minimumPounds = (widget.minPounds is String &&
              widget.minPounds.toUpperCase() == "NO LIMIT ON SIZE")
          ? 0
          : (widget.minPounds is String &&
                  widget.minPounds.toUpperCase() != "NO LIMIT ON SIZE")
              ? int.parse(widget.minPounds)
              : widget.minPounds;

      this.price = "Rs." +
          Provider.of<CategoriesProvider>(context, listen: false)
              .getCakePrice(
                  selectedFlavour!, widget.designCategory!, minimumPounds)
              .toString();
    }

    _isFirstTime = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesProviderObject = Provider.of<CategoriesProvider>(context);

    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          padding: EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.6,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    widget.imgUrl!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    height: 150,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(widget.itemName!,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Price : ${price}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Pounds : ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                NumberInputWithIncrementDecrement(
                  controller: TextEditingController(),
                  isInt: false,
                  scaleHeight: 0.75,
                  scaleWidth: 0.75,
                  incDecFactor: 0.25,
                  initialValue: (widget.minPounds is String &&
                          widget.minPounds.toUpperCase() == "NO LIMIT ON SIZE")
                      ? 0
                      : (widget.minPounds is String &&
                              widget.minPounds.toUpperCase() !=
                                  "NO LIMIT ON SIZE")
                          ? int.parse(widget.minPounds)
                          : widget.minPounds,
                  max: 10.0,
                  min: (widget.minPounds is String &&
                          widget.minPounds.toUpperCase() == "NO LIMIT ON SIZE")
                      ? 0
                      : (widget.minPounds is String &&
                              widget.minPounds.toUpperCase() !=
                                  "NO LIMIT ON SIZE")
                          ? int.parse(widget.minPounds)
                          : widget.minPounds,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "FLAVOUR : ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: !showFlavourDropdown!
                      ? Text(
                          widget.cakeFlavour!,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      : DropdownButton<String>(
                          items: flavours!.map(buildMenuItem).toList(),
                          isExpanded: true,
                          iconSize: 22,
                          dropdownColor: Colors.white,
                          style: TextStyle(color: Colors.black),
                          icon:
                              Icon(Icons.arrow_drop_down, color: Colors.black),
                          value: selectedFlavour,
                          onChanged: (value) => {
                                setState(() => {
                                      this.selectedFlavour = value,
                                    })
                              }),
                ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  onPressed: () {},
                  child: Text("Add to cart",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  color: Colors.red,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
    value: item,
    child: Text(item,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        )));
