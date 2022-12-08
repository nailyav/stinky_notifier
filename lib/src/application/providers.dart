import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final productNameProvider = StateProvider<String>((ref) => "");
final dateProvider = StateProvider<String>((ref) => DateFormat('dd/MM/yyyy').format(DateTime.now()));
final idProvider = StateProvider<int>((ref) => 0);