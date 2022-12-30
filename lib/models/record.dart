// ignore_for_file: unnecessary_this

import 'package:money_helper_getx_mvc/models/record_history.dart';

class Record extends Comparable {
  String? id;
  int? datetime;
  String? genre;
  String? content;
  int? money;
  String? type;
  bool? isLoan;
  String? loanPersonName;
  String? loanType;
  String? loanContent;
  bool? isFinishedLoan;
  List<RecordHistory>? recordHistoryList;

  Record(
      {this.id,
      this.datetime,
      this.genre,
      this.content,
      this.money,
      this.type,
      this.isLoan,
      this.loanPersonName,
      this.loanType,
      this.loanContent,
      this.isFinishedLoan,
      this.recordHistoryList});

  Record.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    datetime = json['datetime'];
    genre = json['genre'];
    content = json['content'];
    money = json['money'];
    type = json['type'];
    isLoan = json['isLoan'];
    loanPersonName = json['loanPersonName'];
    loanType = json['loanType'];
    loanContent = json['loanContent'];
    isFinishedLoan = json['isFinishedLoan'];
    if (json['recordHistoryList'] != null) {
      recordHistoryList = <RecordHistory>[];
      json['recordHistoryList'].forEach((v) {
        recordHistoryList!.add(RecordHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['datetime'] = datetime;
    data['genre'] = genre;
    data['content'] = content;
    data['money'] = money;
    data['type'] = type;
    data['isLoan'] = isLoan;
    data['loanPersonName'] = loanPersonName;
    data['loanType'] = loanType;
    data['loanContent'] = loanContent;
    data['isFinishedLoan'] = isFinishedLoan;
    if (this.recordHistoryList != null) {
      data['recordHistoryList'] = this.recordHistoryList!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  int compareTo(other) {
    return datetime!.compareTo(other.datetime);
  }

  @override
  String toString() {
    return 'Record('
        'id=$id,'
        'datetime=$datetime,'
        'content=$content,'
        'genre=$genre,'
        'content=$content,'
        'money=$money,'
        'type=$type,'
        'isLoan=$isLoan,'
        'loanPersonName=$loanPersonName,'
        'loanType=$loanType,'
        'loanContent=$loanContent,'
        'isFinishedLoan=$isFinishedLoan'
        'recordHistoryListLength=${recordHistoryList?.length ?? 0}';
  }
}
