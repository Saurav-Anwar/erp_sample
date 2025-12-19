import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../models/budget.dart';
import '../models/project.dart';
import '../models/team.dart';
import '../providers/app_data_providers.dart';
import '../themes/app_theme.dart';
import '../utils/helpers.dart';
import '../widgets/cards.dart';
import '../widgets/general.dart';

class ProjectDetailsPage extends StatelessWidget {
  final Project project;

  const ProjectDetailsPage({super.key, required this.project});



  String formatDate(String iso, {String pattern = 'MMM d, yyyy'}) {
    try {
      return DateFormat(pattern).format(DateTime.parse(iso));
    } catch (_) {
      return iso;
    }
  }

  Color _statusFg(String status) {
    if (status == 'Planning') return Colors.amber;
    if (status == 'In Progress') return Colors.blue;
    if (status == 'Completed') return Colors.green;
    return Colors.red;
  }

  Color _statusBg(String status) {
    if (status == 'Planning') return Colors.amber.withAlpha(50);
    if (status == 'In Progress') return Colors.blue.withAlpha(50);
    if (status == 'Completed') return Colors.green.withAlpha(50);
    return Colors.red.withAlpha(50);
  }

  IconData _statusIcon(String status) {
    if (status == 'Planning') return Icons.next_plan_outlined;
    if (status == 'In Progress') return Icons.timer;
    if (status == 'Completed') return Icons.task_alt_rounded;
    return Icons.timer;
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppDataProvider>();

    if (!app.hasData || app.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final prj = project;
    final utilization = prj.budget.total == 0 ? 0.0 : projectBudgetUtilization(prj).clamp(0.0, 1.0);
    final remaining = (prj.budget.total - prj.budget.spent).clamp(0.0, double.infinity);

    final pendingTasks = prj.tasks.where((t) => t.progress < 100).length;
    final scheduleLabel = prj.status == 'Completed' ? 'On Schedule' : DateTime.parse(
        prj.timeline.endDate).isBefore(DateTime.now()) ? 'Overdue' : 'On Schedule';

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(prj.name, style: AppTheme.textStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(prj.projectId, style: AppTheme.textStyle(fontSize: 12, color: Colors.white.withAlpha(160))),
          ],
        ),
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: const Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add_task_rounded),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          heroCard(context, prj, scheduleLabel),

          const SizedBox(height: 14),

          infoRow(context, prj),

          sectionDivider(),

          sectionHeader(
            title: 'Financials',
            trailing: TextButton(
              onPressed: () {},
              child: Text('Full Report', style: AppTheme.textStyle(fontSize: 13, color: AppTheme.primaryFgColor)),
            ),
          ),

          financialsCard(context, app, prj, utilization, remaining),

          sectionDivider(),

