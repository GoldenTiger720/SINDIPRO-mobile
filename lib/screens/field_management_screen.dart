import 'package:flutter/material.dart';

class FieldManagementScreen extends StatelessWidget {
  const FieldManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.chat_bubble_outline, color: Color(0xFF9333EA)),
            const SizedBox(width: 8),
            Expanded(
              child: const Text(
                'Gestão de Campo e Pesquisas',
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
                    title: 'Pesquisas Ativas',
                    value: '3',
                    color: const Color(0xFF2563EB),
                    icon: Icons.poll,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    title: 'Respostas',
                    value: '45',
                    color: const Color(0xFF16A34A),
                    icon: Icons.question_answer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Taxa de Resposta',
                    value: '72%',
                    color: const Color(0xFF9333EA),
                    icon: Icons.trending_up,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    title: 'Concluídas',
                    value: '8',
                    color: const Color(0xFF0D9488),
                    icon: Icons.check_circle,
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
                    const Text(
                      'Ações Rápidas',
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
                              _showCreateSurveyDialog(context);
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Nova Pesquisa'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9333EA),
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
                              // TODO: Implement survey templates
                            },
                            icon: const Icon(Icons.library_books),
                            label: const Text('Templates'),
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
            
            // Active Surveys
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pesquisas Ativas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final surveys = [
                          {
                            'title': 'Satisfação com Serviços de Limpeza',
                            'description': 'Avaliação da qualidade dos serviços de limpeza comum',
                            'responses': 15,
                            'target': 25,
                            'endDate': '25/12/2024',
                            'status': 'active',
                          },
                          {
                            'title': 'Horário de Funcionamento da Portaria',
                            'description': 'Consulta sobre possível extensão do horário',
                            'responses': 22,
                            'target': 30,
                            'endDate': '30/12/2024',
                            'status': 'active',
                          },
                          {
                            'title': 'Implementação de Sistema de Câmeras',
                            'description': 'Aprovação para instalação de novo sistema de segurança',
                            'responses': 8,
                            'target': 20,
                            'endDate': '15/01/2025',
                            'status': 'active',
                          },
                        ];
                        
                        final survey = surveys[index];
                        return _buildSurveyTile(survey);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Completed Surveys
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pesquisas Concluídas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 2,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final completedSurveys = [
                          {
                            'title': 'Renovação do Playground',
                            'description': 'Aprovação para reforma da área infantil',
                            'responses': 35,
                            'target': 30,
                            'completedDate': '10/11/2024',
                            'status': 'completed',
                            'result': 'Aprovado (78% favorável)',
                          },
                          {
                            'title': 'Mudança no Horário da Academia',
                            'description': 'Proposta de extensão do horário de funcionamento',
                            'responses': 28,
                            'target': 25,
                            'completedDate': '05/10/2024',
                            'status': 'completed',
                            'result': 'Rejeitado (45% favorável)',
                          },
                        ];
                        
                        final survey = completedSurveys[index];
                        return _buildCompletedSurveyTile(survey);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Survey Analytics
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Análise de Participação',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF9333EA).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Unidades Participantes:'),
                              Text(
                                '45 de 62 (72%)',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF9333EA),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Média de Tempo de Resposta:'),
                              Text(
                                '3.2 dias',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Satisfação Geral:'),
                              Text(
                                '4.2/5.0',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF16A34A),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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

  Widget _buildSurveyTile(Map<String, dynamic> survey) {
    final progress = (survey['responses'] as int) / (survey['target'] as int);
    
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Color(0xFF9333EA),
        child: Icon(Icons.poll, color: Colors.white),
      ),
      title: Text(
        survey['title'],
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(survey['description']),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF9333EA)),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${survey['responses']}/${survey['target']}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Encerra em: ${survey['endDate']}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          // TODO: Implement survey actions
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'view',
            child: Row(
              children: [
                Icon(Icons.visibility),
                SizedBox(width: 8),
                Text('Ver Resultados'),
              ],
            ),
          ),
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
            value: 'close',
            child: Row(
              children: [
                Icon(Icons.close),
                SizedBox(width: 8),
                Text('Encerrar'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedSurveyTile(Map<String, dynamic> survey) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Color(0xFF0D9488),
        child: Icon(Icons.check_circle, color: Colors.white),
      ),
      title: Text(
        survey['title'],
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(survey['description']),
          const SizedBox(height: 4),
          Text(
            'Resultado: ${survey['result']}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D9488),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Concluída em: ${survey['completedDate']} (${survey['responses']} respostas)',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.bar_chart),
        onPressed: () {
          // TODO: Show detailed analytics
        },
      ),
    );
  }

  void _showCreateSurveyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova Pesquisa'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Título da Pesquisa',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Data de Encerramento',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Tipo de Pesquisa',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'multiple', child: Text('Múltipla Escolha')),
                  DropdownMenuItem(value: 'rating', child: Text('Avaliação (1-5)')),
                  DropdownMenuItem(value: 'text', child: Text('Texto Livre')),
                  DropdownMenuItem(value: 'yesno', child: Text('Sim/Não')),
                ],
                onChanged: (value) {},
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
              // TODO: Implement survey creation
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9333EA),
              foregroundColor: Colors.white,
            ),
            child: const Text('Criar Pesquisa'),
          ),
        ],
      ),
    );
  }
}