import 'package:flutter/material.dart';

import '../../../utils/config_storage.dart';

class ConfigView extends StatefulWidget {
  final Config config;

  const ConfigView({Key? key, required this.config}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ConfigViewState createState() => _ConfigViewState();
}

class _ConfigViewState extends State<ConfigView> {
  Future<void> _saveConfig() async {
    await ConfigStorage.setConfig(
      widget.config,
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
            initialValue: widget.config.openAiKey,
            onChanged: (value) {
              setState(() {
                widget.config.openAiKey = value;
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
}
