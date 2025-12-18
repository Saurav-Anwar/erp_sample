import 'package:erp_sample/providers/tab_navigation_provider.dart';
import 'package:erp_sample/themes/app_theme.dart';
import 'package:erp_sample/utils/helpers.dart';
import 'package:erp_sample/widgets/cards.dart';
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
          padding: const EdgeInsets.only(left: 16),
          child: Badge(
            smallSize: 10,
            backgroundColor: Colors.green,
            child: CircleAvatar(
              radius: 30,
              child: app.user.imageUrl == null
                  ? ClipOval(child: Image.asset("assets/images/dummy-user.png",))
                  : Image.network(app.user.imageUrl!),
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
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            greetingWidget(app.user.name.split(" ").first),

            sectionDivider(),

            totalBudgetUtilizationWidget(app.company.currency, app.totalBudgetUtilization, app.totalBudget, app.totalSpent),

            sectionDivider(),

            projectCountWidget(app.totalProjects, app.completedProjects),

            sectionDivider(),

            summarySection(context),

            sectionDivider(),

            recentProjectsSection(context),
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

  Widget totalBudgetUtilizationWidget(String currency, double totalBudgetUtilization, double totalBudget, double totalSpent) {
    return Card(
      color: AppTheme.primaryCardColor,
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
                text: formatMoneyShorthand(currency, totalSpent),
                style: AppTheme.textStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                children: [
                  TextSpan(text: "/", style: AppTheme.textStyle(fontSize: 14, color: Colors.white.withAlpha(150))),
                  TextSpan(
                    text: formatMoneyShorthand(currency, totalBudget),
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
                Expanded(child: Text(formatMoneyShorthand(currency, 0), style: AppTheme.textStyle(color: Colors.white.withAlpha(150))),),
                Text("50%", style: AppTheme.textStyle(color: Colors.white.withAlpha(150))),
                Expanded(
                  child: Text(
                    formatMoneyShorthand(currency, totalBudget), textAlign: TextAlign.right,
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

  Widget projectCountWidget(int totalProjects, int completedProjects) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        children: [
          genericKPI(label: "Total Projects", value: totalProjects.toString()),
          genericKPI(label: "Completed Projects", value: completedProjects.toString()),
          SizedBox(width: 20,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              iconSize: 25,
              minimumSize: Size(45, 45),
              padding: EdgeInsets.zero,
              shape: const CircleBorder()
            ),
            onPressed: () {

            },
            child: Icon(Icons.add)
          ),
        ],
      ),
    );
  }

  Widget summarySection(BuildContext context) {
    final app = context.watch<AppDataProvider>();
    
    return GridView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 150
      ),
      children: [
        summaryCard(
          title: "Active Projects",
          value: app.activeProjects.toString(),
          icon: Icon(Icons.business),
          isLight: false,
        ),

        summaryCard(
          title: "Approvals",
          value: app.totalApprovals.toString(),
          icon: Icon(Icons.business),
          isLight: true,
        ),

        summaryCard(
          title: "Open Tasks",
          value: app.inProgressTasks.length.toString(),
          icon: Icon(Icons.business),
          isLight: false,
        ),
      ],
    );
  }

  Widget recentProjectsSection(BuildContext context) {
    final app = context.watch<AppDataProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeader(
          title: "Recent Projects",
          trailing: TextButton(
              onPressed: () {
                context.read<TabNavigationProvider>().setIndex(1);
              },
              child: Text("View All", style: AppTheme.textStyle(fontSize: 14, color: AppTheme.primaryFgColor))
          ),
        ),

        SizedBox(height: 5,),

        SizedBox(
          height: 270,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return projectCard(context,project: app.recentProjects[index]);
            },
            separatorBuilder: (context, index) {
              return SizedBox(width: 10,);
            },
            itemCount: app.recentProjects.length
          ),
        ),
      ],
    );
  }
}
