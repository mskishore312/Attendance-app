class Company {
  const Company({this.id, required this.name, required this.fromDate, required this.toDate, this.gstin});

  final int? id;
  final String name;
  final DateTime fromDate;
  final DateTime toDate;
  final String? gstin;

  Map<String, Object?> toMap() => {
    'id': id,
    'name': name,
    'from_date': fromDate.toIso8601String(),
    'to_date': toDate.toIso8601String(),
    'gstin': gstin,
  };

  factory Company.fromMap(Map<String, Object?> map) => Company(
    id: map['id'] as int?,
    name: map['name'] as String,
    fromDate: DateTime.parse(map['from_date'] as String),
    toDate: DateTime.parse(map['to_date'] as String),
    gstin: map['gstin'] as String?,
  );
}
