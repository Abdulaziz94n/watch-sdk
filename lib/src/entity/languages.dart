class Languages {
  static const int DEFAULT_CODE = 0x01;

  static const int INVALID_CODE = 0x1F; // R5语言包刷错时，code会变成该值

  static const String DEFAULT_LANGUAGE = "en";

  static const Map LANGUAGES = {
    "zh": 0x00, // 中文(简体)
    "en": 0x01, // 英语
    "tr": 0x02, // 土耳其语
    "ru": 0x04, // 俄语
    "es": 0x05, // 西班牙语
    "it": 0x06, // 意大利语
    "ko": 0x07, // 韩语
    "pt": 0x08, // 葡萄牙语
    "de": 0x09, // 德语
    "fr": 0x0A, // 法语
    "nl": 0x0B, // 荷兰语
    "pl": 0x0C, // 波兰语
    "cs": 0x0D, // 捷克语
    "hu": 0x0E, // 匈牙利语
    "sk": 0x0F, // 斯洛伐克语
    "ja": 0x10, // 日语
    "da": 0x11, // 丹麦
    "fi": 0x12, // 芬兰
    "no": 0x13, // 挪威
    "sv": 0x14, // 瑞典
    "sr": 0x15, // 塞尔维亚
    "th": 0x16, // 泰语
    "hi": 0x17, // 印地语
    "el": 0x18, // 希腊语
    "Hant": 0x19, // 中文繁体
    "lt": 0x1A, // 立陶宛
    "vi": 0x1B, // 越南
    "ar": 0x1C, // 阿拉伯语
    "in": 0x1D, // 印尼语
    "uk": 0x1E, // 乌克兰
    // "invalid" : 0x1F  // 1F不能再使用，R5语言包刷错时，code会变成该值
    "iw": 0x20, // 希伯来语
    "bn": 0x21, // 孟加拉语
    "et": 0x22, // 爱沙尼亚
    "sl": 0x23, // 斯洛文尼亚
    "fa": 0x24, // 波斯语
    "ro": 0x25, // 罗马尼亚
    "bg": 0x26, // 保加利亚
    "hr": 0x27, // 克罗地亚
    "ur": 0x28 // 乌尔都语
  };
}
