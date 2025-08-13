import 'dart:async';
import 'dart:io';

// Add this spinner function:
Future<T> showSpinnerWhile<T>(Future<T> Function() asyncTask) async {
  const spinnerChars = ['|', '/', '-', '\\'];
  int i = 0;
  bool done = false;

  Timer.periodic(const Duration(milliseconds: 100), (timer) {
    if (done) {
      timer.cancel();
      return;
    }
    stdout.write('\r${spinnerChars[i++ % spinnerChars.length]}');
  });

  final result = await asyncTask();
  done = true;
  stdout.write('\r✅ Generation complete!           \n');
  return result;
}
