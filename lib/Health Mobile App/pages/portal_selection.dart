import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:mediwise/Health%20Mobile%20App/login%20page/Screen/doctorLogin.dart';
import 'package:mediwise/Health%20Mobile%20App/login%20page/Screen/login.dart';

class PortalSelectionPage extends StatelessWidget {
  const PortalSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.teal.shade50,
              Colors.blue.shade50,
            ],
            // stops: const [0.1, 0.5],
          ),
        ),
        child: Stack(
          children: [
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Header
                      Column(
                        children: [
                          Lottie.asset(
                            'assets/animation/portal.json',
                            width: 180,
                            height: 180,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Welcome to MediWise',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.shade900,
                              letterSpacing: 0.5,
                            ),
                          ).animate().fadeIn(delay: 200.ms).slideY(
                                begin: 0.1,
                                end: 0,
                                curve: Curves.easeOutQuint,
                              ),
                          Text(
                            'Your Health, Our Priority',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.teal.shade700,
                            ),
                          ).animate().fadeIn(delay: 300.ms),
                        ],
                      ),

                      const SizedBox(height: 48),

                      // Portal Cards
                      Column(
                        children: [
                          // Patient Portal
                          _buildPortalCard(
                            context,
                            title: 'Patient Portal',
                            subtitle:
                                'Access health records and book appointments',
                            icon: Icons.health_and_safety_rounded,
                            color: Colors.blue,
                            iconColor: Colors.blue.shade100,
                            animationDelay: 400.ms,
                            onTap: () =>
                                _navigateTo(context, const LoginScreen()),
                          ),

                          const SizedBox(height: 24),

                          // Doctor Portal
                          _buildPortalCard(
                            context,
                            title: 'Doctor Portal',
                            subtitle: 'Manage patients and appointments',
                            icon: Icons.medical_services_rounded,
                            color: Colors.teal.shade700,
                            iconColor: Colors.teal.shade100,
                            animationDelay: 500.ms,
                            onTap: () =>
                                _navigateTo(context, const DoctorLoginPage()),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // Features Footer
                      _buildFeaturesFooter().animate().fadeIn(delay: 700.ms),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
      ),
    );
  }

  Widget _buildPortalCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required Duration animationDelay,
    required VoidCallback onTap,
  }) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        splashColor: color.withOpacity(0.1),
        highlightColor: color.withOpacity(0.05),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.05),
                color.withOpacity(0.02),
              ],
            ),
            border: Border.all(
              color: color.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Icon Container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: iconColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(width: 20),

              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
                color: color,
              ),
            ],
          ),
        ),
      ),
    )
        .animate(delay: animationDelay)
        .fadeIn()
        .slideX(
          begin: -0.1,
          end: 0,
          curve: Curves.easeOutQuint,
        )
        .scaleXY(
          begin: 0.95,
          end: 1,
          curve: Curves.easeOutBack,
        );
  }

  Widget _buildFeaturesFooter() {
    return Column(
      children: [
        const SizedBox(height: 24),
        Wrap(
          spacing: 24,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: [
            _buildFeatureItem(Icons.verified_user_rounded, 'Certified'),
            _buildFeatureItem(Icons.security_rounded, 'Secure'),
            _buildFeatureItem(Icons.support_agent_rounded, '24/7 Support'),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'MediWise © 2025',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.teal.shade700,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
