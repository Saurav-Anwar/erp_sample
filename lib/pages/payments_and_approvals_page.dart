import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:erp_sample/themes/app_theme.dart';
import 'package:erp_sample/widgets/cards.dart';
import 'package:erp_sample/widgets/general.dart';
import '../providers/app_data_providers.dart';

class PaymentsApprovalsPage extends StatefulWidget {
  const PaymentsApprovalsPage({super.key});

  @override
  State<PaymentsApprovalsPage> createState() => _PaymentsApprovalsPageState();
}

class _PaymentsApprovalsPageState extends State<PaymentsApprovalsPage> {
  String searchQuery = '';
  String selectedStatus = 'All';
  final List<String> statusList = const ['All', 'Pending', 'Approved'];

  String paymentStatusLabel(dynamic payment) {
    return payment.approvalFlow.status == 'Approved' ? 'Approved' : 'Pending';
  }

  DateTime? safeParseDate(String iso) {
    try {
      return DateTime.parse(iso);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppDataProvider>();

    if (!app.hasData || app.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final Map<String, String> paymentProjectName = {};
    for (final project in app.projects) {
      for (final p in project.payments) {
        paymentProjectName[p.paymentId] = project.name;
      }
    }

    final query = searchQuery.trim().toLowerCase();
    final filteredPayments = app.allPayments.where((payment) {
      final status = paymentStatusLabel(payment);
      final statusMatches = selectedStatus == 'All' || status == selectedStatus;

      if (query.isEmpty) return statusMatches;

      final pName = (paymentProjectName[payment.paymentId] ?? '').toLowerCase();
      final vendors = payment.invoices.map((i) => i.vendor.toLowerCase()).join(' ');
      final searchMatches = payment.paymentId.toLowerCase().contains(query) ||
          payment.requestedBy.toLowerCase().contains(query) ||
          payment.approvalFlow.approvedBy.toLowerCase().contains(query) ||
          pName.contains(query) ||
          vendors.contains(query);

      return statusMatches && searchMatches;
    }).toList();

    filteredPayments.sort((a, b) {
      final sa = paymentStatusLabel(a);
      final sb = paymentStatusLabel(b);
      if (sa != sb) {
        return sa == 'Pending' ? -1 : 1;
      }
      final da = safeParseDate(a.requestDate);
      final db = safeParseDate(b.requestDate);
      if (da != null && db != null) return db.compareTo(da);
      return a.paymentId.compareTo(b.paymentId);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Payments & Approvals', style: AppTheme.textStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.all(5),
              child: Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search Payments... ',
                  hintStyle: AppTheme.textStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  filled: true,
                  fillColor: Color.alphaBlend(Colors.grey.shade200.withAlpha(70), AppTheme.primaryBgColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: statusList.map((status) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      selectedColor: AppTheme.primaryFgColor,
                      surfaceTintColor: Colors.transparent,
                      backgroundColor: Color.alphaBlend(Colors.white30, AppTheme.primaryBgColor),
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppTheme.cardBorderRadius,
                        side: const BorderSide(color: Colors.transparent),
                      ),
                      label: Text(
                        status,
                        style: AppTheme.textStyle(color: selectedStatus == status ? AppTheme.primaryBgColor : Colors.white),
                      ),
                      selected: selectedStatus == status,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            selectedStatus = status;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            sectionDivider(),

            Expanded(
              child: filteredPayments.isEmpty
                  ? Center(
                      child: Text('No payments found', style: AppTheme.textStyle(color: Colors.white.withAlpha(160))),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(bottom: 20),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Row(
                            children: [
                              genericKPI(label: 'Total', value: app.allPayments.length.toString()),
                              genericKPI(label: 'Pending', value: app.pendingApprovals.toString()),
                              genericKPI(label: 'Approved', value: app.totalApprovals.toString()),
                            ],
                          );
                        }
                        else {
                          final payment = filteredPayments[index - 1];
                          return paymentRequestCard(
                            context,
                            payment: payment,
                            currency: app.company.currency,
                            projectName: paymentProjectName[payment.paymentId],
                          );
                        }

                      },
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemCount: filteredPayments.length + 1,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
