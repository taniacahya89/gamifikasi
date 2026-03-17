// ============================================================
// FILE: edit_profile_page.dart
// FUNGSI: Halaman untuk mengubah nama lengkap user.
//
// ATURAN PENTING:
//   - Hanya nama lengkap yang bisa diubah
//   - Email TIDAK bisa diubah (ditampilkan sebagai info saja)
//   - Email adalah identitas akun yang bersifat permanen
//
// ALUR SIMPAN:
//   User ketik nama baru → tekan "Simpan Perubahan"
//   → _simpanProfil() dipanggil
//   → AuthProvider.updateUser() memperbarui data user
//   → Snackbar sukses muncul → halaman ditutup (pop)
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../auth/providers/auth_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  /// Kontroler untuk input nama — menyimpan teks yang diketik user
  late final TextEditingController _namaController;

  @override
  void initState() {
    super.initState();
    // Isi input dengan nama user saat ini sebagai nilai awal
    final user = context.read<AuthProvider>().user;
    _namaController = TextEditingController(text: user?.fullName ?? '');
  }

  @override
  void dispose() {
    // Selalu dispose TextEditingController untuk menghindari memory leak
    _namaController.dispose();
    super.dispose();
  }

  // ──────────────────────────────────────────────────────────
  // FUNGSI SIMPAN
  // ──────────────────────────────────────────────────────────

  /// Menyimpan nama baru ke data user.
  ///
  /// Validasi: nama tidak boleh kosong (trim() menghapus spasi di tepi).
  /// Jika valid:
  ///   1. Panggil AuthProvider.updateUser() dengan nama baru
  ///   2. Tampilkan snackbar sukses berwarna hijau
  ///   3. Tutup halaman ini (kembali ke ProfilePage)
  void _simpanProfil() {
    final namaBaru = _namaController.text.trim();

    // Validasi: pastikan nama tidak kosong
    if (namaBaru.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama tidak boleh kosong'),
          backgroundColor: AppColors.coral,
        ),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final user = auth.user;
    if (user == null) return;

    // Perbarui hanya nama — email tetap sama (tidak diubah)
    auth.updateUser(user.copyWith(fullName: namaBaru));

    // Tampilkan konfirmasi keberhasilan
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil berhasil diperbarui! ✓'),
        backgroundColor: AppColors.successGreen,
      ),
    );

    // Kembali ke halaman sebelumnya (ProfilePage)
    Navigator.of(context).pop();
  }

  // ──────────────────────────────────────────────────────────
  // BUILD UI
  // ──────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Ambil email untuk ditampilkan sebagai info (read-only)
    final email = context.read<AuthProvider>().user?.email ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // AppBar dengan judul "Edit Profile"
          const CustomAppBar(title: AppStrings.editProfile),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  // ── Avatar Netral (tidak bisa diubah) ─────────────
                  // Ikon yang sama untuk semua user — tidak menggambarkan gender
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                    child: const Center(
                      child: Text('⭐', style: TextStyle(fontSize: 42)),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── Input Nama Lengkap (BISA diubah) ──────────────
                  const _FieldLabel('Nama Lengkap'),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _namaController,
                    hintText: 'Masukkan nama lengkap',
                  ),
                  const SizedBox(height: 20),

                  // ── Info Email (TIDAK bisa diubah) ─────────────────
                  const _FieldLabel('Email'),
                  const SizedBox(height: 8),

                  // Email ditampilkan sebagai kotak info, bukan input
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEEEEE),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            email,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.greyText,
                            ),
                          ),
                        ),
                        // Ikon kunci menunjukkan email tidak bisa diubah
                        const Icon(
                          Icons.lock_outline_rounded,
                          size: 16,
                          color: AppColors.greyText,
                        ),
                      ],
                    ),
                  ),
                  // Keterangan mengapa email tidak bisa diubah
                  const Padding(
                    padding: EdgeInsets.only(top: 6, left: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Email adalah identitas akun dan tidak dapat diubah.',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.greyText,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // ── Tombol Simpan ──────────────────────────────────
                  PrimaryButton(
                    label: 'Simpan Perubahan',
                    onPressed: _simpanProfil,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// WIDGET PEMBANTU: Label field input
// ──────────────────────────────────────────────────────────

/// Teks label yang muncul di atas setiap input field.
class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
