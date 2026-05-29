import 'package:flutter/material.dart';

import '../../../../core/utils/session_service.dart';

class EditableNameField extends StatefulWidget {
  final String nickName;

  const EditableNameField({super.key, required this.nickName});

  @override
  State<EditableNameField> createState() => _EditableNameFieldState();
}

class _EditableNameFieldState extends State<EditableNameField> {
  late final TextEditingController controller;

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.nickName);
  }

  @override
  void didUpdateWidget(covariant EditableNameField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.nickName != widget.nickName) {
      controller.text = widget.nickName;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void toggleEdit() async {
    if (isEditing) {
      final nickname = controller.text.trim();

      if (nickname.isEmpty) return;

      await SessionService.setNickname(nickname);

      FocusScope.of(context).unfocus();
    }

    setState(() {
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
      ),

      child: Row(
        children: [
          /// TEXT FIELD
          Expanded(
            child: TextField(
              controller: controller,

              enabled: isEditing,

              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),

              decoration: const InputDecoration(
                border: InputBorder.none,
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),

          const SizedBox(width: 14),

          /// EDIT BUTTON
          GestureDetector(
            onTap: toggleEdit,

            child: Container(
              height: 45,
              width: 45,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),

                border: Border.all(color: Colors.white, width: 1),
              ),

              child: Icon(
                isEditing ? Icons.check : Icons.edit_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
