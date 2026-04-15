import 'package:auth_domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:ui/constants/app_colors.dart';
import 'package:ui/constants/app_text_styles.dart';
import 'package:ui/extensions/alert_dialog_extension.dart';
import 'package:ui/widgets/common_btn.dart';
import 'package:ui/widgets/custom_text_field.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key, required this.user});

  final UserEntity? user;

  @override
  Widget build(BuildContext context) {

    return ListView(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // User Avatar
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.primaryColor,
                  child: Text(
                    user?.firstName?.toUpperCase() ?? "",
                    style: AppTextStyles.h1.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Welcome Message
                Text(
                  'Welcome, ${user?.firstName}',
                  style: AppTextStyles.h2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        icon: Icons.person_outline,
                        label: 'Name',
                        value: user?.name ?? "the name is null",
                      ),
                      const Divider(height: 24),
                      _buildInfoRow(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: user?.email ?? "email",
                      ),
                      const Divider(height: 24),
                      _buildInfoRow(
                        icon: Icons.badge_outlined,
                        label: 'User ID',
                        value: user?.idSsn ?? "idSSn",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
