import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Notification settings
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _reportNotifications = false;
  bool _maintenanceAlerts = true;

  // Privacy & Security settings
  String _profileVisibility = 'team';
  bool _dataSharing = false;
  bool _analytics = true;

  // Appearance settings
  String _theme = 'light';
  bool _compactMode = false;

  // System settings
  bool _autoSave = true;
  String _backupFrequency = 'weekly';

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF9FAFB), // bg-gray-50
          appBar: AppBar(
            title: Text(languageProvider.settings),
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
                        languageProvider.settings,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827), // text-gray-900
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        languageProvider.currentLocale.languageCode == 'en'
                            ? 'Manage your application preferences and settings'
                            : 'Gerencie suas preferências e configurações do aplicativo',
                        style: const TextStyle(
                          color: Color(0xFF6B7280), // text-gray-600
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),

                  // Language & Localization Card
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
                              const Icon(Icons.language, color: Color(0xFF6366F1)),
                              const SizedBox(width: 8),
                              Text(
                                languageProvider.currentLocale.languageCode == 'en'
                                    ? 'Language & Localization'
                                    : 'Idioma e Localização',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 24),

                          // Language Setting
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      languageProvider.language,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF374151),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      languageProvider.currentLocale.languageCode == 'en'
                                          ? 'Choose your preferred language'
                                          : 'Escolha seu idioma preferido',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DropdownButton<String>(
                                value: languageProvider.currentLocale.languageCode,
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    languageProvider.changeLanguage(newValue);
                                  }
                                },
                                items: [
                                  DropdownMenuItem(
                                    value: 'en',
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text('🇺🇸'),
                                        const SizedBox(width: 8),
                                        Text(languageProvider.english),
                                      ],
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'pt',
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text('🇧🇷'),
                                        const SizedBox(width: 8),
                                        Text(languageProvider.portuguese),
                                      ],
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

                  const SizedBox(height: 24),

                  // Notifications Card
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
                              const Icon(Icons.notifications_outlined, color: Color(0xFF6366F1)),
                              const SizedBox(width: 8),
                              Text(
                                languageProvider.notifications,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 24),

                          // Notification Settings
                          Column(
                            children: [
                              _buildSwitchSetting(
                                title: languageProvider.currentLocale.languageCode == 'en'
                                    ? 'Email Notifications'
                                    : 'Notificações por Email',
                                description: languageProvider.currentLocale.languageCode == 'en'
                                    ? 'Receive notifications via email'
                                    : 'Receber notificações por email',
                                value: _emailNotifications,
                                onChanged: (value) {
                                  setState(() {
                                    _emailNotifications = value;
                                  });
                                },
                              ),
                              const Divider(height: 32),
                              _buildSwitchSetting(
                                title: languageProvider.currentLocale.languageCode == 'en'
                                    ? 'Push Notifications'
                                    : 'Notificações Push',
                                description: languageProvider.currentLocale.languageCode == 'en'
                                    ? 'Receive push notifications on your device'
                                    : 'Receber notificações push no seu dispositivo',
                                value: _pushNotifications,
                                onChanged: (value) {
                                  setState(() {
                                    _pushNotifications = value;
                                  });
                                },
                              ),
                              const Divider(height: 32),
                              _buildSwitchSetting(
                                title: languageProvider.currentLocale.languageCode == 'en'
                                    ? 'Report Notifications'
                                    : 'Notificações de Relatórios',
                                description: languageProvider.currentLocale.languageCode == 'en'
                                    ? 'Get notified when reports are ready'
                                    : 'Ser notificado quando relatórios estiverem prontos',
                                value: _reportNotifications,
                                onChanged: (value) {
                                  setState(() {
                                    _reportNotifications = value;
                                  });
                                },
                              ),
                              const Divider(height: 32),
                              _buildSwitchSetting(
                                title: languageProvider.currentLocale.languageCode == 'en'
                                    ? 'Maintenance Alerts'
                                    : 'Alertas de Manutenção',
                                description: languageProvider.currentLocale.languageCode == 'en'
                                    ? 'Receive alerts about maintenance schedules'
                                    : 'Receber alertas sobre cronogramas de manutenção',
                                value: _maintenanceAlerts,
                                onChanged: (value) {
                                  setState(() {
                                    _maintenanceAlerts = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Privacy & Security Card
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
                              const Icon(Icons.security, color: Color(0xFF6366F1)),
                              const SizedBox(width: 8),
                              Text(
                                languageProvider.currentLocale.languageCode == 'en'
                                    ? 'Privacy & Security'
                                    : 'Privacidade e Segurança',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 24),

                          // Privacy Settings
                          Column(
                            children: [
                              _buildDropdownSetting(
                                title: languageProvider.currentLocale.languageCode == 'en'
                                    ? 'Profile Visibility'
                                    : 'Visibilidade do Perfil',
                                description: languageProvider.currentLocale.languageCode == 'en'
                                    ? 'Who can see your profile information'
                                    : 'Quem pode ver suas informações de perfil',
                                value: _profileVisibility,
                                items: [
                                  DropdownMenuItem(
                                    value: 'public',
                                    child: Text(languageProvider.currentLocale.languageCode == 'en'
                                        ? 'Public'
                                        : 'Público'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'private',
                                    child: Text(languageProvider.currentLocale.languageCode == 'en'
                                        ? 'Private'
                                        : 'Privado'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'team',
                                    child: Text(languageProvider.currentLocale.languageCode == 'en'
                                        ? 'Team Only'
                                        : 'Apenas Equipe'),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _profileVisibility = value!;
                                  });
                                },
                              ),
                              const Divider(height: 32),
                              _buildSwitchSetting(
                                title: languageProvider.currentLocale.languageCode == 'en'
                                    ? 'Data Sharing'
                                    : 'Compartilhamento de Dados',
                                description: languageProvider.currentLocale.languageCode == 'en'
                                    ? 'Allow sharing usage data for improvements'
                                    : 'Permitir compartilhamento de dados de uso para melhorias',
                                value: _dataSharing,
                                onChanged: (value) {
                                  setState(() {
                                    _dataSharing = value;
                                  });
                                },
                              ),
                              const Divider(height: 32),
                              _buildSwitchSetting(
                                title: languageProvider.currentLocale.languageCode == 'en'
                                    ? 'Analytics'
                                    : 'Análises',
                                description: languageProvider.currentLocale.languageCode == 'en'
                                    ? 'Help improve the app with usage analytics'
                                    : 'Ajudar a melhorar o app com análises de uso',
                                value: _analytics,
                                onChanged: (value) {
                                  setState(() {
                                    _analytics = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Appearance Card
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
                              const Icon(Icons.palette, color: Color(0xFF6366F1)),
                              const SizedBox(width: 8),
                              Text(
                                languageProvider.appearance,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 24),

                          // Appearance Settings
                          Column(
                            children: [
                              _buildDropdownSetting(
                                title: languageProvider.currentLocale.languageCode == 'en'
                                    ? 'Theme'
                                    : 'Tema',
                                description: languageProvider.currentLocale.languageCode == 'en'
                                    ? 'Choose your preferred theme'
                                    : 'Escolha seu tema preferido',
                                value: _theme,
                                items: [
                                  DropdownMenuItem(
                                    value: 'light',
                                    child: Text(languageProvider.currentLocale.languageCode == 'en'
                                        ? 'Light'
                                        : 'Claro'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'dark',
                                    child: Text(languageProvider.currentLocale.languageCode == 'en'
                                        ? 'Dark'
                                        : 'Escuro'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'auto',
                                    child: Text(languageProvider.currentLocale.languageCode == 'en'
                                        ? 'Auto'
                                        : 'Automático'),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _theme = value!;
                                  });
                                },
                              ),
                              const Divider(height: 32),
                              _buildSwitchSetting(
                                title: languageProvider.currentLocale.languageCode == 'en'
                                    ? 'Compact Mode'
                                    : 'Modo Compacto',
                                description: languageProvider.currentLocale.languageCode == 'en'
                                    ? 'Use compact layout to fit more content'
                                    : 'Usar layout compacto para mais conteúdo',
                                value: _compactMode,
                                onChanged: (value) {
                                  setState(() {
                                    _compactMode = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // System Card
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
                              const Icon(Icons.storage, color: Color(0xFF6366F1)),
                              const SizedBox(width: 8),
                              Text(
                                languageProvider.currentLocale.languageCode == 'en'
                                    ? 'System'
                                    : 'Sistema',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 24),

                          // System Settings
                          Column(
                            children: [
                              _buildSwitchSetting(
                                title: languageProvider.currentLocale.languageCode == 'en'
                                    ? 'Auto Save'
                                    : 'Salvamento Automático',
                                description: languageProvider.currentLocale.languageCode == 'en'
                                    ? 'Automatically save changes'
                                    : 'Salvar alterações automaticamente',
                                value: _autoSave,
                                onChanged: (value) {
                                  setState(() {
                                    _autoSave = value;
                                  });
                                },
                              ),
                              const Divider(height: 32),
                              _buildDropdownSetting(
                                title: languageProvider.currentLocale.languageCode == 'en'
                                    ? 'Backup Frequency'
                                    : 'Frequência de Backup',
                                description: languageProvider.currentLocale.languageCode == 'en'
                                    ? 'How often to backup your data'
                                    : 'Com que frequência fazer backup dos dados',
                                value: _backupFrequency,
                                items: [
                                  DropdownMenuItem(
                                    value: 'daily',
                                    child: Text(languageProvider.currentLocale.languageCode == 'en'
                                        ? 'Daily'
                                        : 'Diário'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'weekly',
                                    child: Text(languageProvider.currentLocale.languageCode == 'en'
                                        ? 'Weekly'
                                        : 'Semanal'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'monthly',
                                    child: Text(languageProvider.currentLocale.languageCode == 'en'
                                        ? 'Monthly'
                                        : 'Mensal'),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _backupFrequency = value!;
                                  });
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Clear Cache Button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(languageProvider.currentLocale.languageCode == 'en'
                                        ? 'Cache cleared successfully'
                                        : 'Cache limpo com sucesso'),
                                    backgroundColor: const Color(0xFF10B981),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                side: const BorderSide(color: Color(0xFF6B7280)),
                              ),
                              child: Text(
                                languageProvider.currentLocale.languageCode == 'en'
                                    ? 'Clear Cache'
                                    : 'Limpar Cache',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Data Management Card
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
                              const Icon(Icons.file_download, color: Color(0xFF6366F1)),
                              const SizedBox(width: 8),
                              Text(
                                languageProvider.currentLocale.languageCode == 'en'
                                    ? 'Data Management'
                                    : 'Gerenciamento de Dados',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 24),

                          // Data Management Actions
                          Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(languageProvider.currentLocale.languageCode == 'en'
                                            ? 'Data export started...'
                                            : 'Exportação de dados iniciada...'),
                                        backgroundColor: const Color(0xFF2563EB),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.file_download),
                                  label: Text(languageProvider.currentLocale.languageCode == 'en'
                                      ? 'Export Data'
                                      : 'Exportar Dados'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2563EB),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(languageProvider.currentLocale.languageCode == 'en'
                                            ? 'Delete Account'
                                            : 'Excluir Conta'),
                                        content: Text(languageProvider.currentLocale.languageCode == 'en'
                                            ? 'Are you sure you want to delete your account? This action cannot be undone.'
                                            : 'Tem certeza de que deseja excluir sua conta? Esta ação não pode ser desfeita.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: Text(languageProvider.cancel),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(languageProvider.currentLocale.languageCode == 'en'
                                                      ? 'Account deletion cancelled'
                                                      : 'Exclusão da conta cancelada'),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFFEF4444),
                                              foregroundColor: Colors.white,
                                            ),
                                            child: Text(languageProvider.delete),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.delete),
                                  label: Text(languageProvider.currentLocale.languageCode == 'en'
                                      ? 'Delete Account'
                                      : 'Excluir Conta'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFEF4444),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Save Settings Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(languageProvider.currentLocale.languageCode == 'en'
                                ? 'Settings saved successfully'
                                : 'Configurações salvas com sucesso'),
                            backgroundColor: const Color(0xFF10B981),
                          ),
                        );
                      },
                      icon: const Icon(Icons.settings),
                      label: Text(languageProvider.currentLocale.languageCode == 'en'
                          ? 'Save Settings'
                          : 'Salvar Configurações'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
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

  Widget _buildSwitchSetting({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF2563EB),
        ),
      ],
    );
  }

  Widget _buildDropdownSetting<T>({
    required String title,
    required String description,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
        DropdownButton<T>(
          value: value,
          onChanged: onChanged,
          items: items,
        ),
      ],
    );
  }
}