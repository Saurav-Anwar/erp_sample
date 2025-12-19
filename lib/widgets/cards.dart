import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../models/payment.dart';
import '../models/project.dart';
import '../pages/project_details_page.dart';
import '../themes/app_theme.dart';
import '../utils/helpers.dart';

Widget summaryCard({required String title, required String value, required Icon icon, required bool isLight}) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: AppTheme.cardBorderRadius),
    color: isLight ? AppTheme.primaryFgColor : AppTheme.primaryCardColor,
    child: Padding(
      padding: EdgeInsetsGeometry.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon.icon, size: 30, color: isLight ? AppTheme.primaryBgColor : AppTheme.primaryFgColor),
          Text(value, style: AppTheme.textStyle(fontSize: 25, fontWeight: FontWeight.bold, color: isLight ? AppTheme.primaryBgColor : Colors.white), textAlign: TextAlign.center,),
          Text(title, style: AppTheme.textStyle(fontSize: 12, color: isLight ? AppTheme.primaryBgColor : Colors.grey), textAlign: TextAlign.center,),
        ],
      ),
    ),
  );
}

Widget projectCard(BuildContext context, {required Project project}) {
  List<IconData> cardIcons = [
    Icons.business,
    Icons.house,
    Icons.link,
    Icons.construction_rounded,
  ];

  Color chipBgColor = project.status == "Planning" ? Colors.amber.withAlpha(50)
                    : project.status == "In Progress" ? Colors.blue.withAlpha(50)
                    : project.status == "Completed" ? Colors.green.withAlpha(50)
                    : Colors.red.withAlpha(50);

  Color chipFgColor = project.status == "Planning" ? Colors.amber
                    : project.status == "In Progress" ? Colors.blue
                    : project.status == "Completed" ? Colors.green
                    : Colors.red;

  IconData chipIcon = project.status == "Planning" ? Icons.next_plan_outlined
                    : project.status == "In Progress" ? Icons.timer
                    : project.status == "Completed" ? Icons.task_alt_rounded
                    : Icons.timer;

  return ConstrainedBox(
    constraints: BoxConstraints(maxWidth: 350),
    child: Card(
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: AppTheme.cardBorderRadius),
      color: AppTheme.primaryCardColor,
      child: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green.shade200.withAlpha(60),
                  radius: 20,
                  child: Icon(cardIcons[Random().nextInt(cardIcons.length)], size: 25, color: Colors.white),
                ),

                SizedBox(width: 15,),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(project.name, style: AppTheme.textStyle(fontSize: 13, fontWeight: FontWeight.bold),),
                      Text(project.projectId, style: AppTheme.textStyle(fontSize: 12, color: Colors.grey),),
                    ],
                  ),
                ),

                SizedBox(width: 10,),

                Chip(
                  padding: EdgeInsetsGeometry.zero,
                  labelPadding: EdgeInsets.only(right: 8),
                  visualDensity: VisualDensity.compact,
                  avatar: Icon(chipIcon, color: chipFgColor,),
                  label: Text(project.status, style: AppTheme.textStyle(fontSize: 10, fontWeight: FontWeight.bold, color: chipFgColor), overflow: TextOverflow.ellipsis,),
                  backgroundColor: Color.alphaBlend(chipBgColor, AppTheme.primaryCardColor),
                  surfaceTintColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: AppTheme.cardBorderRadius, side: BorderSide(color: Colors.transparent)),
                ),
              ],
            ),

            SizedBox(height: 15,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircularPercentIndicator(
                  percent: projectBudgetUtilization(project),
                  center: Text("${(projectBudgetUtilization(project) * 100).toStringAsFixed(0)}%", style: AppTheme.textStyle(fontWeight: FontWeight.bold),),
                  footer: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text("Budget used", style: AppTheme.textStyle(fontSize: 12, color: Colors.grey),),
                  ),
                  progressColor: AppTheme.primaryFgColor,
                  backgroundColor: AppTheme.primaryBgColor,
                  radius: 30,
                  lineWidth: 5,
                  circularStrokeCap: CircularStrokeCap.round,
                ),

                CircularPercentIndicator(
                  percent: milestonesProgress(project.timeline),
                  center: Text("${(milestonesProgress(project.timeline) * 100).toStringAsFixed(0)}%", style: AppTheme.textStyle(fontWeight: FontWeight.bold),),
                  footer: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text("Milestones", style: AppTheme.textStyle(fontSize: 12, color: Colors.grey),),
                  ),
                  progressColor: AppTheme.primaryFgColor,
                  backgroundColor: AppTheme.primaryBgColor,
                  radius: 30,
                  lineWidth: 5,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ],
            ),
            
            Divider(color: Colors.grey.withAlpha(80), height: 20),

            Row(
              children: [
                CircleAvatar(child: Icon(Icons.person),),

                SizedBox(width: 10,),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(project.manager.name, style: AppTheme.textStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                      Text(project.manager.designation, style: AppTheme.textStyle(fontSize: 11, color: Colors.grey),),
                    ],
                  ),
                ),

                SizedBox(width: 10,),
                
                IconButton.filled(
                  color: Colors.white.withAlpha(100),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProjectDetailsPage(project: project),
                      ),
                    );
                  },
                  icon: Icon(CupertinoIcons.chevron_right)
                )
              ],
            )

          ],
        ),
      ),
    ),
  );
}

