class CalculationHistory {
  int? id;
  String expression;
  String result;
  DateTime timestamp;

  CalculationHistory({
    this.id,
    required this.expression,
    required this.result,
    required this.timestamp,
  });

  factory CalculationHistory.fromMap(Map<String, dynamic> map) {
    return CalculationHistory(
      id: map['id'],
      expression: map['expression'],
      result: map['result'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expression': expression,
      'result': result,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  String get historyString => '$expression = $result';
}