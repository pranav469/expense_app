class Validators {
  static String? validatePhone(
      String? value,
      ) {
    if (value!.trim().isEmpty) {
      return 'Phone number is required';
    }

    final cleaned =
    value.replaceAll(RegExp(r'\s+'), '');

    if (cleaned.length < 10) {
      return 'Enter valid phone number';
    }

    return null;
  }
}