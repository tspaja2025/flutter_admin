import 'package:shadcn_flutter/shadcn_flutter.dart';

class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({super.key});

  final hasInvoices = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .all(16),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          SecondaryButton(
            leading: const Icon(LucideIcons.plus),
            onPressed: () {},
            child: const Text("Create New Invoice"),
          ),
          const SizedBox(height: 8),
          Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: Card(
                  padding: const .all(16),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      const Text('Invoice Manager').semiBold(),
                      const SizedBox(height: 4),
                      const Text(
                        'Create and manage your invoices.',
                      ).muted().small(),
                      const SizedBox(height: 58),
                      if (!hasInvoices)
                        Center(
                          child: Column(
                            children: [
                              const Text('No invoices yet').semiBold(),
                              const SizedBox(height: 4),
                              const Text(
                                'Get started by creating your first invoice.',
                              ).muted().small(),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
