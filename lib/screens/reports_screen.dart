import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.description, color: Color(0xFF0D9488)),
            const SizedBox(width: 8),
            Expanded(
              child: const Text(
                'Relatórios',
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
            // Report Categories
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Categorias de Relatórios',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.2,
                      children: [
                        _buildReportCategoryCard(
                          title: 'Financeiro',
                          icon: Icons.attach_money,
                          color: const Color(0xFF16A34A),
                          reportCount: 8,
                        ),
                        _buildReportCategoryCard(
                          title: 'Manutenção',
                          icon: Icons.build,
                          color: const Color(0xFF2563EB),
                          reportCount: 12,
                        ),
                        _buildReportCategoryCard(
                          title: 'Consumo',
                          icon: Icons.water_drop,
                          color: const Color(0xFF9333EA),
                          reportCount: 6,
                        ),
                        _buildReportCategoryCard(
                          title: 'Ocupação',
                          icon: Icons.home,
                          color: const Color(0xFFF97316),
                          reportCount: 4,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Quick Actions
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
                              _showGenerateReportDialog(context);
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Gerar Relatório'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0D9488),
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
                              // TODO: Implement scheduled reports
                            },
                            icon: const Icon(Icons.schedule),
                            label: const Text('Agendados'),
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
            
            // Recent Reports
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Relatórios Recentes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 6,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final reports = [
                          {
                            'title': 'Relatório Mensal de Despesas',
                            'category': 'Financeiro',
                            'date': '01/12/2024',
                            'size': '2.4 MB',
                            'status': 'Concluído',
                            'color': const Color(0xFF16A34A),
                            'icon': Icons.attach_money,
                          },
                          {
                            'title': 'Histórico de Manutenções - Novembro',
                            'category': 'Manutenção',
                            'date': '30/11/2024',
                            'size': '1.8 MB',
                            'status': 'Concluído',
                            'color': const Color(0xFF2563EB),
                            'icon': Icons.build,
                          },
                          {
                            'title': 'Consumo de Água - Último Trimestre',
                            'category': 'Consumo',
                            'date': '28/11/2024',
                            'size': '950 KB',
                            'status': 'Concluído',
                            'color': const Color(0xFF9333EA),
                            'icon': Icons.water_drop,
                          },
                          {
                            'title': 'Taxa de Ocupação por Unidade',
                            'category': 'Ocupação',
                            'date': '25/11/2024',
                            'size': '1.2 MB',
                            'status': 'Processando',
                            'color': const Color(0xFFF97316),
                            'icon': Icons.home,
                          },
                          {
                            'title': 'Balanço Financeiro Anual',
                            'category': 'Financeiro',
                            'date': '20/11/2024',
                            'size': '3.1 MB',
                            'status': 'Concluído',
                            'color': const Color(0xFF16A34A),
                            'icon': Icons.attach_money,
                          },
                          {
                            'title': 'Análise de Consumo Energético',
                            'category': 'Consumo',
                            'date': '18/11/2024',
                            'size': '2.7 MB',
                            'status': 'Concluído',
                            'color': const Color(0xFF9333EA),
                            'icon': Icons.flash_on,
                          },
                        ];
                        
                        final report = reports[index];
                        return _buildReportTile(report);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Scheduled Reports
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Relatórios Agendados',
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
                        final scheduledReports = [
                          {
                            'title': 'Relatório Mensal de Despesas',
                            'frequency': 'Mensal',
                            'nextRun': '01/01/2025',
                            'lastRun': '01/12/2024',
                            'active': true,
                          },
                          {
                            'title': 'Análise Trimestral de Consumo',
                            'frequency': 'Trimestral',
                            'nextRun': '01/03/2025',
                            'lastRun': '01/12/2024',
                            'active': true,
                          },
                          {
                            'title': 'Balanço Anual',
                            'frequency': 'Anual',
                            'nextRun': '01/01/2026',
                            'lastRun': '01/01/2024',
                            'active': false,
                          },
                        ];
                        
                        final report = scheduledReports[index];
                        return _buildScheduledReportTile(report);
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

  Widget _buildReportCategoryCard({
    required String title,
    required IconData icon,
    required Color color,
    required int reportCount,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          // TODO: Navigate to category reports
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                '$reportCount relatórios',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportTile(Map<String, dynamic> report) {
    final isCompleted = report['status'] == 'Concluído';
    
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: (report['color'] as Color).withOpacity(0.1),
        child: Icon(
          report['icon'] as IconData,
          color: report['color'] as Color,
        ),
      ),
      title: Text(
        report['title'],
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${report['category']} • ${report['date']}'),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isCompleted 
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  report['status'],
                  style: TextStyle(
                    fontSize: 10,
                    color: isCompleted ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                report['size'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: isCompleted
          ? PopupMenuButton<String>(
              onSelected: (value) {
                // TODO: Implement report actions
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'download',
                  child: Row(
                    children: [
                      Icon(Icons.download),
                      SizedBox(width: 8),
                      Text('Baixar'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'share',
                  child: Row(
                    children: [
                      Icon(Icons.share),
                      SizedBox(width: 8),
                      Text('Compartilhar'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'view',
                  child: Row(
                    children: [
                      Icon(Icons.visibility),
                      SizedBox(width: 8),
                      Text('Visualizar'),
                    ],
                  ),
                ),
              ],
            )
          : const CircularProgressIndicator(strokeWidth: 2),
    );
  }

  Widget _buildScheduledReportTile(Map<String, dynamic> report) {
    final isActive = report['active'] as bool;
    
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isActive 
            ? const Color(0xFF0D9488).withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        child: Icon(
          Icons.schedule,
          color: isActive ? const Color(0xFF0D9488) : Colors.grey,
        ),
      ),
      title: Text(
        report['title'],
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Frequência: ${report['frequency']}'),
          const SizedBox(height: 4),
          Text(
            'Próxima execução: ${report['nextRun']}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      trailing: Switch(
        value: isActive,
        onChanged: (value) {
          // TODO: Toggle report schedule
        },
        activeColor: const Color(0xFF0D9488),
      ),
    );
  }

  void _showGenerateReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gerar Novo Relatório'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'financial', child: Text('Financeiro')),
                  DropdownMenuItem(value: 'maintenance', child: Text('Manutenção')),
                  DropdownMenuItem(value: 'consumption', child: Text('Consumo')),
                  DropdownMenuItem(value: 'occupancy', child: Text('Ocupação')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Tipo de Relatório',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'summary', child: Text('Resumo Executivo')),
                  DropdownMenuItem(value: 'detailed', child: Text('Detalhado')),
                  DropdownMenuItem(value: 'analytical', child: Text('Analítico')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Data Inicial',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Data Final',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Formato',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'pdf', child: Text('PDF')),
                  DropdownMenuItem(value: 'excel', child: Text('Excel')),
                  DropdownMenuItem(value: 'csv', child: Text('CSV')),
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
              // TODO: Generate report
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D9488),
              foregroundColor: Colors.white,
            ),
            child: const Text('Gerar'),
          ),
        ],
      ),
    );
  }
}