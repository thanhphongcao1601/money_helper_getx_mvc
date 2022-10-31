import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/module/detail_record_module/view/detail_record_page.dart';
import 'package:money_helper_getx_mvc/module/statistic_module/controller/statistic_controller.dart';
import 'package:money_helper_getx_mvc/ultis/constants/constant.dart';
import 'package:money_helper_getx_mvc/ultis/helper/helper.dart';
import '../../home_module/model/record.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({Key? key}) : super(key: key);

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage>
    with TickerProviderStateMixin {
  StatisticController statisticController = Get.find();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    statisticController.loadAllData();
  }

  void handleGoToDetailRecord(Record record) {
    Get.to(() => DetailRecordPage(currentRecord: record));
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
              Obx(
                () => Tab(
                  text:
                      "${"tab.expense".tr}: ${statisticController.totalMonthExpense.value.toString()}",
                ),
              ),
              Obx(
                () => Tab(
                  text:
                      "${"tab.income".tr}: ${statisticController.totalMonthIncome.toString()}",
                ),
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
    return SingleChildScrollView(
        child: Obx(
      () => Column(
        children: [
          ElevatedButton(
              onPressed: () {
                statisticController.currentDate.value = DateTime(2022, 11);
                statisticController.loadAllData();
              },
              child: const Text('click')),
          Padding(
            padding: const EdgeInsets.all(10),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: DChartPie(
                labelColor: Colors.white,
                labelLineColor: Colors.white,
                data: [...statisticController.dataExpenseToChart.value],
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
    ));
  }

  Widget buildListDetailExpense() {
    return Obx(() => Column(
          children: [
            for (var item in statisticController.dataExpenseToChart.value)
              Column(
                children: [
                  ListTile(
                    onTap: () =>
                        statisticController.handleExpandTile(item['domain']),
                    leading: Container(
                      padding: const EdgeInsets.all(5),
                      width: 75,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Helper().getItemTypeColor(item['domain'])),
                      child: Center(
                          child: Text('${item['measure']}%',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold))),
                    ),
                    title: Text(item['domain'],
                        style: const TextStyle(color: Colors.white)),
                    trailing: Text(item['money'].toString(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                  for (var record
                      in statisticController.listRecordGroupByDate.value)
                    statisticController.tileSelected == item['domain']
                        ? Column(
                            children: [
                              for (var recordFilter in record.listRecord)
                                item['domain'].toString().tr ==
                                        recordFilter.genre.toString().tr
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            50, 0, 15, 5),
                                        child: InkWell(
                                          onTap: () => handleGoToDetailRecord(
                                              recordFilter),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                recordFilter.content!,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                              Text(
                                                  recordFilter.money.toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16))
                                            ],
                                          ),
                                        ),
                                      )
                                    : const SizedBox()
                            ],
                          )
                        : const SizedBox()
                ],
              )
          ],
        ));
  }

  Widget buildTabIncome() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Obx(() => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: AspectRatio(
                    aspectRatio: 2 / 1,
                    child: DChartBar(
                      data: [
                        {
                          'id': 'Bar',
                          'data': [
                            ...statisticController.dataIncomeToChart.value
                          ]
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
            )),
      ),
    );
  }

  Widget buildListDetailIncome() {
    return Obx(() => Column(
          children: [
            for (var item in statisticController.dataIncomeToChart.value)
              Column(
                children: [
                  ListTile(
                    onTap: () =>
                        statisticController.handleExpandTile(item['domain']),
                    leading: Container(
                      padding: const EdgeInsets.all(5),
                      width: 75,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Helper().getItemTypeColor(item['domain'])),
                      child: Center(
                          child: Text('${item['measure'].toString().tr}%',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold))),
                    ),
                    title: Text(
                      item['domain'].toString().tr,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: Text(item['money'].toString(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                  for (var record
                      in statisticController.listRecordGroupByDate.value)
                    statisticController.tileSelected == item['domain']
                        ? Column(
                            children: [
                              for (var recordFilter in record.listRecord)
                                item['domain'].toString().tr ==
                                        recordFilter.type.toString().tr
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            50, 0, 15, 5),
                                        child: InkWell(
                                          onTap: () => handleGoToDetailRecord(
                                              recordFilter),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                recordFilter.content!,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                              Text(
                                                  recordFilter.money.toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16))
                                            ],
                                          ),
                                        ),
                                      )
                                    : const SizedBox()
                            ],
                          )
                        : const SizedBox()
                ],
              )
          ],
        ));
  }
}
