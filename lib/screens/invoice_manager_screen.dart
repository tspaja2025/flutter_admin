import "package:shadcn_flutter/shadcn_flutter.dart";

class InvoiceManagerScreen extends StatefulWidget {
  const InvoiceManagerScreen({super.key});

  @override
  State<InvoiceManagerScreen> createState() => InvoiceManagerScreenState();
}

class InvoiceManagerScreenState extends State<InvoiceManagerScreen> {
  String? _selectedValue;
  DateTime? _invoiceDate;
  DateTime? _invoiceDueDate;
  bool creating = false;

  // Invoice state
  final List<Invoice> _invoices = [];
  final TextEditingController _invoiceNumberController =
      TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _clientEmailController = TextEditingController();
  final TextEditingController _clientAddressController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController(text: "1");
  final TextEditingController _unitPriceController = TextEditingController(
    text: "0.00",
  );
  final TextEditingController _taxRateController = TextEditingController(
    text: "0",
  );
  final TextEditingController _notesController = TextEditingController(
    text: "Payment terms, additional information, etc",
  );

  List<InvoiceItem> _lineItems = [];
  double _subtotal = 0.0;
  double _tax = 0.0;
  double _total = 0.0;

  @override
  void initState() {
    super.initState();
    _loadInvoices();
    _initializeNewInvoice();
  }

  void _loadInvoices() {
    // Load sample data
    _invoices.addAll([
      Invoice(
        number: "INV-20250312",
        date: DateTime(2025, 3, 12),
        dueDate: DateTime(2025, 3, 31),
        items: 1,
        status: InvoiceStatus.sent,
        amount: 400.0,
      ),
      Invoice(
        number: "INV-20250310",
        date: DateTime(2025, 3, 10),
        dueDate: DateTime(2025, 3, 25),
        items: 3,
        status: InvoiceStatus.paid,
        amount: 1250.0,
      ),
      Invoice(
        number: "INV-20250305",
        date: DateTime(2025, 3, 5),
        dueDate: DateTime(2025, 3, 20),
        items: 2,
        status: InvoiceStatus.draft,
        amount: 750.0,
      ),
    ]);
  }

  void _initializeNewInvoice() {
    final now = DateTime.now();
    _invoiceDate = now;
    _invoiceDueDate = now.add(const Duration(days: 30));
    _invoiceNumberController.text =
        "INV-${now.year}${now.month.toString().padLeft(2, "0")}${now.day.toString().padLeft(2, "0")}";
    _selectedValue = "Draft";
    _recalculateTotals();
  }

  void _recalculateTotals() {
    _subtotal = 0.0;
    _tax = 0.0;

    for (var item in _lineItems) {
      final itemTotal = item.quantity * item.unitPrice;
      final itemTax = itemTotal * (item.taxRate / 100);
      _subtotal += itemTotal;
      _tax += itemTax;
    }

    _total = _subtotal + _tax;

    setState(() {});
  }

  void _addLineItem() {
    final description = _descriptionController.text.trim();
    final quantity = double.tryParse(_qtyController.text) ?? 0;
    final unitPrice = double.tryParse(_unitPriceController.text) ?? 0;
    final taxRate = double.tryParse(_taxRateController.text) ?? 0;

    if (description.isEmpty || quantity <= 0 || unitPrice <= 0) {
      showToast(
        context: context,
        builder: (context, overlay) {
          return SurfaceCard(
            child: Basic(title: const Text("Please fill all required fields")),
          );
        },
      );
      return;
    }

    final newItem = InvoiceItem(
      description: description,
      quantity: quantity,
      unitPrice: unitPrice,
      taxRate: taxRate,
    );

    setState(() {
      _lineItems.add(newItem);
      _descriptionController.clear();
      _qtyController.text = "1";
      _unitPriceController.text = "0.00";
      _taxRateController.text = "0";
    });

    _recalculateTotals();
  }

  void _removeLineItem(int index) {
    setState(() {
      _lineItems.removeAt(index);
    });
    _recalculateTotals();
  }

