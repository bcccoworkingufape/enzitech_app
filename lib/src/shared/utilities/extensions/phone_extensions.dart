extension PhoneExtension on String {
  String get toPhone {
    if (length < 7) {
      return this;
    }
    final p = split('');
    final dd = p.sublist(0, 2).join();
    final phoneNumber =
        '($dd) ${p.sublist(2, 6).join()}-${p.sublist(6).join()}';
    return phoneNumber;
  }

  String get toCelPhone {
    if (length < 8) {
      return this;
    }
    final p = split('');
    final dd = p.sublist(0, 2).join();
    final phoneNumber =
        '($dd) ${p.sublist(2, 3).join()} ${p.sublist(3, 7).join()}-${p.sublist(7).join()}';
    return phoneNumber;
  }
}
