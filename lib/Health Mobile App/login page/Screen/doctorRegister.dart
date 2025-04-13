import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mediwise/Health%20Mobile%20App/login%20page/Screen/doctorLogin.dart';

class DoctorRegisterPage extends StatefulWidget {
  const DoctorRegisterPage({super.key});

  @override
  State<DoctorRegisterPage> createState() => _DoctorRegisterPageState();
}

class _DoctorRegisterPageState extends State<DoctorRegisterPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  final _pageController = PageController();

  // Form Fields
  String _fullName = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _phone = '';
  String _specialization = '';
  String _licenseNumber = '';
  String _hospital = '';
  String _yearsOfExperience = '';
  String _error = '';
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final List<String> _specializations = [
    'Cardiology',
    'Dermatology',
    'Neurology',
    'Pediatrics',
    'Orthopedics',
    'General Medicine',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    Future.delayed(200.ms, () => _animationController.forward());
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _registerDoctor() async {
    if (_formKey.currentState!.validate()) {
      if (_password != _confirmPassword) {
        setState(() => _error = 'Passwords do not match');
        return;
      }

      setState(() {
        _isLoading = true;
        _error = '';
      });

      try {
        // Simulate API call
        await Future.delayed(2.seconds);

        // Replace with actual registration:
        // await AuthService().registerDoctor(...);

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => const DoctorLoginPage(),
              transitionDuration: 600.ms,
              transitionsBuilder: (_, a, __, c) => FadeTransition(
                    opacity: a,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(a),
                      child: c,
                    ),
                  )),
        );
      } catch (e) {
        setState(() {
          _error = 'Registration failed. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.teal.shade50,
              Colors.blue.shade50,
              Colors.white,
            ],
            stops: const [0.1, 0.5, 0.9],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 50, 24, 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Header
                Column(
                  children: [
                    Lottie.asset(
                      'assets/animation/doctor.json',
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      'Join Mediwise as a Doctor',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade800,
                      ),
                    ).animate().fadeIn(delay: 200.ms).slideY(
                          begin: 0.2,
                          end: 0,
                          curve: Curves.easeOutQuint,
                        ),
                    Text(
                      'Complete your professional profile',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.teal.shade600,
                      ),
                    ).animate().fadeIn(delay: 300.ms),
                  ],
                ),

                const SizedBox(height: 40),

                // Registration Form
                Material(
                  elevation: 16,
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.white.withOpacity(0.96),
                  shadowColor: Colors.teal.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Personal Information Section
                          _buildSectionHeader('Personal Information')
                              .animate()
                              .fadeIn(delay: 400.ms)
                              .slideX(
                                begin: -0.2,
                                end: 0,
                              ),

                          const SizedBox(height: 16),

                          _buildTextField(
                            label: 'Full Name',
                            icon: Icons.person_outline_rounded,
                            validator: (val) =>
                                val!.isEmpty ? 'Required' : null,
                            onChanged: (val) => _fullName = val,
                          ).animate().fadeIn(delay: 450.ms),

                          const SizedBox(height: 16),

                          _buildTextField(
                            label: 'Email',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) =>
                                !val!.contains('@') ? 'Invalid email' : null,
                            onChanged: (val) => _email = val,
                          ).animate().fadeIn(delay: 500.ms),

                          const SizedBox(height: 16),

                          _buildTextField(
                            label: 'Phone Number',
                            icon: Icons.phone_rounded,
                            keyboardType: TextInputType.phone,
                            validator: (val) =>
                                val!.length < 10 ? 'Invalid number' : null,
                            onChanged: (val) => _phone = val,
                          ).animate().fadeIn(delay: 550.ms),

                          const SizedBox(height: 24),

                          // Professional Information Section
                          _buildSectionHeader('Professional Details')
                              .animate()
                              .fadeIn(delay: 600.ms)
                              .slideX(
                                begin: -0.2,
                                end: 0,
                              ),

                          const SizedBox(height: 16),

                          _buildSpecializationDropdown()
                              .animate()
                              .fadeIn(delay: 650.ms),

                          const SizedBox(height: 16),

                          _buildTextField(
                            label: 'Medical License Number',
                            icon: Icons.badge_rounded,
                            validator: (val) =>
                                val!.isEmpty ? 'Required' : null,
                            onChanged: (val) => _licenseNumber = val,
                          ).animate().fadeIn(delay: 700.ms),

                          const SizedBox(height: 16),

                          _buildTextField(
                            label: 'Hospital/Clinic',
                            icon: Icons.local_hospital_rounded,
                            validator: (val) =>
                                val!.isEmpty ? 'Required' : null,
                            onChanged: (val) => _hospital = val,
                          ).animate().fadeIn(delay: 750.ms),

                          const SizedBox(height: 16),

                          _buildTextField(
                            label: 'Years of Experience',
                            icon: Icons.work_history_rounded,
                            keyboardType: TextInputType.number,
                            validator: (val) =>
                                val!.isEmpty ? 'Required' : null,
                            onChanged: (val) => _yearsOfExperience = val,
                          ).animate().fadeIn(delay: 800.ms),

                          const SizedBox(height: 24),

                          // Security Section
                          _buildSectionHeader('Account Security')
                              .animate()
                              .fadeIn(delay: 850.ms)
                              .slideX(
                                begin: -0.2,
                                end: 0,
                              ),

                          const SizedBox(height: 16),

                          _buildPasswordField(
                            label: 'Password',
                            obscure: _obscurePassword,
                            onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                            validator: (val) =>
                                val!.length < 6 ? 'Minimum 6 characters' : null,
                            onChanged: (val) => _password = val,
                          ).animate().fadeIn(delay: 900.ms),

                          const SizedBox(height: 16),

                          _buildPasswordField(
                            label: 'Confirm Password',
                            obscure: _obscureConfirmPassword,
                            onPressed: () => setState(() =>
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword),
                            validator: (val) =>
                                val!.isEmpty ? 'Required' : null,
                            onChanged: (val) => _confirmPassword = val,
                          ).animate().fadeIn(delay: 950.ms),

                          const SizedBox(height: 8),

                          // Error Message
                          if (_error.isNotEmpty)
                            Text(
                              _error,
                              style: TextStyle(
                                color: Colors.red.shade600,
                                fontSize: 14,
                              ),
                            ).animate().fadeIn().shake(
                                  hz: 4,
                                  curve: Curves.easeInOutCubic,
                                ),

                          const SizedBox(height: 24),

                          // Register Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal.shade600,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 0,
                                shadowColor: Colors.transparent,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              onPressed: _isLoading ? null : _registerDoctor,
                              child: _isLoading
                                  ? Lottie.asset(
                                      'assets/animation/loading_animation.json',
                                      width: 40,
                                      height: 40,
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'COMPLETE REGISTRATION',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ).animate().fadeIn(delay: 1000.ms).slideY(
                                begin: 0.2,
                                end: 0,
                                curve: Curves.easeOutQuint,
                              ),
                        ],
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 350.ms).scaleXY(
                      begin: 0.95,
                      end: 1,
                      curve: Curves.easeOutBack,
                    ),

                const SizedBox(height: 24),

                // Login Prompt
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already registered? ',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) =>
                                const DoctorLoginPage(),
                            transitionDuration: 600.ms,
                            transitionsBuilder: (_, a, __, c) => FadeTransition(
                              opacity: a,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 1),
                                  end: Offset.zero,
                                ).animate(a),
                                child: c,
                              ),
                            ),
                          ),
                        ),
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.teal.shade700,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 1100.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String text) {
    return Row(
      children: [
        Icon(Icons.fiber_manual_record_rounded,
            size: 12, color: Colors.teal.shade400),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.teal.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.teal.shade700),
        prefixIcon: Container(
          width: 40,
          alignment: Alignment.center,
          child: Icon(icon, color: Colors.teal.shade400),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.teal.shade50.withOpacity(0.4),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      keyboardType: keyboardType,
      validator: validator != null ? (val) => validator(val) : (val) => null,
      onChanged: onChanged,
    );
  }

  Widget _buildPasswordField({
    required String label,
    required bool obscure,
    required VoidCallback onPressed,
    required String? Function(String?)? validator,
    required void Function(String)? onChanged,
  }) {
    return TextFormField(
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.teal.shade700),
        prefixIcon: Container(
          width: 40,
          alignment: Alignment.center,
          child: Icon(Icons.lock_outline_rounded, color: Colors.teal.shade400),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
            color: Colors.teal.shade400,
          ),
          onPressed: onPressed,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.teal.shade50.withOpacity(0.4),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }

  Widget _buildSpecializationDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Specialization',
        labelStyle: TextStyle(color: Colors.teal.shade700),
        prefixIcon: Container(
          width: 40,
          alignment: Alignment.center,
          child:
              Icon(Icons.medical_services_rounded, color: Colors.teal.shade400),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.teal.shade50.withOpacity(0.4),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      items: _specializations.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (val) => setState(() => _specialization = val!),
      validator: (val) => val == null ? 'Required' : null,
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
      icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.teal.shade400),
    );
  }
}