  void _saveInvoice() {
    if (_clientNameController.text.trim().isEmpty) {
      showToast(
        context: context,
        builder: (context, overlay) {
          return SurfaceCard(
            child: Basic(title: const Text("Client name is required")),
          );
        },
      );
      return;
    }

    if (_lineItems.isEmpty) {
      showToast(
        context: context,
        builder: (context, overlay) {
          return SurfaceCard(
            child: Basic(title: const Text("Add at least one line item")),
          );
        },
      );
      return;
    }

    final newInvoice = Invoice(
      number: _invoiceNumberController.text.trim(),
      date: _invoiceDate!,
      dueDate: _invoiceDueDate!,
      items: _lineItems.length,
      status: InvoiceStatus.values.firstWhere(
        (status) => status.toString().split(".").last == _selectedValue,
        orElse: () => InvoiceStatus.draft,
      ),
      amount: _total,
      clientName: _clientNameController.text.trim(),
      clientEmail: _clientEmailController.text.trim(),
      clientAddress: _clientAddressController.text.trim(),
      lineItems: List.from(_lineItems),
      notes: _notesController.text.trim(),
    );

    setState(() {
      _invoices.add(newInvoice);
      creating = false;
    });

    _resetForm();
    showToast(
      context: context,
      builder: (context, overlay) {
        return SurfaceCard(
          child: Basic(title: const Text("Invoice saved successfully")),
        );
      },
    );
  }

  void _resetForm() {
    _lineItems.clear();
    _clientNameController.clear();
    _clientEmailController.clear();
    _clientAddressController.clear();
    _notesController.text = "Payment terms, additional information, etc";
    _initializeNewInvoice();
  }

