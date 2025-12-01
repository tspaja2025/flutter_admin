import 'package:shadcn_flutter/shadcn_flutter.dart';

class LineItem {
  final TextEditingController description = TextEditingController();
  final TextEditingController quantity = TextEditingController(text: '1');
  final TextEditingController unitPrice = TextEditingController(text: '0.00');
  final TextEditingController amount = TextEditingController(text: '0.00');

  void dispose() {
    description.dispose();
    quantity.dispose();
    unitPrice.dispose();
    amount.dispose();
  }
}

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  // --- State ---
  bool hasInvoices = false;
  bool creating = false;

  String? status;
  DateTime? invoiceDate;
  DateTime? dueDate;

  // Form controllers
  final TextEditingController invoiceNumberCtrl = TextEditingController();
  final TextEditingController clientNameCtrl = TextEditingController();
  final TextEditingController clientEmailCtrl = TextEditingController();
  final TextEditingController clientAddressCtrl = TextEditingController();
  final TextEditingController taxRateCtrl = TextEditingController(text: '0');
  final TextEditingController notesCtrl = TextEditingController();

  List<LineItem> items = [LineItem()];

  // Layout constants
  static const double _cardPadding = 16.0;
  static const double _sectionSpacing = 16.0;
  static const double _fieldSpacing = 16.0;

  @override
  void dispose() {
    invoiceNumberCtrl.dispose();
    clientNameCtrl.dispose();
    clientEmailCtrl.dispose();
    clientAddressCtrl.dispose();
    taxRateCtrl.dispose();
    notesCtrl.dispose();
    for (final i in items) {
      i.dispose();
    }
    super.dispose();
  }

  // --- Helpers ---
  Widget _sectionHeader(String title, {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title).semiBold().large(),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(subtitle).muted().small(),
        ],
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _field({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: _fieldSpacing),
      child: child,
    );
  }

  double _parseCurrency(String s) {
    try {
      return double.parse(s.replaceAll(',', ''));
    } catch (_) {
      return 0.0;
    }
  }

  double get subtotal {
    double sum = 0.0;
    for (final it in items) {
      final q = _parseCurrency(it.quantity.text);
      final p = _parseCurrency(it.unitPrice.text);
      final amt = q * p;
      sum += amt;
      // keep amount controller in sync (safe because readOnly)
      it.amount.text = amt.toStringAsFixed(2);
    }
    return sum;
  }

  double get taxRate {
    return _parseCurrency(taxRateCtrl.text) / 100.0;
  }

  double get taxAmount => subtotal * taxRate;

  double get total => subtotal + taxAmount;

  // --- Actions ---
  void _addItem() {
    setState(() {
      items.add(LineItem());
    });
  }

  void _removeItem(int index) {
    setState(() {
      items[index].dispose();
      items.removeAt(index);
    });
  }

  void _saveAsDraft() {
    // placeholder: implement persistence
    setState(() => creating = false);
  }

  void _saveAndSend() {
    // placeholder: implement validation + send
    setState(() => creating = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 900;
          final formColumnWidth = isWide
              ? (constraints.maxWidth - 48) * 0.6
              : constraints.maxWidth;
          final sideColumnWidth = isWide
              ? (constraints.maxWidth - 48) * 0.4
              : constraints.maxWidth;

          return SingleChildScrollView(
            child: creating
                ? _buildCreateForm(isWide, formColumnWidth, sideColumnWidth)
                : _buildListView(),
          );
        },
      ),
    );
  }

  Widget _buildListView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SecondaryButton(
          onPressed: () => setState(() => creating = true),
          density: ButtonDensity.icon,
          leading: const Icon(LucideIcons.plus),
          child: const Text('Create New Invoice'),
        ),
        const SizedBox(height: _sectionSpacing),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(_cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeader(
                  'Invoice Manager',
                  subtitle: 'Create and manage your invoices.',
                ),
                if (!hasInvoices)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.gray.shade200),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.fileText,
                            size: 48,
                            color: Colors.gray.shade400,
                          ),
                          const SizedBox(height: 12),
                          const Text('No invoices yet').semiBold().medium(),
                          const SizedBox(height: 8),
                          const Text(
                            'Get started by creating your first invoice.',
                            textAlign: TextAlign.center,
                          ).muted(),
                          const SizedBox(height: 16),
                          PrimaryButton(
                            onPressed: () => setState(() => creating = true),
                            child: const Text('Create First Invoice'),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreateForm(bool isWide, double formWidth, double sideWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Action row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SecondaryButton(
              onPressed: () => setState(() => creating = false),
              density: ButtonDensity.icon,
              leading: const Icon(LucideIcons.chevronLeft, size: 16),
              child: const Text('Back'),
            ),
            Row(
              children: [
                SecondaryButton(
                  onPressed: _saveAsDraft,
                  child: const Text('Save Draft'),
                ),
                const SizedBox(width: 8),
                PrimaryButton(
                  onPressed: _saveAndSend,
                  leading: const Icon(LucideIcons.save, size: 16),
                  child: const Text('Save & Send'),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: _sectionSpacing),

        // Main content: left form and right summary (on wide screens)
        isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: formWidth, child: _buildLeftColumn()),
                  const SizedBox(width: 24),
                  SizedBox(width: sideWidth, child: _buildRightColumn()),
                ],
              )
            : Column(
                children: [
                  _buildLeftColumn(),
                  const SizedBox(height: 16),
                  _buildRightColumn(),
                ],
              ),
      ],
    );
  }

  Widget _buildLeftColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(_cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeader('Invoice Details'),
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    SizedBox(
                      width: 300,
                      child: FormField(
                        key: FormKey(#invoiceNumber),
                        label: const Text('Invoice Number').muted().small(),
                        child: TextField(
                          controller: invoiceNumberCtrl,
                          placeholder: const Text('INV-20251201'),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 220,
                      child: FormField(
                        key: FormKey(#status),
                        label: const Text('Status').muted().small(),
                        child: Select<String>(
                          itemBuilder: (context, item) => Text(item),
                          value: status,
                          placeholder: const Text('Select status'),
                          popupConstraints: const BoxConstraints(
                            maxHeight: 260,
                            maxWidth: 220,
                          ),
                          onChanged: (v) => setState(() => status = v),
                          popup: const SelectPopup(
                            items: SelectItemList(
                              children: [
                                SelectItemButton(
                                  value: 'Draft',
                                  child: Text('Draft'),
                                ),
                                SelectItemButton(
                                  value: 'Sent',
                                  child: Text('Sent'),
                                ),
                                SelectItemButton(
                                  value: 'Paid',
                                  child: Text('Paid'),
                                ),
                                SelectItemButton(
                                  value: 'Overdue',
                                  child: Text('Overdue'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 220,
                      child: FormField(
                        key: FormKey(#invoiceDate),
                        label: const Text('Invoice Date').muted().small(),
                        child: DatePicker(
                          value: invoiceDate,
                          mode: PromptMode.popover,
                          placeholder: const Text('Select date'),
                          stateBuilder: (d) => d.isAfter(DateTime.now())
                              ? DateState.disabled
                              : DateState.enabled,
                          onChanged: (v) => setState(() => invoiceDate = v),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 220,
                      child: FormField(
                        key: FormKey(#dueDate),
                        label: const Text('Due Date').muted().small(),
                        child: DatePicker(
                          value: dueDate,
                          mode: PromptMode.popover,
                          placeholder: const Text('Select due date'),
                          stateBuilder: (d) => DateState.enabled,
                          onChanged: (v) => setState(() => dueDate = v),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: _sectionSpacing),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(_cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeader('Client Information'),
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    SizedBox(
                      width: 340,
                      child: FormField(
                        key: FormKey(#clientName),
                        label: const Text('Client Name').muted().small(),
                        child: TextField(
                          controller: clientNameCtrl,
                          placeholder: const Text('Client or company'),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 340,
                      child: FormField(
                        key: FormKey(#clientEmail),
                        label: const Text('Client Email').muted().small(),
                        child: TextField(
                          controller: clientEmailCtrl,
                          placeholder: const Text('email@example.com'),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 700,
                      child: FormField(
                        key: FormKey(#clientAddress),
                        label: const Text('Client Address').muted().small(),
                        child: TextField(
                          controller: clientAddressCtrl,
                          placeholder: const Text('Street, City, ZIP'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: _sectionSpacing),

        // Line items card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(_cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _sectionHeader('Line Items'),
                    OutlineButton(
                      onPressed: _addItem,
                      leading: const Icon(LucideIcons.plus, size: 16),
                      child: const Text('Add Item'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Header row
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                  child: Row(
                    children: [
                      Expanded(flex: 4, child: Text('Description').muted()),
                      SizedBox(width: 12),
                      SizedBox(width: 80, child: Text('Qty').muted()),
                      SizedBox(width: 12),
                      SizedBox(width: 120, child: Text('Unit Price').muted()),
                      SizedBox(width: 12),
                      SizedBox(width: 120, child: Text('Amount').muted()),
                      SizedBox(width: 12),
                      SizedBox(width: 40),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                ...items.asMap().entries.map((e) {
                  final idx = e.key;
                  final it = e.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: TextField(
                            controller: it.description,
                            placeholder: const Text('Item description'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 80,
                          child: TextField(
                            controller: it.quantity,
                            placeholder: const Text('1'),
                            keyboardType: TextInputType.number,
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 120,
                          child: TextField(
                            controller: it.unitPrice,
                            placeholder: const Text('0.00'),
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 120,
                          child: TextField(
                            controller: it.amount,
                            readOnly: true,
                            placeholder: const Text('0.00'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 40,
                          child: IconButton.ghost(
                            onPressed: () => _removeItem(idx),
                            icon: const Icon(LucideIcons.trash, size: 16),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),

                // Totals and tax
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 320,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Subtotal:').muted(),
                              Text(
                                '\$${subtotal.toStringAsFixed(2)}',
                              ).semiBold(),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: const Text('Tax rate (%)').muted(),
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                width: 80,
                                child: TextField(
                                  controller: taxRateCtrl,
                                  placeholder: const Text('0'),
                                  keyboardType: TextInputType.number,
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Tax:').muted(),
                              Text(
                                '\$${taxAmount.toStringAsFixed(2)}',
                              ).semiBold(),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total:').large().semiBold(),
                              Text(
                                '\$${total.toStringAsFixed(2)}',
                              ).large().semiBold(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: _sectionSpacing),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(_cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeader('Notes'),
                FormField(
                  key: FormKey(#notes),
                  label: const Text('Additional notes').muted().small(),
                  child: TextField(
                    controller: notesCtrl,
                    maxLines: 4,
                    placeholder: const Text(
                      'Payment terms, special instructions...',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRightColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(_cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeader('Summary'),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Invoice #').muted(),
                    Text(
                      invoiceNumberCtrl.text.isEmpty
                          ? '(not set)'
                          : invoiceNumberCtrl.text,
                    ).semiBold(),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Client').muted(),
                    Expanded(
                      child: Text(
                        clientNameCtrl.text.isEmpty
                            ? '(not set)'
                            : clientNameCtrl.text,
                        textAlign: TextAlign.right,
                      ),
                    ).semiBold(),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal').muted(),
                    Text('\$${subtotal.toStringAsFixed(2)}').semiBold(),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tax').muted(),
                    Text('\$${taxAmount.toStringAsFixed(2)}').semiBold(),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total').large().semiBold(),
                    Text('\$${total.toStringAsFixed(2)}').large().semiBold(),
                  ],
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  onPressed: _saveAndSend,
                  child: const Text('Save & Send'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
