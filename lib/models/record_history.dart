class RecordHistory {
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

  RecordHistory(
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
      this.isFinishedLoan});

  RecordHistory.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