  void _viewInvoice(Invoice invoice) {
    // Navigate to invoice detail view or show dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Invoice ${invoice.number}"),
        content: Column(
          crossAxisAlignment: .start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Client: ${invoice.clientName}"),
            Text("Amount: \$${invoice.amount.toStringAsFixed(2)}"),
            Text("Status: ${invoice.status.toString().split(".").last}"),
            const SizedBox(height: 16),
            if (invoice.notes.isNotEmpty) ...[
              const Text("Notes:", style: TextStyle(fontWeight: .bold)),
              Text(invoice.notes),
            ],
          ],
        ),
        actions: [
          Button.outline(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _editInvoice(Invoice invoice) {
    setState(() {
      creating = true;
      _invoiceNumberController.text = invoice.number;
      _selectedValue = invoice.status.toString().split(".").last;
      _invoiceDate = invoice.date;
      _invoiceDueDate = invoice.dueDate;
      _clientNameController.text = invoice.clientName;
      _clientEmailController.text = invoice.clientEmail;
      _clientAddressController.text = invoice.clientAddress;
      _lineItems = List.from(invoice.lineItems);
      _notesController.text = invoice.notes;
      _recalculateTotals();
    });

    // Remove the invoice from list since we"re editing it
    _invoices.remove(invoice);
  }

  void _deleteInvoice(Invoice invoice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Invoice"),
        content: Text(
          "Are you sure you want to delete invoice ${invoice.number}?",
        ),
        actions: [
          Button.outline(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          Button.destructive(
            onPressed: () {
              setState(() {
                _invoices.remove(invoice);
              });
              Navigator.pop(context);
              showToast(
                context: context,
                builder: (context, overlay) {
                  return SurfaceCard(
                    child: Basic(title: const Text("Invoice deleted")),
                  );
                },
              );
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const .all(24),
              child: Column(
                children: [
                  if (creating)
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        SecondaryButton(
                          onPressed: () => setState(() => creating = false),
                          density: .dense,
                          leading: const Icon(LucideIcons.chevronLeft),
                          child: const Text("Back"),
                        ),
                        PrimaryButton(
                          onPressed: _saveInvoice,
                          density: .dense,
                          leading: const Icon(LucideIcons.save),
                          child: const Text("Save Invoice"),
                        ),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: .end,
                      children: [
                        PrimaryButton(
                          onPressed: () {
                            setState(() {
                              creating = true;
                              _resetForm();
                            });
                          },
                          density: .dense,
                          leading: const Icon(LucideIcons.plus),
                          child: const Text("New Invoice"),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  if (creating) _buildNewInvoice() else _buildListView(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  TableCell _buildHeaderCell(String text, [bool alignRight = false]) {
    return TableCell(
      child: Container(
        padding: const .all(8),
        alignment: alignRight ? Alignment.centerRight : null,
        child: Text(text).muted().semiBold(),
      ),
    );
  }

  TableCell _buildCell(String text, [bool alignRight = false]) {
    return TableCell(
      child: Container(
        padding: const .all(8),
        alignment: alignRight ? Alignment.centerRight : null,
        child: Text(text),
      ),
    );
  }

  Widget _buildListView() {
    return Card(
      child: Column(
        children: [
          Table(
            rows: [
              // Header Row
              TableRow(
                cells: [
                  _buildHeaderCell("Invoice Number"),
                  _buildHeaderCell("Date"),
                  _buildHeaderCell("Due Date"),
                  _buildHeaderCell("Items"),
                  _buildHeaderCell("Status"),
                  _buildHeaderCell("Amount", true),
                  _buildHeaderCell("Actions"),
                ],
              ),
              // Body Rows
              for (var invoice in _invoices)
                TableRow(
                  cells: [
                    _buildCell(invoice.number),
                    _buildCell(_formatDate(invoice.date)),
                    _buildCell(_formatDate(invoice.dueDate)),
                    _buildCell(invoice.items.toString()),
                    TableCell(
                      child: Container(
                        padding: const .all(8),
                        child: PrimaryBadge(
                          child: Text(
                            invoice.status.toString().split(".").last,
                          ),
                        ),
                      ),
                    ),
                    _buildCell("\$${invoice.amount.toStringAsFixed(2)}", true),
                    TableCell(
                      child: Container(
                        padding: const .only(left: 8, right: 0),
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 8,
                          children: [
                            IconButton.outline(
                              onPressed: () => _viewInvoice(invoice),
                              density: .iconDense,
                              icon: const Icon(LucideIcons.eye),
                            ),
                            IconButton.outline(
                              onPressed: () => _editInvoice(invoice),
                              density: .iconDense,
                              icon: const Icon(LucideIcons.pencil),
                            ),
                            IconButton.destructive(
                              onPressed: () => _deleteInvoice(invoice),
                              density: .iconDense,
                              icon: const Icon(LucideIcons.trash2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          if (_invoices.isEmpty)
            Container(
              padding: const .all(32),
              child: Column(
                children: [
                  Icon(
                    LucideIcons.fileText,
                    size: 48,
                    color: Colors.gray.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text("No invoices yet").muted(),
                  const SizedBox(height: 8),
                  Text(
                    "Click 'New Invoice' to create your first invoice",
                  ).small().muted(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNewInvoice() {
    return Card(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          const Text("New Invoice").semiBold().x2Large(),
          const SizedBox(height: 24),

          // Invoice Details
          const Text("Invoice Details").semiBold(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FormField(
                  key: FormKey(#invoiceNumber),
                  label: const Text("Invoice Number"),
                  child: TextField(
                    controller: _invoiceNumberController,
                    placeholder: const Text("INV-20250312"),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FormField(
                  key: FormKey(#invoiceStatus),
                  label: const Text("Invoice Status"),
                  child: Select<String>(
                    itemBuilder: (context, item) => Text(item),
                    value: _selectedValue,
                    placeholder: const Text("Select A Status"),
                    onChanged: (value) =>
                        setState(() => _selectedValue = value),
                    popup: SelectPopup(
                      items: SelectItemList(
                        children: [
                          SelectItemButton(
                            value: "Draft",
                            child: const Text("Draft"),
                          ),
                          SelectItemButton(
                            value: "Sent",
                            child: const Text("Sent"),
                          ),
                          SelectItemButton(
                            value: "Paid",
                            child: const Text("Paid"),
                          ),
                          SelectItemButton(
                            value: "Overdue",
                            child: const Text("Overdue"),
                          ),
                        ],
                      ),
                    ).call,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FormField(
                  key: FormKey(#invoiceDate),
                  label: const Text("Invoice Date"),
                  child: DatePicker(
                    value: _invoiceDate,
                    mode: PromptMode.popover,
                    // Disable selecting dates after "today".
                    stateBuilder: (date) => date.isAfter(DateTime.now())
                        ? DateState.disabled
                        : DateState.enabled,
                    onChanged: (value) => setState(() => _invoiceDate = value),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FormField(
                  key: FormKey(#invoiceDueDate),
                  label: const Text("Invoice Due Date"),
                  child: DatePicker(
                    value: _invoiceDueDate,
                    mode: PromptMode.popover,
                    // Allow selecting dates in the future for due date
                    stateBuilder: (date) =>
                        date.isBefore(_invoiceDate ?? DateTime.now())
                        ? DateState.disabled
                        : DateState.enabled,
                    onChanged: (value) =>
                        setState(() => _invoiceDueDate = value),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 24),

          // Client Information
          const Text("Client Information").semiBold(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FormField(
                  key: FormKey(#clientName),
                  label: const Text("Client Name"),
                  child: TextField(
                    controller: _clientNameController,
                    placeholder: const Text("John Doe"),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FormField(
                  key: FormKey(#clientEmail),
                  label: const Text("Client Email"),
                  child: TextField(
                    controller: _clientEmailController,
                    placeholder: const Text("john@example.com"),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FormField(
            key: FormKey(#clientAddress),
            label: const Text("Client Address"),
            child: TextField(
              controller: _clientAddressController,
              placeholder: const Text("123 Main St, City, Country"),
            ),
          ),

          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 24),

          // Line Items
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              const Text("Line Items").semiBold(),
              PrimaryButton(
                onPressed: _addLineItem,
                density: .dense,
                leading: const Icon(LucideIcons.plus),
                child: const Text("Add item"),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Existing line items
          if (_lineItems.isNotEmpty) ...[
            // Header row for items
            Container(
              padding: const .all(8),
              decoration: BoxDecoration(
                color: Colors.gray.shade50,
                borderRadius: .circular(4),
              ),
              child: Row(
                children: [
                  Expanded(child: Text("Description").semiBold()),
                  const SizedBox(width: 16),
                  SizedBox(width: 100, child: Text("QTY").semiBold()),
                  const SizedBox(width: 16),
                  SizedBox(width: 140, child: Text("Unit Price").semiBold()),
                  const SizedBox(width: 16),
                  SizedBox(width: 120, child: Text("Tax %").semiBold()),
                  const SizedBox(width: 16),
                  SizedBox(width: 140, child: Text("Amount").semiBold()),
                  const SizedBox(width: 16),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            const SizedBox(height: 8),
            for (int i = 0; i < _lineItems.length; i++) _buildLineItemRow(i),
            const SizedBox(height: 16),
          ],

          // New line item form
          Container(
            padding: const .all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.gray.shade200),
              borderRadius: .circular(8),
            ),
            child: Row(
              crossAxisAlignment: .end,
              children: [
                Expanded(
                  child: FormField(
                    key: FormKey(#description),
                    label: const Text("Description"),
                    child: TextField(
                      controller: _descriptionController,
                      placeholder: const Text("Description"),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 100,
                  child: FormField(
                    key: FormKey(#qty),
                    label: const Text("Qty"),
                    child: TextField(
                      controller: _qtyController,
                      placeholder: const Text("0"),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 140,
                  child: FormField(
                    key: FormKey(#unitPrice),
                    label: const Text("Unit Price"),
                    child: TextField(
                      controller: _unitPriceController,
                      placeholder: const Text("0.00"),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 120,
                  child: FormField(
                    key: FormKey(#taxRate),
                    label: const Text("Tax Rate"),
                    child: TextField(
                      controller: _taxRateController,
                      placeholder: const Text("0"),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 140,
                  child: FormField(
                    key: FormKey(#amount),
                    label: const Text("Amount"),
                    child: TextField(
                      placeholder: Text(
                        _calculateLineItemAmount().toStringAsFixed(2),
                      ),
                      enabled: false,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                IconButton.outline(
                  onPressed: () {
                    _descriptionController.clear();
                    _qtyController.text = "1";
                    _unitPriceController.text = "0.00";
                    _taxRateController.text = "0";
                  },
                  density: .icon,
                  icon: const Icon(LucideIcons.x),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Totals
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 300,
              padding: const .all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.gray.shade200),
                borderRadius: .circular(8),
              ),
              child: Column(
                crossAxisAlignment: .end,
                children: [
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      const Text("Subtotal: ").semiBold(),
                      Text("\$${_subtotal.toStringAsFixed(2)}").semiBold(),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      const Text("Tax: ").semiBold(),
                      Text("\$${_tax.toStringAsFixed(2)}").semiBold(),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      const Text("Total: ").xLarge().semiBold(),
                      Text(
                        "\$${_total.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 20, fontWeight: .bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 24),

          // Notes
          const Text("Notes").semiBold(),
          const SizedBox(height: 16),
          TextArea(
            controller: _notesController,
            expandableHeight: true,
            initialHeight: 120,
          ),
        ],
      ),
    );
  }

  Widget _buildLineItemRow(int index) {
    final item = _lineItems[index];
    final amount = item.quantity * item.unitPrice;
    final taxAmount = amount * (item.taxRate / 100);
    final total = amount + taxAmount;

    return Container(
      padding: const .all(8),
      margin: const .only(bottom: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.gray.shade100),
        borderRadius: .circular(4),
      ),
      child: Row(
        children: [
          Expanded(child: Text(item.description)),
          const SizedBox(width: 16),
          SizedBox(width: 100, child: Text(item.quantity.toStringAsFixed(0))),
          const SizedBox(width: 16),
          SizedBox(
            width: 140,
            child: Text("\$${item.unitPrice.toStringAsFixed(2)}"),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 120,
            child: Text("${item.taxRate.toStringAsFixed(1)}%"),
          ),
          const SizedBox(width: 16),
          SizedBox(width: 140, child: Text("\$${total.toStringAsFixed(2)}")),
          const SizedBox(width: 16),
          IconButton.outline(
            onPressed: () => _removeLineItem(index),
            density: .icon,
            icon: const Icon(LucideIcons.trash2),
          ),
        ],
      ),
    );
  }

  double _calculateLineItemAmount() {
    final quantity = double.tryParse(_qtyController.text) ?? 0;
    final unitPrice = double.tryParse(_unitPriceController.text) ?? 0;
    final taxRate = double.tryParse(_taxRateController.text) ?? 0;
    final amount = quantity * unitPrice;
    return amount + (amount * (taxRate / 100));
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, "0")}/${date.month.toString().padLeft(2, "0")}/${date.year}";
  }

  @override
  void dispose() {
    _invoiceNumberController.dispose();
    _clientNameController.dispose();
    _clientEmailController.dispose();
    _clientAddressController.dispose();
    _descriptionController.dispose();
    _qtyController.dispose();
    _unitPriceController.dispose();
    _taxRateController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}

// Data Models
enum InvoiceStatus { draft, sent, paid, overdue }

class Invoice {
  final String number;
  final DateTime date;
  final DateTime dueDate;
  final int items;
  final InvoiceStatus status;
  final double amount;
  final String clientName;
  final String clientEmail;
  final String clientAddress;
  final List<InvoiceItem> lineItems;
  final String notes;

  Invoice({
    required this.number,
    required this.date,
    required this.dueDate,
    required this.items,
    required this.status,
    required this.amount,
    this.clientName = "",
    this.clientEmail = "",
    this.clientAddress = "",
    this.lineItems = const [],
    this.notes = "",
  });
}

class InvoiceItem {
  final String description;
  final double quantity;
  final double unitPrice;
  final double taxRate;

  InvoiceItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.taxRate,
  });
}
