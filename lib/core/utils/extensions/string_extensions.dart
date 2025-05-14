extension StringExtension on String {
  String get capitalize {
    if (isEmpty) return this;
    var s = this;
    return s.substring(0, 1).toUpperCase() + s.substring(1).toLowerCase();
  }

  String get unSign {
    String result = this;
    for (int i = 0; i < _vietnamese.length; i++) {
      result = result.replaceAll(_vietnameseRegex[i], _vietnamese[i]);
    }
    return result;
  }

  String get unSignLower => unSign.toUpperCase();

  String numberFormat() {
    String cleaned = replaceAll(',', '');

    bool isNegative = cleaned.startsWith('-');
    if (isNegative) {
      cleaned = cleaned.substring(1);
    }

    String reversed = cleaned.split('').reversed.join();

    List<String> chunks = [];
    for (int i = 0; i < reversed.length; i += 5) {
      chunks.add(reversed.substring(i, i + 5 > reversed.length ? reversed.length : i + 5));
    }

    String formatted = chunks.join(',').split('').reversed.join();

    return isNegative ? '-$formatted' : formatted;
  }


  String intFormatNumber(){
    if (contains('.') && endsWith('.0')) {
      return split('.')[0];
    }
    return this;
  }
}




const String _vietnamese = 'aAeEoOuUiIdDyY';
final List<RegExp> _vietnameseRegex = <RegExp>[
  RegExp(r'à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ'),
  RegExp(r'À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ'),
  RegExp(r'è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ'),
  RegExp(r'È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ'),
  RegExp(r'ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ'),
  RegExp(r'Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ'),
  RegExp(r'ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ'),
  RegExp(r'Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ'),
  RegExp(r'ì|í|ị|ỉ|ĩ'),
  RegExp(r'Ì|Í|Ị|Ỉ|Ĩ'),
  RegExp(r'đ'),
  RegExp(r'Đ'),
  RegExp(r'ỳ|ý|ỵ|ỷ|ỹ'),
  RegExp(r'Ỳ|Ý|Ỵ|Ỷ|Ỹ')
];
