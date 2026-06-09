import '../data/app_database.dart';
import '../models/company.dart';
import '../models/invoice.dart';
import '../models/ledger.dart';
import '../models/voucher.dart';

class InvoicePostingService {
  const InvoicePostingService();

  Future<int> postInvoice({
    required Company company,
    required InvoiceDraft invoice,
    required Ledger partyLedger,
    required Ledger mainLedger,
    required Ledger gstLedger,
  }) async {
    final taxable = invoice.taxableValue;
    final gst = invoice.gstAmount;
    final total = invoice.total;

    final voucher = Voucher(
      companyId: company.id!,
      type: invoice.type,
      date: invoice.date,
      narration: '${invoice.type} invoice for ${partyLedger.name}',
      taxableValue: taxable,
      gstRate: invoice.lines.isEmpty ? 0 : invoice.lines.first.gstRate,
      cgst: gst / 2,
      sgst: gst / 2,
    );

    final entries = invoice.type == 'Sales'
        ? [
            VoucherEntry(ledgerId: partyLedger.id!, ledgerName: partyLedger.name, dr: total, cr: 0),
            VoucherEntry(ledgerId: mainLedger.id!, ledgerName: mainLedger.name, dr: 0, cr: taxable),
            if (gst > 0) VoucherEntry(ledgerId: gstLedger.id!, ledgerName: gstLedger.name, dr: 0, cr: gst),
          ]
        : [
            VoucherEntry(ledgerId: mainLedger.id!, ledgerName: mainLedger.name, dr: taxable, cr: 0),
            if (gst > 0) VoucherEntry(ledgerId: gstLedger.id!, ledgerName: gstLedger.name, dr: gst, cr: 0),
            VoucherEntry(ledgerId: partyLedger.id!, ledgerName: partyLedger.name, dr: 0, cr: total),
          ];

    return AppDatabase.instance.insertVoucher(voucher, entries);
  }
}
