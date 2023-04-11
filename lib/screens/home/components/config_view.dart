import 'package:flutter/material.dart';

import '../../../utils/config_storage.dart';

class ConfigView extends StatefulWidget {
  const ConfigView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ConfigViewState createState() => _ConfigViewState();
}

class _ConfigViewState extends State<ConfigView> {
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              hintText: "OpenAI API Key",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16.0),
          OutlinedButton(
            onPressed: _saveConfig,
            child: const Text("Save"),
          )
        ],
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
