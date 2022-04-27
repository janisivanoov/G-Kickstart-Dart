import 'package:kikstartd/core/io_model.dart';
import 'package:kikstartd/core/iterator.dart';

abstract class Solution<T> {
  bool silent = false;
  Input input;
  Output output;

  void log(dynamic message, {dynamic options}) {
    if (silent) {
      return;
    }
    if (options != null) {
      rawLog("$message -> $options");
    } else {
      rawLog(message);
    }
  }

  void debug(dynamic message, {dynamic options}) {
    if (silent) {
      return;
    }
    if (options != null) {
      rawLog("$message -> $options");
    } else {
      rawLog(message);
    }
  }

  void rawLog(dynamic message) {
    if (!silent) {
      print(message);
    }
  }

  IteratorSolution<T> parse(IteratorSolution<T> inputs);

  dynamic solve(T input);

  void store(int test, dynamic result);

  Future<void> run() async {
    if (input == null) {
      throw Exception("Input need to be initialized");
    }
    if (output == null) {
      throw Exception("Output need to be initialized");
    }
    try {
      await input.parse();
      output.init();
      var fromInput = parse(IteratorSolution());
      for (var test = 1; test <= fromInput.tests; test++) {
        var result = solve(fromInput.input[test - 1]);
        store(test, result);
      }
    } catch (ex, stacktrace) {
      log(ex);
      log(stacktrace);
    }
  }

  void init(Input input, Output output, bool silent) {
    this.input = input;
    this.output = output;
    this.silent = silent;
  }
}
