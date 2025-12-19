import 'package:erp_sample/widgets/cards.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_data_providers.dart';
import '../themes/app_theme.dart';

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({super.key});

  @override
  State<ProjectListPage> createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  String searchQuery = '';
  String selectedStatus = 'All';
  List<String> statusList = ['All', 'Planning', 'In Progress', 'Completed', 'On Hold'];

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppDataProvider>();
    final projects = app.projects.where((project) {
      final statusMatches = selectedStatus == 'All' || project.status == selectedStatus;
      final searchMatches = project.name.toLowerCase().contains(searchQuery.toLowerCase());
      return statusMatches && searchMatches;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Projects', style: AppTheme.textStyle(fontSize: 30, fontWeight: FontWeight.bold),),
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
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search Projects...',
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

            // Status Filter Chips
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
                      shape: RoundedRectangleBorder(borderRadius: AppTheme.cardBorderRadius, side: BorderSide(color: Colors.transparent)),
                      label: Text(status, style: AppTheme.textStyle(color: selectedStatus == status ? AppTheme.primaryBgColor : Colors.white),),
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

            SizedBox(height: 5),

            // Project List
            Expanded(
              child: ListView.separated(
                itemCount: projects.length,
                separatorBuilder: (context, index) => const SizedBox(height: 5),
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return projectCard(context, project: project);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}