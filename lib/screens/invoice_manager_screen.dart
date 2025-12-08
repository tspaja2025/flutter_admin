import 'package:shadcn_flutter/shadcn_flutter.dart';

// Implement rest

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
                          onPressed: () {},
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
                          onPressed: () => setState(() => creating = true),
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
        alignment: alignRight ? .centerRight : null,
        child: Text(text).muted().semiBold(),
      ),
    );
  }

  TableCell _buildCell(String text, [bool alignRight = false]) {
    return TableCell(
      child: Container(
        padding: const .all(8),
        alignment: alignRight ? .centerRight : null,
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
                  _buildHeaderCell("Amount"),
                  _buildHeaderCell("Actions"),
                ],
              ),
              // Body Rows
              TableRow(
                cells: [
                  _buildCell("INV-20250312"),
                  _buildCell("12/03/2025"),
                  _buildCell("31/03/2025"),
                  _buildCell("1"),
                  _buildCell("sent"),
                  _buildCell("\$400.00"),
                  TableCell(
                    child: Container(
                      padding: const .only(left: 8, right: 0),
                      alignment: .centerRight,
                      child: Row(
                        spacing: 8,
                        children: [
                          IconButton.outline(
                            onPressed: () {},
                            density: .iconDense,
                            icon: const Icon(LucideIcons.eye),
                          ),
                          IconButton.outline(
                            onPressed: () {},
                            density: .iconDense,
                            icon: const Icon(LucideIcons.pencil),
                          ),
                          IconButton.outline(
                            onPressed: () {},
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
                  child: TextField(placeholder: const Text("INV-20250312")),
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
                    // Disable selecting dates after "today".
                    stateBuilder: (date) => date.isAfter(DateTime.now())
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
                  child: TextField(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FormField(
                  key: FormKey(#clientEmail),
                  label: const Text("Client Email"),
                  child: TextField(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FormField(
            key: FormKey(#clientAddress),
            label: const Text("Client Address"),
            child: TextField(),
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
                onPressed: () {},
                density: .dense,
                leading: const Icon(LucideIcons.plus),
                child: const Text("Add item"),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Header row for items
          Row(
            children: [
              Expanded(child: Text("Description").semiBold()),
              SizedBox(width: 16),
              SizedBox(width: 100, child: Text("QTY").semiBold()),
              SizedBox(width: 16),
              SizedBox(width: 140, child: Text("Unit Price").semiBold()),
              SizedBox(width: 16),
              SizedBox(width: 120, child: Text("Tax %").semiBold()),
              SizedBox(width: 16),
              SizedBox(width: 140, child: Text("Amount").semiBold()),
              SizedBox(width: 16),
              SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: FormField(
                  key: FormKey(#description),
                  label: const Text("Description"),
                  child: TextField(placeholder: const Text("Description")),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 100,
                child: FormField(
                  key: FormKey(#qty),
                  label: const Text("Qty"),
                  child: TextField(placeholder: const Text("0")),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 140,
                child: FormField(
                  key: FormKey(#unitPrice),
                  label: const Text("Unit Price"),
                  child: TextField(placeholder: const Text("0.00")),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 120,
                child: FormField(
                  key: FormKey(#taxRate),
                  label: const Text("Tax Rate"),
                  child: TextField(placeholder: const Text("0")),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 140,
                child: FormField(
                  key: FormKey(#amount),
                  label: const Text("Amount"),
                  child: TextField(
                    placeholder: const Text("0.00"),
                    enabled: false,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              IconButton.outline(
                onPressed: () {},
                density: ButtonDensity.icon,
                icon: const Icon(LucideIcons.trash2),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Text("Subtotal: "), Text("\$0.00")],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Text("Tax: "), Text("\$0.00")],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Text("Total: "), Text("\$0.00")],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 24),

          // Notes
          const Text("Notes").semiBold(),
          const SizedBox(height: 16),
          TextArea(
            initialValue: "Payment terms, additional information, etc",
            expandableHeight: true,
            initialHeight: 120,
          ),
        ],
      ),
    );
  }
}
