import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main.dart';
import '../bloc/category_bloc.dart';
import '../bloc/category_event.dart';
import '../bloc/category_state.dart';
import 'add_category_page.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();

    context.read<CategoryBloc>().add(const LoadCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigatorKey.currentState?.push(
            MaterialPageRoute(builder: (_) => AddCategoryPage()),
          );
        },

        child: const Icon(Icons.add),
      ),

      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CategoryLoaded) {
            if (state.categories.isEmpty) {
              return const Center(child: Text('No Categories'));
            }

            return ListView.builder(
              itemCount: state.categories.length,

              itemBuilder: (context, index) {
                final category = state.categories[index];

                return ListTile(
                  title: Text(category.name),

                  trailing: IconButton(
                    onPressed: () {
                      context.read<CategoryBloc>().add(
                        DeleteCategoryEvent(category.id),
                      );
                    },

                    icon: const Icon(Icons.delete),
                  ),
                );
              },
            );
          }

          if (state is CategoryError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