Widget paymentRequestCard(
  BuildContext context, {
  required Payment payment,
  required String currency,
  String? projectName,
}) {
  final status = (payment.approvalFlow.status == 'Approved') ? 'Approved' : 'Pending';
  final statusFg = status == 'Approved' ? Colors.green : Colors.amber;
  final statusBg = Color.alphaBlend(statusFg.withAlpha(45), AppTheme.primaryCardColor);

  final invoiceCount = payment.invoices.length;
  final invoices = payment.invoices;
  final invoiceLabel = invoiceCount == 0
      ? 'No invoices'
      : invoiceCount == 1
          ? '1 invoice'
          : '$invoiceCount invoices';

  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 350),
    child: Card(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Color.alphaBlend(AppTheme.primaryFgColor.withAlpha(25), AppTheme.primaryBgColor),
                  child: const Icon(Icons.payments_rounded, size: 18, color: Colors.white),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(payment.paymentId, style: AppTheme.textStyle(fontSize: 13, fontWeight: FontWeight.bold)),

                      if (projectName != null && projectName.trim().isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(projectName, style: AppTheme.textStyle(fontSize: 11, color: Colors.white.withAlpha(160)), overflow: TextOverflow.ellipsis),
                      ],

                      const SizedBox(height: 2),
                      Text(invoiceLabel, style: AppTheme.textStyle(fontSize: 11, color: Colors.white.withAlpha(160))),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                Chip(
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  backgroundColor: statusBg,
                  surfaceTintColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppTheme.cardBorderRadius,
                    side: const BorderSide(color: Colors.transparent),
                  ),
                  label: Text(status, style: AppTheme.textStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusFg)),
                ),
              ],
            ),

            const SizedBox(height: 12),



            if (invoices.isNotEmpty) ...[
              const SizedBox(height: 6),
              ...invoices.map((invoice) {
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        invoice.vendor,
                        style: AppTheme.textStyle(fontSize: 12, color: Colors.white.withAlpha(160)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    Text(
                      formatMoneyShorthand(currency, invoice.amount),
                      textAlign: TextAlign.right,
                      style: AppTheme.textStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                    )
                  ],
                );
              }),
            ],

            Divider(color: Colors.grey.withAlpha(80), height: 16),

            Align(
              alignment: AlignmentGeometry.centerRight,
              child: Text(
                formatMoneyShorthand(currency, payment.amount),
                textAlign: TextAlign.right,
                style: AppTheme.textStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),

            const SizedBox(height: 4),

            Container(
              padding: EdgeInsetsGeometry.all(8),
              decoration: BoxDecoration(
                borderRadius: AppTheme.cardBorderRadius,
                color: Color.alphaBlend(Colors.white.withAlpha(25), AppTheme.primaryBgColor),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: Color.alphaBlend(Colors.white.withAlpha(12), AppTheme.primaryBgColor),
                          child: Text(initials(payment.requestedBy), style: AppTheme.textStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white.withAlpha(220))),
                        ),
              
                        const SizedBox(width: 10),
              
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(payment.requestedBy, style: AppTheme.textStyle(fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                              Text(formatIsoDate(payment.requestDate), style: AppTheme.textStyle(fontSize: 11, color: Colors.white.withAlpha(140)), overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              
                  const SizedBox(width: 10),
              
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: Color.alphaBlend(statusFg.withAlpha(18), AppTheme.primaryBgColor),
                          child: Icon(
                            status == 'Approved' ? Icons.verified_rounded : Icons.hourglass_bottom_rounded,
                            size: 16,
                            color: statusFg,
                          ),
                        ),
              
                        const SizedBox(width: 10),
              
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                payment.approvalFlow.approvedBy,
                                style: AppTheme.textStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white.withAlpha(220)),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                payment.approvalFlow.approvedDate.isEmpty ? 'Awaiting approval' : formatIsoDate(payment.approvalFlow.approvedDate),
                                style: AppTheme.textStyle(fontSize: 11, color: Colors.white.withAlpha(140)),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
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
      ),
    ),
  );
}

Widget smallInfoCard({
  required String title,
  required Widget leading,
  required String value,
  required String subtitle,
}) {
  return Card(
    elevation: 0,
    color: AppTheme.primaryCardColor,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: AppTheme.cardBorderRadius),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTheme.textStyle(fontSize: 10, color: Colors.white.withAlpha(140))),
          const SizedBox(height: 10),
          Row(
            children: [
              leading,
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(value, style: AppTheme.textStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                    Text(subtitle, style: AppTheme.textStyle(fontSize: 11, color: Colors.white.withAlpha(140)), overflow: TextOverflow.ellipsis),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    ),
  );
}