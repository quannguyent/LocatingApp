import 'package:flutter/material.dart';

class barChart extends StatelessWidget {
  final List<double> values;
  barChart({this.values});
  @override
  Widget build(BuildContext context) {
    double _max = 0;
    values.forEach((double price) {
      if (price > _max) {
        _max = price;
      }
    });
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Text(
            'Số nơi đã đến',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                iconSize: 30.0,
                onPressed: () {},
              ),
              Text(
                'May 30  -  Jun 5',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                iconSize: 30.0,
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Bar(
                label: 'Su',
                amountSpend: values[0],
                mostExpensive: _max,
              ),
              Bar(
                label: 'Mo',
                amountSpend: values[1],
                mostExpensive: _max,
              ),
              Bar(
                label: 'Tu',
                amountSpend: values[2],
                mostExpensive: _max,
              ),
              Bar(
                label: 'We',
                amountSpend: values[3],
                mostExpensive: _max,
              ),
              Bar(
                label: 'Th',
                amountSpend: values[4],
                mostExpensive: _max,
              ),
              Bar(
                label: 'Fr',
                amountSpend: values[5],
                mostExpensive: _max,
              ),
              Bar(
                label: 'Sa',
                amountSpend: values[6],
                mostExpensive: _max,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Bar extends StatelessWidget {
  final String label;
  final double amountSpend;
  final double mostExpensive;
  final double _maxBarheight = 150.0;
  Bar({this.label, this.amountSpend, this.mostExpensive});
  @override
  Widget build(BuildContext context) {
    final barHeight = amountSpend / mostExpensive * _maxBarheight;
    return Column(
      children: [
        Text(
          '${amountSpend.toStringAsFixed(0)}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 6.0),
        Container(
          height: barHeight,
          width: 18.0,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
}