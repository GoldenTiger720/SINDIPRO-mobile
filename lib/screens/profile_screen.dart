import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditingProfile = false;
  
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _loadUserData(String? username, String email) {
    _usernameController.text = username ?? email.split('@')[0];
    _emailController.text = email;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageProvider, AuthProvider>(
      builder: (context, languageProvider, authProvider, child) {
        final user = authProvider.user;
        if (user == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        // Load user data into controllers
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _loadUserData(user.username, user.email);
        });
        return Scaffold(
          backgroundColor: const Color(0xFFF9FAFB), // bg-gray-50
          appBar: AppBar(
            title: Text(languageProvider.myProfile),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0.5,
          ),
          body: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 896), // max-w-4xl
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page Header
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        languageProvider.myProfile,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827), // text-gray-900
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        languageProvider.currentLocale.languageCode == 'en'
                            ? 'Manage your account settings and preferences'
                            : 'Gerencie suas configurações de conta e preferências',
                        style: const TextStyle(
                          color: Color(0xFF6B7280), // text-gray-600
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),

                  // Profile Information Card
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Card Header
                          Row(
                            children: [
                              const Icon(Icons.person, color: Color(0xFF6366F1)),
                              const SizedBox(width: 8),
                              Text(
                                languageProvider.personalInformation,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 24),

                          // Avatar Section
                          Row(
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: const Color(0xFF2563EB),
                                    child: Text(
                                      (user.username ?? user.email)[0].toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 32,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(languageProvider.currentLocale.languageCode == 'en'
                                                ? 'Photo upload coming soon'
                                                : 'Upload de foto em breve'),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
                                        ),
                                        child: const Icon(
                                          Icons.camera_alt,
                                          size: 16,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.username ?? user.email.split('@')[0],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF111827),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      user.email,
                                      style: const TextStyle(
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      languageProvider.currentLocale.languageCode == 'en'
                                          ? 'Role: ${user.role.toUpperCase()}'
                                          : 'Função: ${user.role.toUpperCase()}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF9CA3AF),
                                      ),
                                    ),
                                    if (user.condominium != null) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        languageProvider.currentLocale.languageCode == 'en'
                                            ? 'Building: ${user.condominium}'
                                            : 'Edifício: ${user.condominium}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF9CA3AF),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // Form Fields
                          Column(
                            children: [
                              _buildTextField(
                                label: languageProvider.username,
                                controller: _usernameController,
                                enabled: _isEditingProfile,
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                label: languageProvider.email,
                                controller: _emailController,
                                enabled: _isEditingProfile,
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Action Buttons
                          Row(
                            children: [
                              if (!_isEditingProfile) ...[
                                Flexible(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _isEditingProfile = true;
                                      });
                                    },
                                    icon: const Icon(Icons.edit),
                                    label: Text(languageProvider.editProfile),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2563EB),
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ] else ...[
                                Flexible(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _isEditingProfile = false;
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(languageProvider.currentLocale.languageCode == 'en'
                                              ? 'Profile updated successfully'
                                              : 'Perfil atualizado com sucesso'),
                                          backgroundColor: const Color(0xFF10B981),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.save),
                                    label: Text(languageProvider.saveChanges),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF10B981),
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Flexible(
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _isEditingProfile = false;
                                        _loadUserData(user.username, user.email); // Reset form
                                      });
                                    },
                                    child: Text(languageProvider.cancel),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Change Password Card
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Card Header
                          Row(
                            children: [
                              const Icon(Icons.vpn_key, color: Color(0xFF6366F1)),
                              const SizedBox(width: 8),
                              Text(
                                languageProvider.changePassword,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 24),

                          // Password Fields
                          Column(
                            children: [
                              _buildTextField(
                                label: languageProvider.currentLocale.languageCode == 'en'
                                    ? 'Current Password'
                                    : 'Senha Atual',
                                controller: _currentPasswordController,
                                obscureText: true,
                                enabled: true,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTextField(
                                      label: languageProvider.currentLocale.languageCode == 'en'
                                          ? 'New Password'
                                          : 'Nova Senha',
                                      controller: _newPasswordController,
                                      obscureText: true,
                                      enabled: true,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildTextField(
                                      label: languageProvider.currentLocale.languageCode == 'en'
                                          ? 'Confirm New Password'
                                          : 'Confirmar Nova Senha',
                                      controller: _confirmPasswordController,
                                      obscureText: true,
                                      enabled: true,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Change Password Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_newPasswordController.text != _confirmPasswordController.text) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(languageProvider.passwordsDoNotMatch),
                                      backgroundColor: const Color(0xFFEF4444),
                                    ),
                                  );
                                  return;
                                }
                                
                                // Clear fields
                                _currentPasswordController.clear();
                                _newPasswordController.clear();
                                _confirmPasswordController.clear();
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(languageProvider.currentLocale.languageCode == 'en'
                                        ? 'Password changed successfully'
                                        : 'Senha alterada com sucesso'),
                                    backgroundColor: const Color(0xFF10B981),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Text(languageProvider.changePassword),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Account Statistics Card
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Card Header
                          Row(
                            children: [
                              const Icon(Icons.analytics, color: Color(0xFF6366F1)),
                              const SizedBox(width: 8),
                              Text(
                                languageProvider.currentLocale.languageCode == 'en'
                                    ? 'Account Statistics'
                                    : 'Estatísticas da Conta',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 24),

                          // Statistics Grid
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildStatCard(
                                      title: languageProvider.currentLocale.languageCode == 'en'
                                          ? (user.isManager ? 'Buildings Managed' : 'Buildings Assigned')
                                          : (user.isManager ? 'Edifícios Gerenciados' : 'Edifícios Atribuídos'),
                                      value: user.isManager ? '-' : (user.condominium != null ? '1' : '0'),
                                      color: const Color(0xFF2563EB),
                                      backgroundColor: const Color(0xFFEFF6FF),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildStatCard(
                                      title: languageProvider.currentLocale.languageCode == 'en'
                                          ? 'User ID'
                                          : 'ID do Usuário',
                                      value: user.id.toString(),
                                      color: const Color(0xFF10B981),
                                      backgroundColor: const Color(0xFFECFDF5),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildStatCard(
                                      title: languageProvider.currentLocale.languageCode == 'en'
                                          ? 'Access Level'
                                          : 'Nível de Acesso',
                                      value: user.isManager 
                                          ? (languageProvider.currentLocale.languageCode == 'en' ? 'Full' : 'Total')
                                          : (languageProvider.currentLocale.languageCode == 'en' ? 'Limited' : 'Limitado'),
                                      color: const Color(0xFF8B5CF6),
                                      backgroundColor: const Color(0xFFF3E8FF),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool enabled = true,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          enabled: enabled,
          obscureText: obscureText,
          decoration: InputDecoration(
            filled: !enabled,
            fillColor: !enabled ? const Color(0xFFF9FAFB) : null,
            border: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF2563EB)),
            ),
            disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE5E7EB)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}