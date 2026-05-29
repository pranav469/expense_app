import 'package:expense_manager/core/themes/app_text_styles.dart';
import 'package:expense_manager/features/profile/presentation/widgets/category_section.dart';
import 'package:expense_manager/features/profile/presentation/widgets/set_limit_field.dart';
import 'package:flutter/material.dart';
import '../../../../core/themes/app_theme.dart';
import '../../../../core/utils/session_service.dart';
import '../../../transaction/presentation/bloc/category_bloc.dart';
import '../../../transaction/presentation/bloc/category_event.dart';
import '../../../transaction/presentation/bloc/category_state.dart';
import '../../../transaction/presentation/bloc/sync_bloc.dart';
import '../../../transaction/presentation/bloc/sync_event.dart';
import '../widgets/editable_namefield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    loadUser();
    context.read<CategoryBloc>().add(const LoadCategories());
  }

  final formKey = GlobalKey<FormState>();

  String nickname = "";

  Future<void> loadUser() async {
    final name = await SessionService.getNickname();

    setState(() {
      nickname = name;
    });
  }

  void _startSync() {
    context.read<SyncBloc>().add(const TriggerSync());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profile & Settings',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.surface,
                ),
              ),
              SizedBox(height: 20),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('NICKNAME', style: AppTextStyles.profileText),
                    SizedBox(height: 15),
                    EditableNameField(nickName: nickname),
                    SizedBox(height: 15),
                    SetLimitField(),
                    SizedBox(height: 15),
                    CategorySection(),
                    SizedBox(height: 15),
                    cloudSyncSection(),
                    SizedBox(height: 15),
                    logout(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cloudSyncSection() {
    return GestureDetector(
      onTap: () {
        _startSync();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CLOUD SYNC', style: AppTextStyles.profileText),
          SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(18),

            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white10),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(22),
              ),
              padding: EdgeInsets.only(
                top: 10,
                bottom: 10,
                left: 20,
                right: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SYNC TO CLOUD', style: AppTextStyles.profileText),
                      SizedBox(height: 5),
                      Text(
                        'Sync and update to backend',
                        style: AppTextStyles.profileSubText,
                      ),
                    ],
                  ),
                  Image.asset('assets/images/profile/cloud.png'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget logout() {
    return GestureDetector(
      onTap: () {
        SessionService.logout();
      },
      child: Container(
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Log Out',
              style: AppTextStyles.onboardingDescription.copyWith(
                color: Colors.red,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.logout, color: Colors.red, size: 18),
          ],
        ),
      ),
    );
  }
}
