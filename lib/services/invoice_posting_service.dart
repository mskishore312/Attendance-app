import '../data/app_database.dart';
import '../models/company.dart';
import '../models/invoice.dart';
import '../models/ledger.dart';
import '../models/voucher.dart';

class InvoicePostingService {
  const InvoicePostingService();

  Future<int> postInvoice({required Company company, required InvoiceDraft invoice}) async {
    final ledgers = await AppDatabase.instance.getLedgers(company.id!);
    if (ledgers.length < 2) throw Exception('Create required ledgers before posting invoice');

    final party = _findLedger(ledgers, invoice.partyName) ?? ledgers.first;
    final salesOrPurchase = invoice.type == 'Sales'
        ? _findGroupLedger(ledgers, 'Sales')
        : _findGroupLedger(ledgers, 'Purchase');
    if (salesOrPurchase == null) throw Exception('Create ${invoice.type} ledger before posting invoice');

    final gstLedger = _findGroupLedger(ledgers, 'Duties') ?? salesOrPurchase;
    final taxable = invoice.taxableValue;
    final gst = invoice.gstAmount;
    final total = invoice.total;

    final voucher = Voucher(
      companyId: company.id!,
      type: invoice.type,
      date: invoice.date,
      narration: '${invoice.type} invoice for ${invoice.partyName}',
      taxableValue: taxable,
      gstRate: invoice.lines.isEmpty ? 0 : invoice.lines.first.gstRate,
      cgst: gst / 2,
      sgst: gst / 2,
    );

    final entries = invoice.type == 'Sales'
        ? [
            VoucherEntry(ledgerId: party.id!, ledgerName: party.name, dr: total, cr: 0),
            VoucherEntry(ledgerId: salesOrPurchase.id!, ledgerName: salesOrPurchase.name, dr: 0, cr: taxable),
            if (gst > 0) VoucherEntry(ledgerId: gstLedger.id!, ledgerName: gstLedger.name, dr: 0, cr: gst),
          ]
        : [
            VoucherEntry(ledgerId: salesOrPurchase.id!, ledgerName: salesOrPurchase.name, dr: taxable, cr: 0),
            if (gst > 0) VoucherEntry(ledgerId: gstLedger.id!, ledgerName: gstLedger.name, dr: gst, cr: 0),
            VoucherEntry(ledgerId: party.id!, ledgerName: party.name, dr: 0, cr: total),
          ];

    return AppDatabase.instance.insertVoucher(voucher, entries);
  }

  Ledger? _findLedger(List<Ledger> ledgers, String name) {
    for (final ledger in ledgers) {
      if (ledger.name.toLowerCase() == name.toLowerCase()) return ledger;
    }
    return null;
  }

  Ledger? _findGroupLedger(List<Ledger> ledgers, String groupKeyword) {
    for (final ledger in ledgers) {
      if (ledger.groupName.toLowerCase().contains(groupKeyword.toLowerCase())) return ledger;
    }
    return null;
  }
}
