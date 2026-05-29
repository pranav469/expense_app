import 'package:expense_manager/core/utils/session_service.dart';
import 'package:flutter/material.dart';

import '../../../../core/themes/app_text_styles.dart';

class SetLimitField extends StatefulWidget {
  const SetLimitField({super.key});

  @override
  State<SetLimitField> createState() => _SetLimitFieldState();
}

class _SetLimitFieldState extends State<SetLimitField> {
  final TextEditingController limitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final limit = SessionService.getLimit();
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          Text('ALERT LIMIT (₹)', style: AppTextStyles.profileText),

          const SizedBox(height: 16),

          /// FIELD + BUTTON
          Row(
            children: [
              /// TEXT FIELD
              Expanded(
                child: Container(
                  height: 56,

                  padding: const EdgeInsets.symmetric(horizontal: 18),

                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(14),
                  ),

                  alignment: Alignment.centerLeft,

                  child: TextField(
                    controller: limitController,
                    keyboardType: TextInputType.number,

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),

                    decoration: const InputDecoration(
                      hintText: 'Amount ( ₹ )',
                      hintStyle: TextStyle(color: Colors.white38, fontSize: 18),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              /// BUTTON
              SizedBox(
                height: 56,

                child: ElevatedButton(
                  onPressed: () async {
                    await SessionService.setLimit(
                      double.parse(limitController.text),
                    );

                    setState(() {});
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4338CA),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),

                    padding: const EdgeInsets.symmetric(horizontal: 22),
                  ),

                  child: const Text(
                    'Set',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// CURRENT LIMIT
          FutureBuilder<double>(
            future: SessionService.getLimit(),

            builder: (context, snapshot) {
              final limit = snapshot.data ?? 0.0;

              return Text(
                'Current Limit: ₹$limit',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
