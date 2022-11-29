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
      this.isFinishedLoan});

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
        'isFinishedLoan=$isFinishedLoan';
  }
}
