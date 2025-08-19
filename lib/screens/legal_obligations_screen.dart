import 'package:flutter/material.dart';

class LegalObligationsScreen extends StatelessWidget {
  const LegalObligationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.warning, color: Color(0xFFDC2626)),
            const SizedBox(width: 8),
            Expanded(
              child: const Text(
                'Obrigações Legais e Documentos',
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
            // Quick Stats Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Total de Obrigações',
                    value: '12',
                    color: const Color(0xFF2563EB),
                    icon: Icons.assignment,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    title: 'Pendentes',
                    value: '3',
                    color: const Color(0xFFDC2626),
                    icon: Icons.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Em Dia',
                    value: '9',
                    color: const Color(0xFF16A34A),
                    icon: Icons.check_circle,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    title: 'Vencendo em 30 dias',
                    value: '2',
                    color: const Color(0xFFF97316),
                    icon: Icons.schedule,
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
                              // TODO: Implement add obligation
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Nova Obrigação'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
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
                              // TODO: Implement template management
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
            
            // Legal Obligations List
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Obrigações Legais',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Search and Filter
                    Row(
                      children: [
                        Expanded(
                          child: const TextField(
                            decoration: InputDecoration(
                              labelText: 'Buscar obrigação...',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        DropdownButton<String>(
                          value: 'all',
                          items: const [
                            DropdownMenuItem(value: 'all', child: Text('Todas')),
                            DropdownMenuItem(value: 'pending', child: Text('Pendentes')),
                            DropdownMenuItem(value: 'completed', child: Text('Concluídas')),
                            DropdownMenuItem(value: 'overdue', child: Text('Atrasadas')),
                          ],
                          onChanged: (value) {
                            // TODO: Implement filter
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Obligations List
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 8,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final obligations = [
                          {
                            'title': 'AVCB - Auto de Vistoria do Corpo de Bombeiros',
                            'description': 'Renovação anual do certificado',
                            'dueDate': '15/12/2024',
                            'status': 'pending',
                            'priority': 'high',
                          },
                          {
                            'title': 'Alvará de Funcionamento',
                            'description': 'Renovação municipal',
                            'dueDate': '20/01/2025',
                            'status': 'pending',
                            'priority': 'medium',
                          },
                          {
                            'title': 'Laudo de Elevador',
                            'description': 'Inspeção técnica anual',
                            'dueDate': '10/02/2025',
                            'status': 'completed',
                            'priority': 'high',
                          },
                          {
                            'title': 'Certificado de Regularidade do FGTS',
                            'description': 'Comprovação junto à Caixa Econômica',
                            'dueDate': '30/03/2025',
                            'status': 'pending',
                            'priority': 'low',
                          },
                          {
                            'title': 'PPRA - Programa de Prevenção de Riscos Ambientais',
                            'description': 'Atualização anual',
                            'dueDate': '05/04/2025',
                            'status': 'completed',
                            'priority': 'medium',
                          },
                          {
                            'title': 'LTCAT - Laudo Técnico de Condições Ambientais',
                            'description': 'Avaliação das condições de trabalho',
                            'dueDate': '15/05/2025',
                            'status': 'completed',
                            'priority': 'medium',
                          },
                          {
                            'title': 'Licença Ambiental',
                            'description': 'Renovação junto ao órgão ambiental',
                            'dueDate': '25/06/2025',
                            'status': 'pending',
                            'priority': 'high',
                          },
                          {
                            'title': 'Certificado de Potabilidade da Água',
                            'description': 'Análise laboratorial semestral',
                            'dueDate': '10/07/2025',
                            'status': 'completed',
                            'priority': 'high',
                          },
                        ];
                        
                        final obligation = obligations[index];
                        return _buildObligationTile(obligation);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Upcoming Deadlines
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Próximos Vencimentos',
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
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final upcoming = [
                          {
                            'title': 'AVCB',
                            'date': '15/12/2024',
                            'days': '5',
                            'color': const Color(0xFFDC2626),
                          },
                          {
                            'title': 'Alvará de Funcionamento',
                            'date': '20/01/2025',
                            'days': '41',
                            'color': const Color(0xFFF97316),
                          },
                          {
                            'title': 'Laudo de Elevador',
                            'date': '10/02/2025',
                            'days': '62',
                            'color': const Color(0xFF2563EB),
                          },
                        ];
                        
                        final item = upcoming[index];
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: (item['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: (item['color'] as Color).withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                color: item['color'] as Color,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title'] as String,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Vence em ${item['date']}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: item['color'] as Color,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${item['days']} dias',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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

  Widget _buildObligationTile(Map<String, dynamic> obligation) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (obligation['status']) {
      case 'completed':
        statusColor = const Color(0xFF16A34A);
        statusIcon = Icons.check_circle;
        statusText = 'Concluída';
        break;
      case 'pending':
        if (obligation['priority'] == 'high') {
          statusColor = const Color(0xFFDC2626);
          statusIcon = Icons.warning;
          statusText = 'Pendente';
        } else {
          statusColor = const Color(0xFFF97316);
          statusIcon = Icons.schedule;
          statusText = 'Pendente';
        }
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
        statusText = 'Desconhecido';
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: statusColor.withOpacity(0.1),
        child: Icon(statusIcon, color: statusColor),
      ),
      title: Text(
        obligation['title'],
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(obligation['description']),
          const SizedBox(height: 4),
          Text(
            'Vencimento: ${obligation['dueDate']}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          statusText,
          style: TextStyle(
            color: statusColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onTap: () {
        // TODO: Navigate to obligation details
      },
    );
  }
}