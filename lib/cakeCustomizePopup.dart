import 'package:flutter/material.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

class CakeCustomizePopup extends StatefulWidget {
  final String? itemId;
  final String? itemName;
  final String? cakeFlavour;
  final String? ReferencePrice;
  final dynamic minPounds;
  final String? imgUrl;

  const CakeCustomizePopup(
      {Key? key,
      this.cakeFlavour,
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
  List<String>? flavours;
  String? selectedFlavour;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      this.price = widget.ReferencePrice;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
                    width: 150,
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
                  height: 3,
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
                Container(
                  width: 50,
                  child: DropdownButton<String>(
                      items: flavours.map(buildMenuItem).toList(),
                      isExpanded: true,
                      iconSize: 22,
                      dropdownColor: Colors.white,
                      style: TextStyle(color: Colors.black),
                      icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                      value: selectedFlavour,
                      onChanged: (value) => {
                            setState(() => {
                                  this.selectedFlavour = value,
                                })
                          }),
                ),
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
