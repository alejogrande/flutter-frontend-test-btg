class AppValidators {
  /// Limpia el string de cualquier carácter que no sea número y lo convierte a double
  static double parseCurrencyToDouble(String value) {
    final cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
    return double.tryParse(cleanValue) ?? 0.0;
  }

  /// Valida si el monto cumple con el mínimo requerido
  static String? validateInvestmentAmount({
    required String value,
    required double minAmount,
    required String minAmountFormatted,
  }) {
    final amount = parseCurrencyToDouble(value);

    if (amount <= 0) {
      return "Ingresa un monto válido";
    }

    if (amount < minAmount) {
      return "Mínimo requerido: $minAmountFormatted";
    }

    return null; // Todo ok
  }
}