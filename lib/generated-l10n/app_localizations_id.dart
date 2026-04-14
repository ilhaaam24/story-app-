// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Aplikasi Cerita';

  @override
  String get login => 'Masuk';

  @override
  String get register => 'Daftar';

  @override
  String get logout => 'Keluar';

  @override
  String get email => 'Email';

  @override
  String get password => 'Kata Sandi';

  @override
  String get name => 'Nama';

  @override
  String get description => 'Deskripsi';

  @override
  String get addStory => 'Tambah Cerita';

  @override
  String get pickImage => 'Pilih Gambar';

  @override
  String get noAccount => 'Belum punya akun? Daftar';

  @override
  String get haveAccount => 'Sudah punya akun? Masuk';

  @override
  String get pleaseEnterEmail => 'Silakan masukkan email';

  @override
  String get pleaseEnterPassword => 'Silakan masukkan kata sandi';

  @override
  String get pleaseEnterName => 'Silakan masukkan nama';

  @override
  String get pleaseEnterDescription => 'Silakan masukkan deskripsi';

  @override
  String get failedToLogin => 'Gagal masuk';

  @override
  String get failedToRegister => 'Gagal mendaftar';

  @override
  String get failedToAddStory => 'Gagal menambah cerita';

  @override
  String get successRegister => 'Pendaftaran berhasil! Silakan masuk.';

  @override
  String get camera => 'Kamera';

  @override
  String get gallery => 'Galeri';

  @override
  String get noStories => 'Tidak ada cerita tersedia';

  @override
  String get detailStory => 'Detail Cerita';

  @override
  String get createdAt => 'Dibuat pada';

  @override
  String get logoutApp => 'Apakah Anda yakin ingin keluar?';

  @override
  String get cancel => 'Batal';

  @override
  String get somethingWentWrong => 'Terjadi kesalahan';

  @override
  String get retry => 'Coba Lagi';

  @override
  String get welcomeBack =>
      'Selamat datang kembali! Silakan masuk untuk melanjutkan.';

  @override
  String get createAccount => 'Buat akun untuk mulai berbagi cerita Anda.';

  @override
  String get passwordMinLength => 'Kata sandi minimal harus 8 karakter';

  @override
  String get storyUploaded => 'Cerita berhasil diunggah!';
}
