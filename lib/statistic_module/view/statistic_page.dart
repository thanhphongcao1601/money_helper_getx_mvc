import 'dart:math';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/home_module/controller/home_controller.dart';
import 'package:money_helper_getx_mvc/ultis/constants/constant.dart';

// ignore: must_be_immutable
class StatisticPage extends StatefulWidget {
  const StatisticPage({Key? key}) : super(key: key);

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage>
    with TickerProviderStateMixin {
  final homeController = Get.find<HomeController>();
  late TabController _tabController;
  late List<Map<String, dynamic>> dataExpenseToChart;
  late List<Map<String, dynamic>> dataIncomeToChart;
  late int totalExpense;
  late int totalIncome;
  late List<Color> colors;

  @override
  void initState() {
    super.initState();
    dataExpenseToChart = [];
    dataIncomeToChart = [];
    colors = [];
    totalExpense = 0;
    totalIncome = 0;
    _tabController = TabController(length: 2, vsync: this);

    double roundDouble(double value, int places) {
      double mod = pow(10.0, places) as double;
      return ((value * mod).round().toDouble() / mod);
    }

    for (var i = 0; i < 20; i++) {
      colors.add(Colors.primaries[Random().nextInt(Colors.primaries.length)]);
    }

    //get total money expense and income
    for (var item in homeController.listRecordGroupByGenre.value.entries) {
      totalExpense += item.value.sumBy<int>((e) => e.money! < 0 ? e.money! : 0);
      totalIncome += item.value.sumBy<int>((e) => e.money! > 0 ? e.money! : 0);
    }

    //add expense item to expenseChart
    for (var item in homeController.listRecordGroupByGenre.value.entries) {
      for (var record in item.value) {
        if (record.money! < 0) {
          Map<String, dynamic> obj = {
            'domain': item.key,
            'measure': roundDouble(
                (item.value.sumBy<int>((e) => e.money! < 0 ? e.money! : 0) /
                    totalExpense *
                    100),
                2),
            'money': (item.value.sumBy<int>((e) => e.money! < 0 ? e.money! : 0))
          };
          if (!dataExpenseToChart
              .any((element) => element['domain'] == obj['domain'])) {
            dataExpenseToChart.add(obj);
          }
        }
      }
    }

    //add income item to incomeChart
    for (var item in homeController.listRecordGroupByType.value.entries) {
      for (var record in item.value) {
        if (record.money! > 0) {
          Map<String, dynamic> obj = {
            'domain': item.key,
            'measure': roundDouble(
                (item.value.sumBy<int>((e) => e.money! > 0 ? e.money! : 0) /
                    totalIncome *
                    100),
                2),
            'money': item.value.sumBy<int>((e) => e.money! > 0 ? e.money! : 0)
          };
          if (!dataIncomeToChart
              .any((element) => element['domain'] == obj['domain'])) {
            dataIncomeToChart.add(obj);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.darkPurple,
        appBar: TabBar(
            indicatorColor: AppColor.gold,
            labelColor: AppColor.gold,
            controller: _tabController,
            tabs: [
              Tab(
                text: "${"tab.expense".tr}: ${totalExpense.toString()}",
              ),
              Tab(
                text: "${"tab.income".tr}: ${totalIncome.toString()}",
              ),
            ]),
        body: Container(
          color: AppColor.purple,
          child: TabBarView(
            controller: _tabController,
            children: [
              buildTabExpense(),
              buildTabIncome(),
            ],
          ),
        ));
  }

  Widget buildTabExpense() {
    return dataExpenseToChart.isNotEmpty
        ? SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: DChartPie(
                      labelColor: Theme.of(context).colorScheme.onSurface,
                      labelLineColor: Theme.of(context).colorScheme.onSurface,
                      data: dataExpenseToChart,
                      fillColor: (pieData, index) => colors[index!],
                      pieLabel: (pieData, index) {
                        return "${pieData['domain']}:\n${pieData['measure']}%";
                      },
                      labelPosition: PieLabelPosition.outside,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Divider(
                    height: 0,
                    thickness: 2,
                  ),
                ),
                buildListDetailExpense()
              ],
            ),
          )
        : const SizedBox();
  }

  Widget buildListDetailExpense() {
    return Column(
      children: [
        for (var item in dataExpenseToChart)
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(5),
              width: 75,
              height: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: colors[dataExpenseToChart.indexOf(item)]),
              child: Center(child: Text('${'${item['measure']}'.tr}%')),
            ),
            title: Text('${item['domain']}'.tr),
            trailing: Text(item['money'].toString()),
          )
      ],
    );
  }

  Widget buildTabIncome() {
    return dataIncomeToChart.isNotEmpty
        ? SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: AspectRatio(
                      aspectRatio: 2 / 1,
                      child: DChartBar(
                        data: [
                          {
                            'id': 'Bar',
                            'data': [...dataIncomeToChart]
                          }
                        ],
                        domainLabelColor:
                            Theme.of(context).colorScheme.onSurface,
                        axisLineColor: Theme.of(context).colorScheme.onSurface,
                        barValueColor: Theme.of(context).colorScheme.onSurface,
                        measureLabelColor:
                            Theme.of(context).colorScheme.onSurface,
                        domainLabelPaddingToAxisLine: 16,
                        measureLabelPaddingToAxisLine: 16,
                        barColor: (barData, index, id) => colors[index!],
                        verticalDirection: false,
                      ),
                    ),
                  ),
                  buildListDetailIncome()
                ],
              ),
            ),
          )
        : const SizedBox();
  }

  Widget buildListDetailIncome() {
    return Column(
      children: [
        for (var item in dataIncomeToChart)
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(5),
              width: 75,
              height: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: colors[dataIncomeToChart.indexOf(item)]),
              child: Center(child: Text('${'${item['measure']}'.tr}%')),
            ),
            title: Text('${item['domain']}'.tr),
            trailing: Text(item['money'].toString()),
          )
      ],
    );
  }
}