          sectionHeader(
            title: 'Tasks',
            trailing: Chip(
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              backgroundColor: Color.alphaBlend(AppTheme.primaryFgColor.withAlpha(40), AppTheme.primaryCardColor),
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: AppTheme.cardBorderRadius,
                side: const BorderSide(color: Colors.transparent),
              ),
              label: Text(
                '$pendingTasks Pending',
                style: AppTheme.textStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryFgColor)),
            ),
          ),

          const SizedBox(height: 10),

          ...taskTiles(context, prj),

          sectionDivider(),

          sectionHeader(
            title: 'Teams',
            trailing: TextButton(
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('View All', style: AppTheme.textStyle(fontSize: 13, color: AppTheme.primaryFgColor)),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 16, color: AppTheme.primaryFgColor),
                ],
              ),
            ),
          ),

          if (prj.teams.isEmpty) ...[
            noTeamMembers(),
          ]
          else ...prj.teams.map((team) => teamRow(context, team)),

          const SizedBox(height: 80),
        ],
      ),
    );
  }



  Widget heroCard(BuildContext context, Project project, String scheduleLabel) {
    final statusFg = _statusFg(project.status);
    final statusBg = _statusBg(project.status);

    return ClipRRect(
      borderRadius: AppTheme.cardBorderRadius,
      child: Stack(
        children: [
          SizedBox(
            height: 210,
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.alphaBlend(Colors.lightBlue.withAlpha(140), AppTheme.primaryBgColor),
                    Color.alphaBlend(Colors.black.withAlpha(60), AppTheme.primaryBgColor),
                  ],
                ),
              ),
              child: const Align(
                alignment: Alignment.center,
                child: Icon(Icons.apartment_rounded, size: 90, color: Colors.white24),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color.alphaBlend(Colors.black.withAlpha(160), AppTheme.primaryBgColor),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 14,
            bottom: 14,
            right: 14,
            child: Row(
              children: [
                Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Color.alphaBlend(Colors.white.withAlpha(20), AppTheme.primaryBgColor),
                    border: Border.all(color: Colors.white.withAlpha(35)),
                  ),
                  child: Icon(Icons.construction_rounded, color: AppTheme.primaryFgColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.end,
                    children: [
                      Chip(
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        avatar: Icon(_statusIcon(project.status), size: 18, color: statusFg),
                        label: Text(project.status, style: AppTheme.textStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusFg)),
                        backgroundColor: Color.alphaBlend(statusBg, AppTheme.primaryBgColor),
                        surfaceTintColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppTheme.cardBorderRadius,
                          side: const BorderSide(color: Colors.transparent),
                        ),
                      ),

                      Chip(
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        label: Text(scheduleLabel, style: AppTheme.textStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white.withAlpha(220))),
                        backgroundColor: Color.alphaBlend(Colors.white.withAlpha(20), AppTheme.primaryBgColor),
                        surfaceTintColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppTheme.cardBorderRadius,
                          side: const BorderSide(color: Colors.transparent),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget infoRow(BuildContext context, Project project) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(project.name, style: AppTheme.textStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.location_on, size: 16, color: Colors.white.withAlpha(160)),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                context.read<AppDataProvider>().company.headOffice.address,
                style: AppTheme.textStyle(fontSize: 12, color: Colors.white.withAlpha(160)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        smallInfoCard(
          title: 'PROJECT LEAD',
          leading: CircleAvatar(
            radius: 16,
            backgroundColor: Color.alphaBlend(AppTheme.primaryFgColor.withAlpha(40), AppTheme.primaryBgColor),
            child: Text(initials(project.manager.name), style: AppTheme.textStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          value: project.manager.name,
          subtitle: project.manager.designation,
        ),
        Row(
          children: [
            Expanded(child: smallInfoCard(
              title: 'START',
              leading: Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: Color.alphaBlend(Colors.white.withAlpha(20), AppTheme.primaryBgColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.calendar_month, size: 18, color: Colors.white),
              ),
              value: formatDate(project.timeline.startDate),
              subtitle: 'Start date',
            )),

            Expanded(child: smallInfoCard(
              title: 'DEADLINE',
              leading: Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: Color.alphaBlend(Colors.white.withAlpha(20), AppTheme.primaryBgColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.calendar_month, size: 18, color: Colors.white),
              ),
              value: formatDate(project.timeline.endDate),
              subtitle: 'End date',
            )),
          ],
        ),
      ],
    );
  }

  Widget financialsCard(BuildContext context, AppDataProvider app, Project p, double utilization, double remaining) {
    final percentLabel = '${(utilization * 100).toStringAsFixed(0)}%';
    final categories = p.budget.categories;

    return Card(
      elevation: 0,
      color: AppTheme.primaryCardColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: AppTheme.cardBorderRadius),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircularPercentIndicator(
                percent: utilization,
                radius: 62,
                lineWidth: 10,
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: AppTheme.primaryFgColor,
                backgroundColor: Color.alphaBlend(Colors.white.withAlpha(10), AppTheme.primaryBgColor),
                center: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(percentLabel, style: AppTheme.textStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    Text('SPENT', style: AppTheme.textStyle(fontSize: 10, color: Colors.white.withAlpha(150))),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Budget', style: AppTheme.textStyle(fontSize: 11, color: Colors.white.withAlpha(150))),
                      const SizedBox(height: 4),
                      Text(formatMoneyShorthand(app.company.currency, p.budget.total), style: AppTheme.textStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Remaining', style: AppTheme.textStyle(fontSize: 11, color: Colors.white.withAlpha(150))),
                      const SizedBox(height: 4),
                      Text(formatMoneyShorthand(app.company.currency, remaining), style: AppTheme.textStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryFgColor)),
                    ],
                  ),
                ),
              ],
            ),

            if (categories.isNotEmpty) ...[
              const SizedBox(height: 12),
              ...categories.take(3).map((c) => budgetCategoryRow(c)),
            ]
          ],
        ),
      ),
    );
  }

  Widget budgetCategoryRow(BudgetCategory c) {
    final value = c.allocated == 0 ? 0.0 : (c.spent / c.allocated).clamp(0.0, 1.0);
    final spentText = NumberFormat.compactCurrency(symbol: '', decimalDigits: 2).format(c.spent);
    final allocatedText = NumberFormat.compactCurrency(symbol: '', decimalDigits: 2).format(c.allocated);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(c.name, style: AppTheme.textStyle(fontSize: 12, fontWeight: FontWeight.bold))),
              Text('$spentText / $allocatedText', style: AppTheme.textStyle(fontSize: 10, color: Colors.white.withAlpha(140))),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: LinearProgressIndicator(
              minHeight: 7,
              value: value,
              backgroundColor: Color.alphaBlend(Colors.white.withAlpha(10), AppTheme.primaryBgColor),
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryFgColor),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> taskTiles(BuildContext context, Project project) {
    final tasks = [...project.tasks];
    tasks.sort((a, b) => (a.progress).compareTo(b.progress));

    if (tasks.isEmpty) {
      return [
        Card(
          elevation: 0,
          color: AppTheme.primaryCardColor,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: AppTheme.cardBorderRadius),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('No tasks found', style: AppTheme.textStyle(color: Colors.white.withAlpha(160))),
          ),
        )
      ];
    }

    return tasks.map((task) {
      final isDone = task.progress >= 100;
      final priorityFg = task.priority == 'High' ? Colors.amber : (task.priority == 'Medium' ? Colors.blue : Colors.grey);
      final priorityBg = Color.alphaBlend(priorityFg.withAlpha(45), AppTheme.primaryCardColor);

      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Card(
          elevation: 0,
          color: AppTheme.primaryCardColor,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: AppTheme.cardBorderRadius),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircularPercentIndicator(
                  radius: 17,
                  lineWidth: 4,
                  percent: task.progress / 100,
                  progressColor: AppTheme.primaryFgColor,
                  backgroundColor: AppTheme.primaryBgColor,
                  // fillColor: t.progress >= 100 ? AppTheme.primaryFgColor : Colors.transparent,
                  circularStrokeCap: CircularStrokeCap.round,
                  center: task.progress >= 100 ? Icon(Icons.check, size: 20, color: AppTheme.primaryFgColor) : null,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task.title, style: AppTheme.textStyle(fontSize: 13, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text(
                        isDone ? 'Completed' : 'Assigned: ${task.assignedTeam}',
                        style: AppTheme.textStyle(fontSize: 11, color: Colors.white.withAlpha(140)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                Chip(
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  backgroundColor: priorityBg,
                  surfaceTintColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppTheme.cardBorderRadius,
                    side: const BorderSide(color: Colors.transparent),
                  ),
                  label: Text(
                    isDone ? 'Done' : '${task.priority} Priority',
                    style: AppTheme.textStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isDone ? AppTheme.primaryFgColor : priorityFg),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget teamRow(BuildContext context, Team team) {
    final teamMembers = team.members.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(team.name, style: AppTheme.textStyle(fontSize: 12, color: Colors.grey.shade200)),
        ),

        SizedBox(height: 8,),

        if (teamMembers.isEmpty) ...[
          noTeamMembers(),
        ]
        else ...[
          SizedBox(
            height: 130,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (index == teamMembers.length) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      teamAddButton(),
                    ],
                  );
                }
                final member = teamMembers[index];
                final name = (member.name as String?) ?? '';
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Color.alphaBlend(Colors.white.withAlpha(12), AppTheme.primaryBgColor),
                      child: Text(initials(name), style: AppTheme.textStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),

                    const SizedBox(height: 6),

                    SizedBox(
                      width: 55,
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name.split(' ').first,
                            style: AppTheme.textStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white.withAlpha(220)),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            member.role,
                            style: AppTheme.textStyle(fontSize: 10, color: Colors.white.withAlpha(160)),
                            // overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  ],
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 15),
              itemCount: teamMembers.length + 1,
            ),
          ),
        ],

        SizedBox(height: 10,),
      ],
    );
  }

  Widget noTeamMembers() {
    return Card(
      elevation: 0,
      color: AppTheme.primaryCardColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: AppTheme.cardBorderRadius),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text('No team members found', style: AppTheme.textStyle(color: Colors.white.withAlpha(160))),
      ),
    );
  }

  Widget teamAddButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Color.alphaBlend(AppTheme.primaryFgColor.withAlpha(20), AppTheme.primaryBgColor),
          child: Icon(Icons.add, color: AppTheme.primaryFgColor),
        ),

        const SizedBox(height: 6),

        SizedBox(
          width: 55,
          child: Text(
            'Add',
            style: AppTheme.textStyle(fontSize: 10, color: Colors.white.withAlpha(170)),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
