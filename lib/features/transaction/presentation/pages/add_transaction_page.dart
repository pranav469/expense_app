import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/category_bloc.dart';
import '../bloc/category_state.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() =>
      _AddTransactionPageState();
}

class _AddTransactionPageState
    extends State<AddTransactionPage> {
  final amountController =
  TextEditingController();

  final noteController =
  TextEditingController();

  final formKey =
  GlobalKey<FormState>();

  String type = 'debit';

  String? selectedCategoryId;

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void saveTransaction() {
    final isValid =
    formKey.currentState!.validate();

    if (!isValid) return;

    if (selectedCategoryId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please select category',
          ),
        ),
      );

      return;
    }

    context.read<TransactionBloc>().add(
      AddTransactionEvent(
        amount: double.parse(
          amountController.text.trim(),
        ),
        note:
        noteController.text.trim(),
        type: type,
        categoryId:
        selectedCategoryId!,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding:
          const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                /// HEADER
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
                  children: [
                    const Text(
                      'Add Transaction',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    GestureDetector(
                      onTap: () =>
                          Navigator.pop(
                              context),
                      child: const Text(
                        'Close',
                        style: TextStyle(
                          color:
                          Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// EXPENSE / INCOME SWITCH
                Container(
                  padding:
                  const EdgeInsets.all(
                      4),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                      Colors.white24,
                    ),
                    borderRadius:
                    BorderRadius
                        .circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child:
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              type =
                              'debit';
                            });
                          },
                          child: Container(
                            height: 50,
                            decoration:
                            BoxDecoration(
                              color: type ==
                                  'debit'
                                  ? Colors
                                  .green
                                  : Colors
                                  .transparent,
                              borderRadius:
                              BorderRadius
                                  .circular(
                                  12),
                            ),
                            child:
                            const Center(
                              child: Text(
                                'Expense',
                                style:
                                TextStyle(
                                  color: Colors
                                      .white,
                                  fontWeight:
                                  FontWeight
                                      .w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        child:
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              type =
                              'credit';
                            });
                          },
                          child: Container(
                            height: 50,
                            decoration:
                            BoxDecoration(
                              color: type ==
                                  'credit'
                                  ? Colors
                                  .green
                                  : Colors
                                  .transparent,
                              borderRadius:
                              BorderRadius
                                  .circular(
                                  12),
                            ),
                            child:
                            const Center(
                              child: Text(
                                'Income',
                                style:
                                TextStyle(
                                  color: Colors
                                      .white,
                                  fontWeight:
                                  FontWeight
                                      .w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// TITLE
                _darkInput(
                  controller:
                  noteController,
                  hint: 'Title',
                ),

                const SizedBox(height: 18),

                /// AMOUNT
                _darkInput(
                  controller:
                  amountController,
                  hint: 'Amount (₹)',
                  keyboard:
                  TextInputType.number,
                ),

                const SizedBox(height: 24),

                const Text(
                  'CATEGORY',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                    fontWeight:
                    FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 14),

                /// CATEGORY CHIPS
                BlocBuilder<CategoryBloc,
                    CategoryState>(
                  builder:
                      (context, state) {
                    if (state
                    is CategoryLoaded) {
                      return Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: state
                            .categories
                            .map(
                              (category) =>
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCategoryId =
                                        category
                                            .id;
                                  });
                                },
                                child:
                                Container(
                                  padding:
                                  const EdgeInsets.symmetric(
                                    horizontal:
                                    18,
                                    vertical:
                                    12,
                                  ),
                                  decoration:
                                  BoxDecoration(
                                    color: selectedCategoryId ==
                                        category
                                            .id
                                        ? Colors
                                        .indigo
                                        : Colors
                                        .transparent,
                                    border:
                                    Border.all(
                                      color: selectedCategoryId ==
                                          category
                                              .id
                                          ? Colors
                                          .blue
                                          : Colors
                                          .white30,
                                    ),
                                    borderRadius:
                                    BorderRadius.circular(
                                        12),
                                  ),
                                  child: Text(
                                    category
                                        .name,
                                    style:
                                    const TextStyle(
                                      color: Colors
                                          .white,
                                    ),
                                  ),
                                ),
                              ),
                        )
                            .toList(),
                      );
                    }

                    if (state
                    is CategoryLoading) {
                      return const Center(
                        child:
                        CircularProgressIndicator(),
                      );
                    }

                    return const SizedBox();
                  },
                ),

                const SizedBox(height: 28),

                /// INFO BOX
                Container(
                  padding:
                  const EdgeInsets.all(
                      16),
                  decoration: BoxDecoration(
                    color: Colors.green
                        .withOpacity(0.15),
                    borderRadius:
                    BorderRadius
                        .circular(14),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.white,
                        size: 18,
                      ),

                      SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          'Everything you add here is saved only on your device.',
                          style: TextStyle(
                            color:
                            Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                /// SAVE BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed:
                    saveTransaction,
                    style:
                    ElevatedButton.styleFrom(
                      backgroundColor:
                      const Color(
                          0xFF4338CA),
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius
                            .circular(
                            16),
                      ),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _darkInput({
    required TextEditingController
    controller,
    required String hint,
    TextInputType keyboard =
        TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      style:
      const TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null ||
            value.trim().isEmpty) {
          return 'Required';
        }

        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.white38,
        ),
        filled: true,
        fillColor:
        const Color(0xFF1E1E1E),
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(14),
          borderSide:
          const BorderSide(
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}