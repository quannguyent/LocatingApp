import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../res/resources.dart';
import '../../utils/utils.dart';
import '../../localizations.dart';
import '../../utils/common.dart';
import 'package:locaing_app/ui/widgets/bar_chart.dart';

class StatisicsScreen extends StatefulWidget {
  @override
  _StatisicsScreenState createState() => _StatisicsScreenState();
}

class _StatisicsScreenState extends State<StatisicsScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 80),
            color: AppTheme.whiteBlack,
            width: DeviceUtil.getDeviceWidth(context),
            height: DeviceUtil.getDeviceHeight(context),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: logoWidget(),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: basicStats(),
                  ),
                  Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: pieChart(showingSections())
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Card(
                      child: barChart(values: [8, 1, 0, 5, 3, 2, 6])
                    )
                  ),

                ]
              )
            ),
          ),
        ],
      ),
    );
  }

  Widget logoWidget() {
    return Container(
      width: DeviceUtil.getDeviceWidth(context),
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.only(left: 24, bottom: 24, top: 32),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(50)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.blue.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              "Số liệu thống kê",
              style: TextStyle(
                // h5 -> headline
                fontWeight: FontWeight.bold,
                fontSize: 30,
                letterSpacing: 0.27,
                color: AppTheme.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget basicStats() {
    return Card(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: new Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Quãng đường",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              Text(
                                " 36 km",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  letterSpacing: 1.1,
                                ),
                                softWrap: true,
                                overflow: TextOverflow.fade,
                              )
                            ]
                          )
                        ),
                      ],
                    )
                  ),
                ),
              ),
              Expanded(
                child: new Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Thời gian",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              Text(
                                " 1h : 49m ",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  letterSpacing: 1.1,
                                ),
                                softWrap: true,
                                overflow: TextOverflow.fade,
                              )
                            ]
                          )
                        ),
                      ],
                    )
                  ),
                ),
              ),
            ],
          )
        ]
      ),
    );
  }

  Widget pieChart(List<PieChartSectionData> pieData) {
    return AspectRatio(
      aspectRatio: 1.25,
      child: Card(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                'Nhóm địa điểm',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 50,
                          sections: pieData
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Indicator(
                      color: Color(0xff0293ee),
                      text: 'Transport',
                      isSquare: true,
                    ),
                    Indicator(
                      color: Color(0xfff8b250),
                      text: 'Entertainment',
                      isSquare: true,
                    ),
                    Indicator(
                      color: Color(0xff845bef),
                      text: 'Food',
                      isSquare: true,
                    ),
                    Indicator(
                      color: Color(0xff13d38e),
                      text: 'Nightlife',
                      isSquare: true,
                    ),
                    Indicator(
                      color: Color(0xffff0000),
                      text: 'Religion',
                      isSquare: true,
                    ),
                    Indicator(
                      color: Color(0xffffe119),
                      text: 'Education',
                      isSquare: true,
                    ),
                    Indicator(
                      color: Color(0xffbfef45),
                      text: 'Workplace',
                      isSquare: true,
                    ),
                    Indicator(
                      color: Color(0xff42d4f4),
                      text: 'Health',
                      isSquare: true,
                    ),
                    Indicator(
                      color: Color(0xfff032e6),
                      text: 'Shopping',
                      isSquare: true,
                    ),
                    Indicator(
                      color: Color(0xffa9a9a9),
                      text: 'Natural',
                      isSquare: true,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
        ]),
      )
    );
  }

  Widget placeList() {
    return Container();
  }
}

List<PieChartSectionData> showingSections() {
  return List.generate(4, (i) {
    final isTouched = i == 0;//touchedIndex;
    final fontSize = isTouched ? 25.0 : 16.0;
    final radius = isTouched ? 60.0 : 50.0;
    switch (i) {
      case 0:
        return PieChartSectionData(
          color: const Color(0xff0293ee),
          value: 39,
          title: '39%',
          radius: radius,
          titleStyle: TextStyle(
              fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
        );
      case 1:
        return PieChartSectionData(
          color: const Color(0xfff8b250),
          value: 21,
          title: '21%',
          radius: radius,
          titleStyle: TextStyle(
              fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
        );
      case 2:
        return PieChartSectionData(
          color: const Color(0xff845bef),
          value: 36,
          title: '36%',
          radius: radius,
          titleStyle: TextStyle(
              fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
        );
      case 3:
        return PieChartSectionData(
          color: const Color(0xff13d38e),
          value: 4,
          title: '4%',
          radius: radius,
          titleStyle: TextStyle(
              fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
        );
      default:
        throw Error();
    }
  });
}


class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key key,
    @required this.color,
    @required this.text,
    this.isSquare = true,
    this.size = 14,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 4),
      child: Row(
        children: <Widget>[
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
          )
        ],
      )
    );
  }
}
