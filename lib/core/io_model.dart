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
    if (!isStd) {
      var topLine = lines.first;
      lines = lines.getRange(1, lines.length).toList();
      var value = topLine.toString().trim();
      return int.parse(value);
    }
    var line = stdin.readLineSync().trim();
    return int.parse(line);
  }

  List<int> readInts(int size, {String pattern = " "}) {
    var list = <int>[];

    if (!isStd) {
      var topLine = lines.first.toString();
      lines = lines.getRange(1, lines.length).toList();
      topLine.split(pattern).forEach((element) {
        list.add(int.parse(element));
      });
    } else {
      var line = stdin.readLineSync();
      line.split(pattern).forEach((element) => list.add(int.parse(element)));
    }
    return list;
  }

  List<String> splitRawLine({String pattern = " "}) {
    if (!isStd) {
      var topLine = lines.first.toString();
      lines = lines.getRange(1, lines.length).toList();
      return topLine.split(pattern);
    }
    var line = stdin.readLineSync();
    return line.split(pattern);
  }
}

class Output {
  String outPath;
  File file;
  bool isStd = false;

  Output(this.outPath) {
    isStd = outPath.isEmpty;
  }

  void init() {
    if (isStd) {
      return;
    }
    file = File(outPath);
    file.exists().then((value) {
      if (value) {
        file.delete();
        file.create();
      }
    });
  }

  void writeLine(dynamic value) {
    if (isStd) {
      print(value);
    } else {
      file.writeAsStringSync(value + "\n", mode: FileMode.append, flush: true);
    }
  }
}
