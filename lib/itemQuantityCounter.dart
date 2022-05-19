import 'package:flutter/material.dart';

typedef void CountButtonClickCallBack(int count);

class CountButtonView extends StatefulWidget {
  final int initialCount;
  final CountButtonClickCallBack onChange;

  const CountButtonView(
      {Key? key, required this.initialCount, required this.onChange})
      : super(key: key);

  @override
  _CountButtonViewState createState() => _CountButtonViewState();
}

class _CountButtonViewState extends State<CountButtonView> {
  late int count;

  @override
  void initState() {
    // TODO: implement initState
    count = widget.initialCount;
    super.initState();
  }

  void updateCount(int addValue) {
    if (count + addValue >= 0) {
      setState(() {
        count += addValue;
      });
    }

    if (widget.onChange != null) {
      widget.onChange(count);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120.0,
      height: 50.0,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.red,
              border: Border.all(color: Colors.white, width: 1.0),
              borderRadius: BorderRadius.circular(22.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    updateCount(-1);
                  },
                  child: Container(
                      width: 40.0,
                      child: Center(
                          child: Text(
                        '-',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            decoration: TextDecoration.none),
                      )))),
              Container(
                child: Center(
                    child: Text(
                  '$count',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: TextDecoration.none),
                )),
              ),
              GestureDetector(
                  onTap: () {
                    updateCount(1);
                  },
                  child: Container(
                      width: 40.0,
                      child: Center(
                          child: Text(
                        '+',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            decoration: TextDecoration.none),
                      )))),
            ],
          ),
        ),
      ),
    );
  }
}
