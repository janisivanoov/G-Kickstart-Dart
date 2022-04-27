// @dart=2.10
import 'dart:convert';
import 'dart:io';

class Input {
  final String inputPath;
  List<String> lines;
  bool isStd = false;

  Input(this.inputPath) {
    if (inputPath.isEmpty) {
      isStd = true;
    }
  }

  Stream<String> readLines() {
    return File(inputPath)
        .openRead()
        .transform(utf8.decoder)
        .transform(LineSplitter());
  }

  Future<void> parse() async {
    if (!isStd) {
      lines = await readLines().toList();
    }
  }

  int readInt() {
    var line = stdin.readLineSync().trim();
    return int.parse(line);
  }

  List<int> readInts(int size, {String pattern = " "}) {
    var list = <int>[];

    var line = stdin.readLineSync();
    line.split(pattern).forEach((element) => list.add(int.parse(element)));
    return list;
  }

  List<String> splitRawLine({String pattern = " "}) {
    var line = stdin.readLineSync();
    return line.split(pattern);
  }
}

class Output {
  final String outPath;
  bool isStd = false;

  Output(this.outPath) {
    isStd = outPath.isEmpty;
  }

  void init() {}

  void writeLine(dynamic value) {
    print(value);
  }
}

class IteratorSolution<T> {
  int tests;

  List<T> input = List.empty(growable: true);

  IteratorSolution({this.tests = 0});
}

abstract class SolutionLocal<T> {
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
    await input.parse();
    output.init();
    var fromInput = parse(IteratorSolution());
    for (var test = 1; test <= fromInput.tests; test++) {
      var result = solve(fromInput.input[test - 1]);
      store(test, result);
    }
    exit(0);
  }

  void init(Input input, Output output, bool silent) {
    this.input = input;
    this.output = output;
    this.silent = silent;
  }
}

void main() {
  var solution = CentauriSol();
  solution.init(Input(''), Output(''), true);
  solution.run();
}

class Kingdom {
  Set<String> vowels = {'A', 'E', 'I', 'O', 'U', 'a', 'e', 'i', 'o', 'u'};
  String name = '';
  Kingdom(this.name);
}

class CentauriSol extends SolutionLocal<Kingdom> {
  @override
  IteratorSolution<Kingdom> parse(IteratorSolution<Kingdom> inputs) {
    inputs.tests = input.readInt();
    for (var test = 1; test <= inputs.tests; test++) {
      var name = input.splitRawLine().first.trim();
      inputs.input.add(Kingdom(name));
    }
    return inputs;
  }

  @override
  solve(Kingdom input) {
    var last = input.name[input.name.length - 1].toLowerCase();
    if (input.vowels.contains(last)) {
      return "${input.name} is ruled by Alice.";
    } else if (last == 'y') {
      return "${input.name} is ruled by nobody.";
    }
    return "${input.name} is ruled by Bob.";
  }

  @override
  void store(int test, result) {
    output.writeLine("Case #$test: $result");
  }
}
