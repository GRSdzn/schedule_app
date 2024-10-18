import 'package:flutter/material.dart';
import 'package:schedule_app/core/constants/theme/src/app_colors.dart';
import 'package:schedule_app/core/constants/theme/src/app_rounded.dart';
import 'package:schedule_app/data/schedule/models/selected_schedule_model.dart';
import 'package:schedule_app/presentation/widgets/schedule_widgets/day_content.dart';

class WeekContent extends StatelessWidget {
  final Weeks week;

  const WeekContent({super.key, required this.week});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: AppColors.primaryBackground,
          pinned: false,
          floating: false,
          snap: false,
          expandedHeight: 120.0,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Неделя: ${week.name}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    week.days?.isNotEmpty == true
                        ? week.days![0].date ?? ''
                        : '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: appBorderRadiusAll,
            ),
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Column(
              children: [
                Container(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.8,
                  ),
                  child: Column(
                    children: week.days
                            ?.map((day) => DayContent(day: day))
                            .toList() ??
                        [],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
