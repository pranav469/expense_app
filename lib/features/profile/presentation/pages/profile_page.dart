import 'package:expense_manager/core/themes/app_text_styles.dart';
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
                    _setLimit(),
                    SizedBox(height: 15),
                    categoryList(context),
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

  Widget _setLimit() {
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
                  onPressed: () {},

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
          const Text(
            'Current Limit: ₹1,000',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget categoryList(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CategoryError) {
          return Center(child: Text(state.message));
        }
        if (state is CategoryLoaded) {
          if (state.categories.isEmpty) {
            return const Center(child: Text('No Categories'));
          }

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
                Text('CATEGORIES', style: AppTextStyles.profileText),
                SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          /// TEXT FIELD
                          Expanded(
                            child: Container(
                              height: 56,

                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                              ),

                              decoration: BoxDecoration(
                                color: const Color(0xFF1E1E1E),
                                borderRadius: BorderRadius.circular(14),
                              ),

                              alignment: Alignment.centerLeft,

                              child: TextField(
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),

                                decoration: const InputDecoration(
                                  hintText: 'New Category Name',
                                  hintStyle: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 18,
                                  ),
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
                              onPressed: () {
                                context.read<CategoryBloc>().add(
                                  AddCategoryEvent(''),
                                );
                              },

                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4338CA),

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),

                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                              ),

                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),

                        itemCount: state.categories.length,

                        separatorBuilder: (_, __) => const SizedBox(height: 20),

                        itemBuilder: (context, index) {
                          final category = state.categories[index];

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              /// CATEGORY NAME
                              Text(
                                category.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              /// DELETE BUTTON
                              Container(
                                height: 52,
                                width: 52,

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),

                                  border: Border.all(color: Colors.red),
                                ),

                                child: IconButton(
                                  onPressed: () {
                                    context.read<CategoryBloc>().add(
                                      DeleteCategoryEvent(category.id),
                                    );
                                  },

                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
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
      onTap: (){},
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
              style: AppTextStyles.onboardingDescription.copyWith(color: Colors.red),
            ),
            SizedBox(width: 10,),
            Icon(Icons.logout,color: Colors.red,size: 18,),
          ],
        ),
      ),
    );
  }
}
