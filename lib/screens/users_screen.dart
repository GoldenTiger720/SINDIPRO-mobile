import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.people, color: Color(0xFFDB2777)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                languageProvider.userManagement,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: languageProvider.totalUsers,
                    value: '24',
                    color: const Color(0xFF2563EB),
                    icon: Icons.people,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    title: languageProvider.administrators,
                    value: '3',
                    color: const Color(0xFFDB2777),
                    icon: Icons.admin_panel_settings,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: languageProvider.activeUsers,
                    value: '22',
                    color: const Color(0xFF16A34A),
                    icon: Icons.check_circle,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    title: languageProvider.inactiveUsers,
                    value: '2',
                    color: const Color(0xFF6B7280),
                    icon: Icons.block,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Action Buttons
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      languageProvider.quickActions,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _showAddUserDialog(context, languageProvider);
                            },
                            icon: const Icon(Icons.person_add),
                            label: Text(languageProvider.newUser),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFDB2777),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // TODO: Implement user permissions
                            },
                            icon: const Icon(Icons.security),
                            label: const Text('Permissões'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Users List
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          languageProvider.userList,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            // TODO: Implement sorting and filtering
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'sort_name',
                              child: Row(
                                children: [
                                  Icon(Icons.sort_by_alpha),
                                  SizedBox(width: 8),
                                  Text('Ordenar por Nome'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'sort_role',
                              child: Row(
                                children: [
                                  Icon(Icons.sort),
                                  SizedBox(width: 8),
                                  Text('Ordenar por Função'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'filter_active',
                              child: Row(
                                children: [
                                  Icon(Icons.filter_list),
                                  SizedBox(width: 8),
                                  Text('Filtrar Ativos'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Search bar
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Buscar usuário...',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Users List
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 10,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final users = [
                          {
                            'name': 'João Silva',
                            'email': 'joao.silva@sindipro.com',
                            'role': 'Administrador',
                            'building': 'Todas',
                            'lastLogin': '2 horas atrás',
                            'status': 'active',
                            'avatar': 'J',
                          },
                          {
                            'name': 'Maria Santos',
                            'email': 'maria.santos@sindipro.com',
                            'role': 'Administrador',
                            'building': 'Todas',
                            'lastLogin': '1 dia atrás',
                            'status': 'active',
                            'avatar': 'M',
                          },
                          {
                            'name': 'Carlos Oliveira',
                            'email': 'carlos.oliveira@edifício1.com',
                            'role': 'Zelador',
                            'building': 'Edifício Residencial Alpha',
                            'lastLogin': '3 horas atrás',
                            'status': 'active',
                            'avatar': 'C',
                          },
                          {
                            'name': 'Ana Costa',
                            'email': 'ana.costa@edifício2.com',
                            'role': 'Zelador',
                            'building': 'Condomínio Beta',
                            'lastLogin': '5 horas atrás',
                            'status': 'active',
                            'avatar': 'A',
                          },
                          {
                            'name': 'Pedro Ferreira',
                            'email': 'pedro.ferreira@edifício3.com',
                            'role': 'Zelador',
                            'building': 'Residencial Gamma',
                            'lastLogin': '2 dias atrás',
                            'status': 'inactive',
                            'avatar': 'P',
                          },
                          {
                            'name': 'Lucia Mendes',
                            'email': 'lucia.mendes@sindipro.com',
                            'role': 'Administrador',
                            'building': 'Todas',
                            'lastLogin': '6 horas atrás',
                            'status': 'active',
                            'avatar': 'L',
                          },
                          {
                            'name': 'Roberto Lima',
                            'email': 'roberto.lima@edifício4.com',
                            'role': 'Zelador',
                            'building': 'Torres Delta',
                            'lastLogin': '1 hora atrás',
                            'status': 'active',
                            'avatar': 'R',
                          },
                          {
                            'name': 'Fernanda Rocha',
                            'email': 'fernanda.rocha@edifício5.com',
                            'role': 'Zelador',
                            'building': 'Condomínio Epsilon',
                            'lastLogin': '4 horas atrás',
                            'status': 'active',
                            'avatar': 'F',
                          },
                          {
                            'name': 'Marcos Pereira',
                            'email': 'marcos.pereira@edifício6.com',
                            'role': 'Zelador',
                            'building': 'Residencial Zeta',
                            'lastLogin': '1 semana atrás',
                            'status': 'inactive',
                            'avatar': 'M',
                          },
                          {
                            'name': 'Sandra Alves',
                            'email': 'sandra.alves@edifício7.com',
                            'role': 'Zelador',
                            'building': 'Condomínio Eta',
                            'lastLogin': '8 horas atrás',
                            'status': 'active',
                            'avatar': 'S',
                          },
                        ];
                        
                        final user = users[index];
                        return _buildUserTile(user);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // User Roles Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Funções e Permissões',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildRoleCard(
                      title: 'Administrador',
                      description: 'Acesso total ao sistema, pode gerenciar todos os condomínios',
                      permissions: [
                        'Visualizar todos os relatórios',
                        'Gerenciar usuários',
                        'Configurar sistema',
                        'Aprovar despesas',
                      ],
                      color: const Color(0xFFDB2777),
                      icon: Icons.admin_panel_settings,
                    ),
                    const SizedBox(height: 16),
                    _buildRoleCard(
                      title: 'Zelador',
                      description: 'Acesso limitado ao condomínio específico',
                      permissions: [
                        'Registrar leituras de consumo',
                        'Reportar problemas de equipamentos',
                        'Visualizar cronograma de manutenção',
                        'Acessar lista de fornecedores',
                      ],
                      color: const Color(0xFF2563EB),
                      icon: Icons.engineering,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
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
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTile(Map<String, dynamic> user) {
    final isActive = user['status'] == 'active';
    final isAdmin = user['role'] == 'Administrador';
    
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isAdmin 
            ? const Color(0xFFDB2777) 
            : const Color(0xFF2563EB),
        child: Text(
          user['avatar'],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        user['name'],
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(user['email']),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isAdmin
                      ? const Color(0xFFDB2777).withOpacity(0.1)
                      : const Color(0xFF2563EB).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  user['role'],
                  style: TextStyle(
                    fontSize: 10,
                    color: isAdmin ? const Color(0xFFDB2777) : const Color(0xFF2563EB),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.green.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isActive ? 'Ativo' : 'Inativo',
                  style: TextStyle(
                    fontSize: 10,
                    color: isActive ? Colors.green : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Último login: ${user['lastLogin']}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          // TODO: Implement user actions
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit),
                SizedBox(width: 8),
                Text('Editar'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'permissions',
            child: Row(
              children: [
                Icon(Icons.security),
                SizedBox(width: 8),
                Text('Permissões'),
              ],
            ),
          ),
          PopupMenuItem(
            value: isActive ? 'deactivate' : 'activate',
            child: Row(
              children: [
                Icon(isActive ? Icons.block : Icons.check_circle),
                const SizedBox(width: 8),
                Text(isActive ? 'Desativar' : 'Ativar'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete, color: Colors.red),
                SizedBox(width: 8),
                Text('Excluir', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String description,
    required List<String> permissions,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Permissões:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...permissions.map((permission) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Icon(
                  Icons.check,
                  size: 16,
                  color: color,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    permission,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  void _showAddUserDialog(BuildContext context, LanguageProvider languageProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Novo Usuário'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Nome Completo',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Função',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'admin', child: Text('Administrador')),
                  DropdownMenuItem(value: 'caretaker', child: Text('Zelador')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Condomínio',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('Todos')),
                  DropdownMenuItem(value: 'alpha', child: Text('Edifício Alpha')),
                  DropdownMenuItem(value: 'beta', child: Text('Condomínio Beta')),
                  DropdownMenuItem(value: 'gamma', child: Text('Residencial Gamma')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Senha Temporária',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Create user
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDB2777),
              foregroundColor: Colors.white,
            ),
            child: const Text('Criar Usuário'),
          ),
        ],
      ),
    );
  }
}