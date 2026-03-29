enum AiProviderOption {
  google,
  openai,
  anthropic;

  String get wireValue => switch (this) {
    AiProviderOption.google => 'google',
    AiProviderOption.openai => 'openai',
    AiProviderOption.anthropic => 'anthropic',
  };

  String get label => switch (this) {
    AiProviderOption.google => 'Google Gemini',
    AiProviderOption.openai => 'OpenAI Compatible',
    AiProviderOption.anthropic => 'Anthropic Claude',
  };

  static AiProviderOption? tryParse(String? rawValue) {
    return AiProviderOption.values
        .where((item) => item.wireValue == rawValue)
        .firstOrNull;
  }
}
