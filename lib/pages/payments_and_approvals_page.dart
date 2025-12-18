import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_data_providers.dart';

class PaymentsApprovalsPage extends StatelessWidget {
  const PaymentsApprovalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppDataProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(app.company.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Projects: ${app.totalProjects}'),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: app.totalBudgetUtilization),
          ],
        ),
      ),
    );
  }
}
