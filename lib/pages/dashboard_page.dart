import 'package:erp_sample/themes/app_theme.dart';
import 'package:erp_sample/widgets/general.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/app_data_providers.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppDataProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(6),
          child: Badge(
            smallSize: 10,
            backgroundColor: Colors.green,
            child: CircleAvatar(
              radius: 30,
              backgroundImage: app.user.imageUrl == null
                  ? AssetImage("assets/images/dummy-user.png")
                  : NetworkImage(app.user.imageUrl!),
            )
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(app.company.name, style: AppTheme.textStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(app.user.name, style: AppTheme.textStyle(fontSize: 12),),
          ],
        ),
        actions: [
          Badge(
            smallSize: 8,
            backgroundColor: Colors.red,
            child: Icon(Icons.notifications, size: 30,)
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            greetingWidget(app.user.name.split(" ").first),

            sectionDivider(),

            totalBudgetUtilizationWidget(app.totalBudgetUtilization, app.totalBudget, app.totalSpent),

            sectionDivider(),

          ],
        ),
      ),
    );
  }

  Widget greetingWidget(String name) {
    return RichText(
      text: TextSpan(
        text: "Good Morning,\n",
        style: AppTheme.textStyle(fontSize: 25, fontWeight: FontWeight.bold),
        children: [
          TextSpan(
            text: name,
            style: AppTheme.textStyle(fontSize: 25, fontWeight: FontWeight.bold, color: AppTheme.primaryFgColor)
          )
        ]
      )
    );
  }

  Widget totalBudgetUtilizationWidget(double totalBudgetUtilization, double totalBudget, double totalSpent) {
    return Card(
      color: Colors.lightBlue.shade100.withAlpha(30),
      shape: RoundedRectangleBorder(borderRadius: AppTheme.cardBorderRadius),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Total Budget Utilization", style: AppTheme.textStyle(fontSize: 12, color: Colors.grey)),
            SizedBox(height: 5,),
            RichText(
              text: TextSpan(
                text: NumberFormat.compactCurrency(symbol: "৳ ", decimalDigits: 2).format(totalSpent),
                style: AppTheme.textStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                children: [
                  TextSpan(text: "/", style: AppTheme.textStyle(fontSize: 14, color: Colors.white.withAlpha(150))),
                  TextSpan(
                    text: NumberFormat.compactCurrency(symbol: "৳ ", decimalDigits: 2).format(totalBudget),
                    style: AppTheme.textStyle(fontSize: 16, color: Colors.white.withAlpha(150)),
                  )
                ]
              ),
            ),
            SizedBox(height: 8,),
            LinearProgressIndicator(
              minHeight: 15,
              value: totalBudgetUtilization,
            ),
            SizedBox(height: 8,),
            Row(
              children: [
                Expanded(child: Text("৳ 0", style: AppTheme.textStyle(color: Colors.white.withAlpha(150))),),
                Text("50%", style: AppTheme.textStyle(color: Colors.white.withAlpha(150))),
                Expanded(
                  child: Text(
                    NumberFormat.compactCurrency(symbol: "৳ ", decimalDigits: 2).format(totalBudget), textAlign: TextAlign.right,
                    style: AppTheme.textStyle(fontSize: 14, color: Colors.white.withAlpha(150))
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
