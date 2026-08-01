import 'package:flutter/widgets.dart';
import 'package:easy_localization/easy_localization.dart';

String translate(BuildContext context, String key) {
  return tr(key, context: context);
}
