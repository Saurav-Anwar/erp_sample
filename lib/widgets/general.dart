import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../themes/app_theme.dart';

Widget sectionDivider() {
  return SizedBox(height: 14,);
}

Widget genericKPI({required String label, required String value}) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.textStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: AppTheme.textStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

Widget sectionHeader({required String title, Widget? trailing}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTheme.textStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        if(trailing != null)...[
          trailing,
        ],
      ],
    ),
  );
}