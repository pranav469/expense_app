import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/category_bloc.dart';
import '../bloc/category_event.dart';
import '../bloc/category_state.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({
    super.key,
  });

  @override
  State<AddCategoryPage>
  createState() =>
      _AddCategoryPageState();
}

class _AddCategoryPageState
    extends State<AddCategoryPage> {
  final TextEditingController
  categoryController =
  TextEditingController();

  final GlobalKey<FormState>
  formKey =
  GlobalKey<FormState>();

  @override
  void dispose() {
    categoryController.dispose();

    super.dispose();
  }

  void createCategory() {
    final isValid =
    formKey.currentState!.validate();

    if (!isValid) return;

    context.read<CategoryBloc>().add(
      AddCategoryEvent(
        categoryController.text
            .trim(),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        const Text('Add Category'),
      ),
      body: Padding(
        padding:
        const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller:
                categoryController,
                decoration:
                const InputDecoration(
                  hintText:
                  'Category Name',
                ),

                validator: (value) {
                  if (value == null ||
                      value
                          .trim()
                          .isEmpty) {
                    return 'Enter category name';
                  }

                  if (value
                      .trim()
                      .length <
                      2) {
                    return 'Name too short';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed:
                  createCategory,
                  child: const Text(
                    'Create Category',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}