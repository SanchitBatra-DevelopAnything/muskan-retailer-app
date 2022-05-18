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
      width: 110,
      height: 44,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.red,
              border: Border.all(color: Colors.white, width: 1.0),
              borderRadius: BorderRadius.circular(22)),
        ),
      ),
    );
  }
}
