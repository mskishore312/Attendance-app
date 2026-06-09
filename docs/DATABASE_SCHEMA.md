# TOMPA Database Schema

This is the initial SQLite-first schema proposal.

## companies

```sql
CREATE TABLE companies (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  legal_name TEXT,
  gstin TEXT,
  address TEXT,
  state TEXT,
  phone TEXT,
  email TEXT,
  financial_year_start TEXT NOT NULL,
  financial_year_end TEXT NOT NULL,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
```

## account_groups

```sql
CREATE TABLE account_groups (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  company_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  parent_group_id INTEGER,
  nature TEXT NOT NULL,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY(company_id) REFERENCES companies(id),
  FOREIGN KEY(parent_group_id) REFERENCES account_groups(id)
);
```

`nature` values:
- ASSET
- LIABILITY
- INCOME
- EXPENSE
- CAPITAL

## ledgers

```sql
CREATE TABLE ledgers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  company_id INTEGER NOT NULL,
  group_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  opening_balance REAL NOT NULL DEFAULT 0,
  opening_type TEXT NOT NULL DEFAULT 'DR',
  gstin TEXT,
  state TEXT,
  address TEXT,
  phone TEXT,
  email TEXT,
  is_active INTEGER NOT NULL DEFAULT 1,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY(company_id) REFERENCES companies(id),
  FOREIGN KEY(group_id) REFERENCES account_groups(id)
);
```

## vouchers

```sql
CREATE TABLE vouchers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  company_id INTEGER NOT NULL,
  voucher_type TEXT NOT NULL,
  voucher_no TEXT NOT NULL,
  voucher_date TEXT NOT NULL,
  party_ledger_id INTEGER,
  narration TEXT,
  total_debit REAL NOT NULL DEFAULT 0,
  total_credit REAL NOT NULL DEFAULT 0,
  status TEXT NOT NULL DEFAULT 'POSTED',
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY(company_id) REFERENCES companies(id),
  FOREIGN KEY(party_ledger_id) REFERENCES ledgers(id)
);
```

Voucher types:
- RECEIPT
- PAYMENT
- CONTRA
- JOURNAL
- SALES
- PURCHASE
- DEBIT_NOTE
- CREDIT_NOTE

## voucher_entries

```sql
CREATE TABLE voucher_entries (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  voucher_id INTEGER NOT NULL,
  ledger_id INTEGER NOT NULL,
  debit REAL NOT NULL DEFAULT 0,
  credit REAL NOT NULL DEFAULT 0,
  line_narration TEXT,
  FOREIGN KEY(voucher_id) REFERENCES vouchers(id),
  FOREIGN KEY(ledger_id) REFERENCES ledgers(id)
);
```

## stock_items

```sql
CREATE TABLE stock_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  company_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  hsn_sac TEXT,
  unit TEXT,
  gst_rate REAL NOT NULL DEFAULT 0,
  opening_qty REAL NOT NULL DEFAULT 0,
  opening_value REAL NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY(company_id) REFERENCES companies(id)
);
```

## inventory_entries

```sql
CREATE TABLE inventory_entries (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  voucher_id INTEGER NOT NULL,
  stock_item_id INTEGER NOT NULL,
  quantity REAL NOT NULL,
  rate REAL NOT NULL,
  amount REAL NOT NULL,
  gst_rate REAL NOT NULL DEFAULT 0,
  FOREIGN KEY(voucher_id) REFERENCES vouchers(id),
  FOREIGN KEY(stock_item_id) REFERENCES stock_items(id)
);
```

## tax_entries

```sql
CREATE TABLE tax_entries (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  voucher_id INTEGER NOT NULL,
  tax_type TEXT NOT NULL,
  taxable_value REAL NOT NULL,
  cgst REAL NOT NULL DEFAULT 0,
  sgst REAL NOT NULL DEFAULT 0,
  igst REAL NOT NULL DEFAULT 0,
  cess REAL NOT NULL DEFAULT 0,
  FOREIGN KEY(voucher_id) REFERENCES vouchers(id)
);
```

## attachments

```sql
CREATE TABLE attachments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  company_id INTEGER NOT NULL,
  voucher_id INTEGER,
  file_name TEXT NOT NULL,
  file_path TEXT NOT NULL,
  mime_type TEXT,
  file_size INTEGER,
  created_at TEXT NOT NULL,
  FOREIGN KEY(company_id) REFERENCES companies(id),
  FOREIGN KEY(voucher_id) REFERENCES vouchers(id)
);
```
