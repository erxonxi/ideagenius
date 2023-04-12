import 'package:flutter/material.dart';

import '../../../utils/config_storage.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  Config _config = Config(openAiKey: "");

  final openApiKeyController = TextEditingController();

  @override
  initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _saveConfig() async {
    await ConfigStorage.setConfig(
      _config,
    );

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Config saved"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Config"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          TextFormField(
            controller: openApiKeyController,
            onChanged: (value) {
              setState(() {
                _config.openAiKey = value;
              });
            },
            style: const TextStyle(
              fontSize: 16.0,
            ),
            decoration: const InputDecoration(
              labelText: "OpenAI API Key",
            ),
          ),
          const SizedBox(height: 16.0),
          FilledButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(
                  vertical: 18.0,
                  horizontal: 42.0,
                ),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            onPressed: _saveConfig,
            child: const Text("Save"),
          )
        ]),
      ),
    );
  }

  Future<void> _loadConfig() async {
    final config = await ConfigStorage.getConfig();

    setState(() {
      _config = config;
    });

    openApiKeyController.text = _config.openAiKey;
  }
}
