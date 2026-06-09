import '../data/app_database.dart';

class CsvExportService {
  const CsvExportService();

  Future<String> buildTrialBalanceCsv(int companyId) async {
    final rows = await AppDatabase.instance.getTrialBalance(companyId);
    final buffer = StringBuffer();
    buffer.writeln('Ledger,Group,Debit,Credit');
    for (final row in rows) {
      final name = row['name'] as String;
      final group = row['group_name'] as String;
      final debit = (row['debit'] as num).toDouble().toStringAsFixed(2);
      final credit = (row['credit'] as num).toDouble().toStringAsFixed(2);
      buffer.writeln('$name,$group,$debit,$credit');
    }
    return buffer.toString();
  }
}
