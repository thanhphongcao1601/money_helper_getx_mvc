import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/home_module/controller/home_controller.dart';
import 'package:money_helper_getx_mvc/ultis/constants/constant.dart';

import '../../ultis/helper/helper.dart';

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
  late String titeSelected;

  @override
  void initState() {
    super.initState();
    dataExpenseToChart = [];
    dataIncomeToChart = [];
    titeSelected = '';
    totalExpense = 0;
    totalIncome = 0;
    _tabController = TabController(length: 2, vsync: this);

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
            'domain': item.key.toString().tr,
            'measure': Helper().roundDouble(
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
            'domain': item.key.toString().tr,
            'measure': Helper().roundDouble(
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
                      labelColor: Colors.white,
                      labelLineColor: Colors.white,
                      data: dataExpenseToChart,
                      fillColor: (pieData, index) =>
                          Helper().getItemTypeColor(pieData['domain']),
                      pieLabel: (pieData, index) {
                        return '${pieData['domain']}:\n${pieData['measure']}%';
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
          InkWell(
            onTap: () {
              if (item['domain'] == titeSelected) {
                titeSelected = '';
              } else {
                titeSelected = item['domain'];
              }
              setState(() {
                titeSelected;
              });
            },
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(5),
                    width: 75,
                    height: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Helper().getItemTypeColor(item['domain'])),
                    child: Center(
                        child: Text('${item['measure']}%',
                            style: const TextStyle(color: Colors.white))),
                  ),
                  title: Text(item['domain'],
                      style: const TextStyle(color: Colors.white)),
                  trailing: Text(item['money'].toString(),
                      style: const TextStyle(color: Colors.white)),
                ),
                for (var record
                    in homeController.listRecordGroupByDate.value.entries)
                  titeSelected == item['domain']
                      ? Column(
                          children: [
                            for (var recordFilter in record.value)
                              item['domain'].toString().tr ==
                                      recordFilter.genre.toString().tr
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          120, 0, 15, 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            recordFilter.content!,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          Text(recordFilter.money.toString(),
                                              style: const TextStyle(
                                                  color: Colors.white))
                                        ],
                                      ),
                                    )
                                  : const SizedBox()
                          ],
                        )
                      : const SizedBox()
              ],
            ),
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
                        domainLabelColor: Colors.white,
                        // axisLineColor: Theme.of(context).colorScheme.onSurface,
                        // barValueColor: Theme.of(context).colorScheme.onSurface,
                        axisLineColor: Colors.white,
                        barValueColor: Colors.white,
                        measureLabelColor: Colors.white,
                        domainLabelPaddingToAxisLine: 16,
                        measureLabelPaddingToAxisLine: 16,
                        barColor: (barData, index, id) =>
                            Helper().getItemTypeColor(barData['domain']),
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
          InkWell(
            onTap: () {
              if (item['domain'] == titeSelected) {
                titeSelected = '';
              } else {
                titeSelected = item['domain'];
              }
              setState(() {
                titeSelected;
              });
            },
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(5),
                    width: 75,
                    height: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Helper().getItemTypeColor(item['domain'])),
                    child: Center(
                        child: Text('${item['measure'].toString().tr}%',
                            style: const TextStyle(color: Colors.white))),
                  ),
                  title: Text(
                    item['domain'].toString().tr,
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: Text(item['money'].toString(),
                      style: const TextStyle(color: Colors.white)),
                ),
                for (var record
                    in homeController.listRecordGroupByDate.value.entries)
                  titeSelected == item['domain']
                      ? Column(
                          children: [
                            for (var recordFilter in record.value)
                              item['domain'].toString().tr ==
                                      recordFilter.type.toString().tr
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          120, 0, 15, 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            recordFilter.content!,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          Text(recordFilter.money.toString(),
                                              style: const TextStyle(
                                                  color: Colors.white))
                                        ],
                                      ),
                                    )
                                  : const SizedBox()
                          ],
                        )
                      : const SizedBox()
              ],
            ),
          )
      ],
    );
  }
}
