class NeuroHistoryModel {
  NeuroHistoryModel(this.type, this.historyName, this.checkTime, this.neuro);

  NeuroHistoryModel.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        historyName = json['historyName'],
        checkTime = json['checkTime'],
        neuro = json['neuro'];

  final String type;
  final String historyName;
  final String checkTime;
  final int neuro;
}