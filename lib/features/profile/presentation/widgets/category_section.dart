import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../transaction/presentation/bloc/category_bloc.dart';
import '../../../transaction/presentation/bloc/category_state.dart';
import '../../../transaction/presentation/bloc/category_event.dart';

class CategorySection extends StatefulWidget {
  const CategorySection({super.key});

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  final TextEditingController categoryController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    categoryController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                                controller: categoryController,
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
                                  AddCategoryEvent(
                                    categoryController.text.trim(),
                                  ),
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
}
