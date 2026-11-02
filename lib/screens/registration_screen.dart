import 'package:flutter/material.dart';

import '../widgets/custom_text_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controller
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController(); // Latihan 1
  final _dobController = TextEditingController(); // Latihan 2
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State Variables
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  String? _selectedGender; // Latihan 3
  bool _isAgreed = false; // Latihan 4
  bool _showAgreedError = false;

  // Latihan 5: Password Strength State
  double _strengthProgress = 0.0;
  String _strengthLabel = '';
  Color _strengthColor = Colors.grey;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // --- LOGIKA LATIHAN 5: KEKUATAN PASSWORD ---
  void _checkPasswordStrength(String value) {
    if (value.isEmpty) {
      setState(() {
        _strengthProgress = 0.0;
        _strengthLabel = '';
        _strengthColor = Colors.grey;
      });
      return;
    }

    bool hasUpper = value.contains(RegExp(r'[A-Z]'));
    bool hasLower = value.contains(RegExp(r'[a-z]'));
    bool hasDigits = value.contains(RegExp(r'[0-9]'));
    bool hasSpecial = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (value.length >= 8 && hasUpper && hasLower && hasDigits && hasSpecial) {
      setState(() {
        _strengthProgress = 1.0;
        _strengthLabel = 'Kekuatan Password: Kuat';
        _strengthColor = Colors.green;
      });
    } else if (value.length >= 8 && ((hasUpper || hasLower) && hasDigits)) {
      setState(() {
        _strengthProgress = 0.66;
        _strengthLabel = 'Kekuatan Password: Sedang';
        _strengthColor = Colors.orange;
      });
    } else {
      setState(() {
        _strengthProgress = 0.33;
        _strengthLabel = 'Kekuatan Password: Lemah';
        _strengthColor = Colors.red;
      });
    }
  }

  // --- LOGIKA LATIHAN 2: DATE PICKER ---
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _dobController.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  // --- VALIDATOR FUNGSI ---
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Nama tidak boleh kosong';
    if (value.trim().length < 3) return 'Nama minimal 3 karakter';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty)
      return 'Email tidak boleh kosong';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) return 'Format email tidak valid';
    return null;
  }

  // Latihan 1: Validasi Nomor Telepon
  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty)
      return 'Nomor telepon tidak boleh kosong';
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim()))
      return 'Hanya boleh berisi angka';
    if (value.trim().length < 10 || value.trim().length > 13)
      return 'Nomor telepon harus 10-13 digit';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password tidak boleh kosong';
    if (value.length < 8) return 'Password minimal 8 karakter';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty)
      return 'Konfirmasi password tidak boleh kosong';
    if (value != _passwordController.text) return 'Password tidak cocok';
    return null;
  }

  // --- SUBMIT FORM ---
  void _submitForm() async {
    setState(() {
      _showAgreedError = !_isAgreed; // Latihan 4 validation check
    });

    if (_formKey.currentState!.validate() && _isAgreed) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isLoading = false);

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Registrasi Berhasil'),
          content: Text(
            'Selamat datang, ${_nameController.text}!\nEmail: ${_emailController.text}\nNo HP: ${_phoneController.text}\nGender: $_selectedGender',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Registrasi'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.person_add_alt_1,
                size: 60,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 12),
              const Text(
                'Buat Akun Baru',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // Nama
              CustomTextField(
                controller: _nameController,
                labelText: 'Nama Lengkap',
                prefixIcon: Icons.person,
                validator: _validateName,
              ),
              const SizedBox(height: 16),

              // Email
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              const SizedBox(height: 16),

              // LATIHAN 1: Nomor Telepon
              CustomTextField(
                controller: _phoneController,
                labelText: 'Nomor Telepon',
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: _validatePhone,
              ),
              const SizedBox(height: 16),

              // LATIHAN 2: Tanggal Lahir
              CustomTextField(
                controller: _dobController,
                labelText: 'Tanggal Lahir',
                prefixIcon: Icons.calendar_today,
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (val) => val == null || val.isEmpty
                    ? 'Tanggal lahir wajib diisi'
                    : null,
              ),
              const SizedBox(height: 16),

              // LATIHAN 3: Dropdown Jenis Kelamin
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: InputDecoration(
                  labelText: 'Jenis Kelamin',
                  prefixIcon: const Icon(Icons.people),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: ['Laki-laki', 'Perempuan'].map((gender) {
                  return DropdownMenuItem(value: gender, child: Text(gender));
                }).toList(),
                onChanged: (val) => setState(() => _selectedGender = val),
                validator: (val) =>
                    val == null ? 'Jenis kelamin wajib dipilih' : null,
              ),
              const SizedBox(height: 16),

              // Password
              CustomTextField(
                controller: _passwordController,
                labelText: 'Password',
                prefixIcon: Icons.lock,
                obscureText: !_isPasswordVisible,
                onChanged: _checkPasswordStrength, // Latihan 5
                validator: _validatePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () =>
                      setState(() => _isPasswordVisible = !_isPasswordVisible),
                ),
              ),

              // LATIHAN 5: Visual Indikator Kekuatan Password
              if (_strengthLabel.isNotEmpty) ...[
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: _strengthProgress,
                  backgroundColor: Colors.grey.shade300,
                  color: _strengthColor,
                  minHeight: 6,
                ),
                const SizedBox(height: 4),
                Text(
                  _strengthLabel,
                  style: TextStyle(
                    color: _strengthColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              const SizedBox(height: 16),

              // Konfirmasi Password
              CustomTextField(
                controller: _confirmPasswordController,
                labelText: 'Konfirmasi Password',
                prefixIcon: Icons.lock_outline,
                obscureText: !_isConfirmPasswordVisible,
                validator: _validateConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () => setState(
                    () =>
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // LATIHAN 4: Checkbox Syarat & Ketentuan
              CheckboxListTile(
                title: const Text(
                  'Saya menyetujui syarat & ketentuan yang berlaku',
                  style: TextStyle(fontSize: 14),
                ),
                value: _isAgreed,
                onChanged: (val) => setState(() {
                  _isAgreed = val ?? false;
                  if (_isAgreed) _showAgreedError = false;
                }),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              if (_showAgreedError)
                const Text(
                  '  Anda harus menyetujui syarat & ketentuan',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              const SizedBox(height: 20),

              // Tombol Submit
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Daftar',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
