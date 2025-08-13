import 'dart:convert';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'spinner.dart';

// --------------------
// Configuration
// --------------------
const geminiApiKey = 'AIzaSyDHLOoIarXIv8ioReaLlddMQyqhO5ZI44k';
const geminiModel = 'gemini-2.5-flash';
const postmanFilePath = 'assets/postman_collection.json';

// --------------------
// Main
// --------------------03213439726

Future<void> main() async {
  _printHeader();

  final postmanJson = _readPostmanCollection(postmanFilePath);
  if (postmanJson == null) return;

  final model = _initGeminiModel();

  final generatedFiles = await showSpinnerWhile(
    () => _generateApiFiles(model, postmanJson),
  );

  if (generatedFiles.isEmpty) return;

  await _writeGeneratedFiles(generatedFiles);
  _addDependencies();
}

// --------------------
// Functional Sections
// --------------------

void _printHeader() {
  print('-------------------------------------');
  print('🤖 API Genius: At your Service 🤖');
  print('-------------------------------------');
}

String? _readPostmanCollection(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    print('❌ Error: Postman collection not found at "$path".');
    return null;
  }
  print('📂 Reading Postman collection...');
  return file.readAsStringSync();
}

GenerativeModel _initGeminiModel() {
  return GenerativeModel(
    model: geminiModel,
    apiKey: geminiApiKey,
    generationConfig: GenerationConfig(responseMimeType: 'application/json'),
  );
}

Future<List<Map<String, dynamic>>> _generateApiFiles(
  GenerativeModel model,
  String postmanJson,
) async {
  print('🚀 Generating files...');
  final prompt = _buildCodeGenPrompt(postmanJson);
  final response = await model.generateContent([Content.text(prompt)]);

  if (response.text == null) {
    print('❌ Error: Received no response from the AI.');
    return [];
  }

  try {
    final filesJson = jsonDecode(response.text!);
    return (filesJson['files'] as List<dynamic>)
        .map((e) => e as Map<String, dynamic>)
        .toList();
  } catch (e, stack) {
    print('❌ Error parsing AI response: $e');
    print('Stack trace:\n$stack');
    print('Raw AI response:\n${response.text}');
    return [];
  }
}

String _buildCodeGenPrompt(String postmanJson) {
  return '''
You are a Flutter API code generator.

INPUT: A Postman Collection JSON (v2.1 format).

TASK: From the collection, generate **only** these files:
1. lib/utils/api_constants.dart
2. lib/api_services/[service_name]_service.dart
3. lib/models/[model_name].dart
4. lib/controllers/[controller_name].dart
5. lib/examples/api_usage.dart

RULES:
- State management: GetX
- HTTP requests: http package
- Models: manual JSON serialization (no code generation, no external packages)
- Imports: use **relative imports only**  e.g. `import '../models/user.dart';`
- File paths/names must match exactly as listed
- Group endpoints by Postman folder
- All constants go in api_constants.dart
- Controllers call service methods and update reactive variables

For the file lib/examples/api_usage.dart:
- Import all generated services and controllers using relative imports
- Provide a main() function with usage examples for each service and controller
- Use clear section comments before each example, for example:
  // ----------------------------------------
  // Example usage of UserService
  // ----------------------------------------
- Use dummy data for parameters (e.g., id: 1)
- Use print() statements to show expected output
- Add short inline comments explaining each step  and vertical list of endpoints of each controller


Return **only JSON** in format:
{
  "files": [
    { "path": "file_path_here", "content": "full_file_content_here" }
  ]
}
⚠️ IMPORTANT: Keep everything strictly inside this prompt. Do not generate anything outside of it. No extra packages allowed.

Here is the Postman JSON:
$postmanJson
''';
}

Future<void> _writeGeneratedFiles(List<Map<String, dynamic>> files) async {
  for (var file in files) {
    final path = file['path'] as String;
    final content = file['content'] as String;
    final outFile = File(path);
    await outFile.create(recursive: true);
    await outFile.writeAsString(content);
    print('✅ Created: $path');
  }
}

void _addDependencies() {
  print('\n🚀 Adding GetX & HTTP dependencies...');
  try {
    final pubspecFile = File('pubspec.yaml');
    if (!pubspecFile.existsSync()) {
      print('❌ pubspec.yaml not found.');
      return;
    }
    var lines = pubspecFile.readAsLinesSync();

    final depIndex = lines.indexWhere((line) => line.trim() == 'dependencies:');
    if (depIndex == -1) {
      // No dependencies section, add whole block
      lines.addAll(['dependencies:', '  get:', '  http:']);
      print('✅ Added dependencies section with get and http.');
    } else {
      bool hasGetx = lines.any((line) => line.trim() == 'get:');
      bool hasHttp = lines.any((line) => line.trim() == 'http:');

      int insertPos = depIndex + 1;
      bool updated = false;
      if (hasGetx) {
        print('ℹ️  Dependency "get:" already exists.');
      } else {
        lines.insert(insertPos++, '  get:');
        print('✅ Added "get:" dependency.');
        updated = true;
      }
      if (hasHttp) {
        print('ℹ️  Dependency "http:" already exists.');
      } else {
        lines.insert(insertPos, '  http:');
        print('✅ Added "http:" dependency.');
        updated = true;
      }

      if (!updated) {
        print('ℹ️  No changes needed in dependencies.');
      }
    }

    pubspecFile.writeAsStringSync(lines.join('\n'));
    print('✅ Dependencies updated.');
  } catch (e) {
    print('❌ Failed to modify pubspec.yaml: $e');
  }
}
