extension AddressExtension on String {
  String get toPostalCode {
    final c = split('');
    final postalCode = '${c.sublist(0, 5).join()}-${c.sublist(5).join()}';
    return postalCode;
  }

  String get toStateRegistration {
    final s = split('');
    if (s.length < 12) {
      return '-';
    }
    final stateRegistration =
        '${s.sublist(0, 11).join()}-${s.sublist(12).join()}';
    return stateRegistration;
  }
}
