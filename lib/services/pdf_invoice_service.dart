import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pw;

import '../models/company.dart';
import '../models/invoice.dart';

class PdfInvoiceService {
  const PdfInvoiceService();

  Future<Uint8List> buildInvoicePdf({required Company company, required InvoiceDraft invoice}) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(company.name, style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 4),
            if (company.gstin != null) pw.Text('GSTIN: ${company.gstin}'),
            pw.SizedBox(height: 16),
            pw.Text('${invoice.type} Invoice', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.Text('Invoice No: ${invoice.invoiceNumber ?? '-'}'),
            pw.Text('Date: ${invoice.date.day}-${invoice.date.month}-${invoice.date.year}'),
            pw.Text('Party: ${invoice.partyName}'),
            pw.Text('Mode: ${invoice.withInventory ? 'With Inventory' : 'Without Inventory'}'),
            pw.SizedBox(height: 16),
            pw.TableHelper.fromTextArray(
              headers: invoice.withInventory
                  ? ['Item', 'HSN', 'Qty', 'Unit', 'Rate', 'GST %', 'Amount']
                  : ['Description', 'Rate', 'GST %', 'Amount'],
              data: invoice.lines.map((line) {
                if (invoice.withInventory) {
                  return [
                    line.description,
                    line.hsn ?? '',
                    line.quantity.toStringAsFixed(2),
                    line.unit ?? '',
                    line.rate.toStringAsFixed(2),
                    line.gstRate.toStringAsFixed(2),
                    line.total.toStringAsFixed(2),
                  ];
                }
                return [
                  line.description,
                  line.rate.toStringAsFixed(2),
                  line.gstRate.toStringAsFixed(2),
                  line.total.toStringAsFixed(2),
                ];
              }).toList(),
            ),
            pw.SizedBox(height: 16),
            _totalRow('Taxable Value', invoice.taxableValue),
            _totalRow('GST', invoice.gstAmount),
            _totalRow('Invoice Total', invoice.total, bold: true),
          ],
        ),
      ),
    );

    return pdf.save();
  }

  pw.Widget _totalRow(String label, double amount, {bool bold = false}) {
    final style = bold ? pw.TextStyle(fontWeight: pw.FontWeight.bold) : null;
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Text('$label: ', style: style),
        pw.Text(amount.toStringAsFixed(2), style: style),
      ],
    );
  }
}
