import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/app_data_providers.dart';
import '../themes/app_theme.dart';
import '../widgets/general.dart';

class TaskTeamPage extends StatefulWidget {
  const TaskTeamPage({super.key});

  @override
  State<TaskTeamPage> createState() => _TaskTeamPageState();
}

class _TaskTeamPageState extends State<TaskTeamPage> {
  String searchQuery = '';
  String selectedStatus = 'All';
  final List<String> statusList = const ['All', 'Not Started', 'In Progress', 'Completed'];

  String taskStatusLabel(int progress) {
    if (progress >= 100) return 'Completed';
    if (progress <= 0) return 'Not Started';
    return 'In Progress';
  }

  Color getStatusFg(String status) {
    if (status == 'Not Started') return Colors.grey;
    if (status == 'In Progress') return Colors.blue;
    if (status == 'Completed') return Colors.green;
    return Colors.grey;
  }

  Color getStatusBg(String status) {
    final fg = getStatusFg(status);
    return fg.withAlpha(45);
  }

  IconData statusIcon(String status) {
    if (status == 'Not Started') return Icons.radio_button_unchecked;
    if (status == 'In Progress') return Icons.timer_outlined;
    if (status == 'Completed') return Icons.task_alt_rounded;
    return Icons.timer_outlined;
  }

  Color getPriorityFg(String priority) {
    if (priority == 'High') return Colors.amber;
    if (priority == 'Medium') return Colors.blue;
    if (priority == 'Low') return Colors.grey;
    return Colors.grey;
  }

  Widget taskCard(BuildContext context, Task task, {String? projectName}) {
    final status = taskStatusLabel(task.progress);
    final statusFg = getStatusFg(status);
    final statusBg = Color.alphaBlend(getStatusBg(status), AppTheme.primaryCardColor);
    final priorityFg = getPriorityFg(task.priority);
    final priorityBg = Color.alphaBlend(priorityFg.withAlpha(45), AppTheme.primaryCardColor);
    final overallProgress = (task.progress / 100).clamp(0.0, 1.0);

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
            Row(
                children: [
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
                      '${task.priority} Priority',
                      style: AppTheme.textStyle(fontSize: 10, fontWeight: FontWeight.bold, color: priorityFg),
                    ),
                  ),

                  SizedBox(width: 8),

                  Text(
                    "ID: ${task.taskId}",
                    style: AppTheme.textStyle(fontSize: 12, color: Colors.white.withAlpha(160)),
                  ),
                ],
            ),

            SizedBox(height: 8),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: CircularPercentIndicator(
                    percent: overallProgress,
                    radius: 25,
                    lineWidth: 5,
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: AppTheme.primaryFgColor,
                    backgroundColor: Color.alphaBlend(Colors.white.withAlpha(10), AppTheme.primaryBgColor),
                    center: task.progress >= 100 ? Icon(Icons.check, size: 20, color: AppTheme.primaryFgColor)
                    : Text('${task.progress}%', style: AppTheme.textStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white.withAlpha(220))),
                  ),
                ),

                SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: AppTheme.textStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (projectName != null) ...[
                            Text(
                              projectName,
                              style: AppTheme.textStyle(fontSize: 12, color: Colors.white.withAlpha(180)),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                          ],

                          Text(
                            task.assignedTeam,
                            style: AppTheme.textStyle(fontSize: 12, color: Colors.white.withAlpha(160)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusBg,
                    shape: BoxShape.circle
                  ),
                  child: Icon(statusIcon(status), size: 18, color: statusFg),
                ),
              ],
            ),

            const SizedBox(height: 12),

            if (task.subTasks.isEmpty) ...[
              Text('No subtasks', style: AppTheme.textStyle(fontSize: 12, color: Colors.white.withAlpha(150))),
            ] else ...[
              Text('Subtasks', style: AppTheme.textStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white.withAlpha(210))),
              const SizedBox(height: 8),
              ...task.subTasks.map((st) {
                final done = st.status == 'Completed';
                final value = done ? 1.0 : 0.0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              st.title,
                              style: AppTheme.textStyle(fontSize: 12, color: Colors.white.withAlpha(180)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            st.status,
                            style: AppTheme.textStyle(fontSize: 11, fontWeight: FontWeight.bold, color: done ? Colors.green : Colors.white.withAlpha(140)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: LinearProgressIndicator(
                          minHeight: 6,
                          value: value,
                          backgroundColor: Color.alphaBlend(Colors.white.withAlpha(10), AppTheme.primaryBgColor),
                          valueColor: AlwaysStoppedAnimation<Color>(done ? Colors.green : Colors.white.withAlpha(60)),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppDataProvider>();

    if (!app.hasData || app.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final projects = app.projects;
    final allTasks = app.allTasks;

    final Map<String, String> taskProjectName = {};
    for (final project in projects) {
      for (final t in project.tasks) {
        taskProjectName[t.taskId] = project.name;
      }
    }

    final filteredTasks = allTasks.where((task) {
      final status = taskStatusLabel(task.progress);
      final statusMatches = selectedStatus == 'All' || status == selectedStatus;

      final pName = taskProjectName[task.taskId] ?? '';
      final query = searchQuery.trim().toLowerCase();
      final searchMatches = query.isEmpty ||
          task.title.toLowerCase().contains(query) ||
          task.assignedTeam.toLowerCase().contains(query) ||
          pName.toLowerCase().contains(query);

      return statusMatches && searchMatches;
    }).toList();

    filteredTasks.sort((a, b) {
      if ((a.progress >= 100) != (b.progress >= 100)) {
        return (a.progress >= 100) ? 1 : -1;
      }
      if (a.priority != b.priority) {
        final pa = a.priority == 'High' ? 0 : (a.priority == 'Medium' ? 1 : 2);
        final pb = b.priority == 'High' ? 0 : (b.priority == 'Medium' ? 1 : 2);
        return pa.compareTo(pb);
      }
      return b.progress.compareTo(a.progress);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks & Teams', style: AppTheme.textStyle(fontSize: 30, fontWeight: FontWeight.bold)),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add_task_rounded),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
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
                  hintText: 'Search Tasks...',
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
              child: filteredTasks.isEmpty
                  ? Center(
                      child: Text('No tasks found', style: AppTheme.textStyle(color: Colors.white.withAlpha(160))),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(bottom: 90),
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
                        final pName = taskProjectName[task.taskId];
                        return taskCard(context, task, projectName: pName);
                      },
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemCount: filteredTasks.length,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
