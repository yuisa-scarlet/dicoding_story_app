import 'package:flutter/material.dart';

class AppStrings {
  const AppStrings(this.locale);

  final Locale locale;

  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
    Locale('ja'),
  ];

  static const LocalizationsDelegate<AppStrings> delegate =
      _AppStringsDelegate();

  static AppStrings of(BuildContext context) {
    return Localizations.of<AppStrings>(context, AppStrings) ??
        const AppStrings(Locale('en'));
  }

  String _value(String en, String id, String ja) {
    switch (locale.languageCode) {
      case 'id':
        return id;
      case 'ja':
        return ja;
      default:
        return en;
    }
  }

  String get appTitle => _value('Story App', 'Story App', 'ストーリーアプリ');
  String get login => _value('Login', 'Masuk', 'ログイン');
  String get register => _value('Register', 'Daftar', '登録');
  String get email => _value('Email', 'Email', 'メール');
  String get password => _value('Password', 'Kata Sandi', 'パスワード');
  String get fullName => _value('Full Name', 'Nama Lengkap', '氏名');
  String get home => _value('Home', 'Beranda', 'ホーム');
  String get addStory => _value('Add Story', 'Tambah Cerita', 'ストーリー追加');
  String get settings => _value('Settings', 'Pengaturan', '設定');
  String get description => _value('Description', 'Deskripsi', '説明');
  String get selectImage => _value('Select Image', 'Pilih Gambar', '画像を選択');
  String get uploadStory => _value('Upload Story', 'Unggah Cerita', 'ストーリーを送信');
  String get logout => _value('Logout', 'Keluar', 'ログアウト');
  String get retry => _value('Retry', 'Coba Lagi', '再試行');
  String get noStories => _value(
      'No stories available yet.', 'Belum ada cerita.', 'まだストーリーがありません。');
  String get language => _value('Language', 'Bahasa', '言語');
  String get english => _value('English', 'Inggris', '英語');
  String get indonesian => _value('Indonesian', 'Indonesia', 'インドネシア語');
  String get japanese => _value('Japanese', 'Jepang', '日本語');
  String get latitude => _value('Latitude', 'Latitude', '緯度');
  String get longitude => _value('Longitude', 'Longitude', '経度');
  String get choosePhotoFirst => _value(
        'Please choose a photo first.',
        'Silakan pilih foto terlebih dahulu.',
        '最初に写真を選択してください。',
      );
  String get uploadSuccess => _value(
        'Story uploaded successfully.',
        'Cerita berhasil diunggah.',
        'ストーリーの送信に成功しました。',
      );
  String get sessionExpired => _value(
        'Session expired. Please login again.',
        'Sesi habis. Silakan login kembali.',
        'セッションの有効期限が切れました。再度ログインしてください。',
      );
  String get createAccount => _value('Create account', 'Buat akun', 'アカウント作成');
  String get welcomeBack =>
      _value('Welcome back', 'Selamat datang kembali', 'おかえりなさい');
  String get loginSubtitle => _value(
        'Sign in to continue sharing your learning moments.',
        'Masuk untuk melanjutkan berbagi momen belajarmu.',
        '学習の瞬間を共有するためにログインしてください。',
      );
  String get registerSubtitle => _value(
        'Create a new account to start posting stories.',
        'Buat akun baru untuk mulai mengunggah cerita.',
        '新しいアカウントを作成してストーリーを投稿しましょう。',
      );
  String get haveAccount =>
      _value('Already have an account?', 'Sudah punya akun?', 'アカウントをお持ちですか？');
  String get noAccount => _value(
        'Don\'t have an account?',
        'Belum punya akun?',
        'アカウントをお持ちではありませんか？',
      );
  String get requiredField => _value(
        'This field is required.',
        'Kolom ini wajib diisi.',
        'この項目は必須です。',
      );
  String get invalidEmail =>
      _value('Invalid email.', 'Email tidak valid.', 'メールアドレスが無効です。');
  String get passwordTooShort => _value(
        'Password must be at least 8 characters.',
        'Password minimal 8 karakter.',
        'パスワードは8文字以上必要です。',
      );
  String storyBy(String name) => _value('By $name', 'Oleh $name', '$name さん');
}

class _AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const _AppStringsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppStrings.supportedLocales
        .map((supportedLocale) => supportedLocale.languageCode)
        .contains(locale.languageCode);
  }

  @override
  Future<AppStrings> load(Locale locale) async {
    return AppStrings(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppStrings> old) => false;
}

extension AppStringsBuildContext on BuildContext {
  AppStrings get strings => AppStrings.of(this);
}
