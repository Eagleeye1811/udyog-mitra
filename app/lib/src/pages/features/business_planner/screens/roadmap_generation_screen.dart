import 'package:flutter/material.dart';
import 'package:udyogmitra/src/config/themes/app_theme.dart';
import 'package:udyogmitra/src/config/themes/helpers.dart';

class RoadmapGenerationScreen extends StatefulWidget {
  final Map<String, dynamic> evaluationResult;
  final Map<String, dynamic> selectedIdea;
  final List<String> userSkills;
  final VoidCallback onBack;
  final VoidCallback onComplete;

  const RoadmapGenerationScreen({
    super.key,
    required this.evaluationResult,
    required this.selectedIdea,
    required this.userSkills,
    required this.onBack,
    required this.onComplete,
  });

  @override
  State<RoadmapGenerationScreen> createState() =>
      _RoadmapGenerationScreenState();
}

class _RoadmapGenerationScreenState extends State<RoadmapGenerationScreen> {
  Map<String, dynamic>? _roadmapData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _generateRoadmap();
  }

  void _generateRoadmap() {
    // Simulate API call to generate personalized roadmap
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _roadmapData = _getGeneratedRoadmap();
        _isLoading = false;
      });
    });
  }

  Map<String, dynamic> _getGeneratedRoadmap() {
    // This would normally come from your backend API
    return {
      'business_name': widget.selectedIdea['title'] ?? 'Your Business',
      'total_duration': '12-18 months',
      'phases': [
        {
          'phase_number': 1,
          'title': 'Foundation & Planning',
          'duration': '1-2 months',
          'status': 'upcoming',
          'tasks': [
            {
              'task': 'Market Research',
              'description':
                  'Conduct detailed market analysis and competitor research',
              'duration': '1 week',
              'priority': 'high',
              'resources': ['Market research tools', 'Industry reports'],
            },
            {
              'task': 'Business Plan Creation',
              'description':
                  'Develop comprehensive business plan with financial projections',
              'duration': '2 weeks',
              'priority': 'high',
              'resources': [
                'Business plan template',
                'Financial modeling tools',
              ],
            },
            {
              'task': 'Legal Structure Setup',
              'description':
                  'Register business entity and obtain necessary licenses',
              'duration': '1 week',
              'priority': 'medium',
              'resources': ['Legal counsel', 'Government registration portals'],
            },
            {
              'task': 'Brand Identity',
              'description':
                  'Create logo, brand guidelines, and basic marketing materials',
              'duration': '1 week',
              'priority': 'medium',
              'resources': ['Design tools', 'Brand consultant'],
            },
          ],
        },
        {
          'phase_number': 2,
          'title': 'Skill Development & Setup',
          'duration': '2-3 months',
          'status': 'upcoming',
          'tasks': [
            {
              'task': 'Skill Gap Training',
              'description':
                  'Complete courses in Business Development and Financial Planning',
              'duration': '6 weeks',
              'priority': 'high',
              'resources': ['Online courses', 'Certification programs'],
            },
            {
              'task': 'Website Development',
              'description':
                  'Build professional website with portfolio and service pages',
              'duration': '3 weeks',
              'priority': 'high',
              'resources': ['Web development tools', 'Hosting service'],
            },
            {
              'task': 'Tools & Software Setup',
              'description':
                  'Set up project management, accounting, and CRM tools',
              'duration': '1 week',
              'priority': 'medium',
              'resources': ['Software subscriptions', 'Integration tools'],
            },
            {
              'task': 'Portfolio Creation',
              'description':
                  'Develop case studies and sample work to showcase capabilities',
              'duration': '2 weeks',
              'priority': 'high',
              'resources': ['Portfolio templates', 'Sample projects'],
            },
          ],
        },
        {
          'phase_number': 3,
          'title': 'Launch & Client Acquisition',
          'duration': '3-4 months',
          'status': 'upcoming',
          'tasks': [
            {
              'task': 'Marketing Campaign',
              'description':
                  'Launch digital marketing campaigns across multiple channels',
              'duration': '4 weeks',
              'priority': 'high',
              'resources': ['Marketing budget', 'Analytics tools'],
            },
            {
              'task': 'Networking & Partnerships',
              'description':
                  'Build professional network and establish key partnerships',
              'duration': '8 weeks',
              'priority': 'high',
              'resources': ['Industry events', 'Professional associations'],
            },
            {
              'task': 'First Client Projects',
              'description':
                  'Complete initial client projects and gather testimonials',
              'duration': '6 weeks',
              'priority': 'high',
              'resources': [
                'Project management tools',
                'Quality control processes',
              ],
            },
            {
              'task': 'Pricing Strategy',
              'description':
                  'Refine pricing based on market feedback and costs',
              'duration': '1 week',
              'priority': 'medium',
              'resources': ['Competitor analysis', 'Cost calculation tools'],
            },
          ],
        },
        {
          'phase_number': 4,
          'title': 'Growth & Scaling',
          'duration': '6-9 months',
          'status': 'upcoming',
          'tasks': [
            {
              'task': 'Team Building',
              'description':
                  'Hire first employees or establish freelancer network',
              'duration': '4 weeks',
              'priority': 'medium',
              'resources': ['Recruitment platforms', 'HR processes'],
            },
            {
              'task': 'Service Expansion',
              'description':
                  'Add new services based on client feedback and market demand',
              'duration': '8 weeks',
              'priority': 'medium',
              'resources': ['Market research', 'Skill development'],
            },
            {
              'task': 'Systems Optimization',
              'description':
                  'Streamline processes and implement automation tools',
              'duration': '6 weeks',
              'priority': 'low',
              'resources': ['Automation tools', 'Process documentation'],
            },
            {
              'task': 'Financial Management',
              'description':
                  'Implement advanced financial tracking and planning systems',
              'duration': '4 weeks',
              'priority': 'medium',
              'resources': ['Accounting software', 'Financial advisor'],
            },
          ],
        },
      ],
      'milestones': [
        {
          'title': 'Business Registered',
          'target_date': '1 month',
          'description': 'All legal formalities completed',
        },
        {
          'title': 'First Client Acquired',
          'target_date': '4 months',
          'description': 'Successfully onboard first paying client',
        },
        {
          'title': 'Break-even Point',
          'target_date': '8 months',
          'description': 'Monthly revenue covers all expenses',
        },
        {
          'title': 'Team of 3',
          'target_date': '12 months',
          'description': 'Expand to small team of specialists',
        },
        {
          'title': 'Annual Revenue Target',
          'target_date': '18 months',
          'description': 'Achieve ₹12,00,000 annual revenue',
        },
      ],
      'resources': [
        {
          'category': 'Government Schemes',
          'items': [
            'Startup India Registration',
            'MUDRA Loan Application',
            'Digital India Benefits',
            'Skill India Certification',
          ],
        },
        {
          'category': 'Learning Resources',
          'items': [
            'Business Development Course - Coursera',
            'Financial Planning Certification - NISM',
            'Digital Marketing Masterclass - Udemy',
            'Project Management - PMP Certification',
          ],
        },
        {
          'category': 'Tools & Software',
          'items': [
            'Project Management - Trello/Asana',
            'Accounting - Tally/QuickBooks',
            'CRM - HubSpot/Zoho',
            'Design - Canva/Adobe Creative Suite',
          ],
        },
        {
          'category': 'Funding Options',
          'items': [
            'MUDRA Loan (up to ₹10 lakhs)',
            'Angel Investors',
            'Venture Capital',
            'Crowdfunding Platforms',
          ],
        },
      ],
      'success_metrics': [
        'Monthly recurring revenue',
        'Client acquisition cost',
        'Customer lifetime value',
        'Profit margins',
        'Customer satisfaction scores',
        'Market share growth',
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.route, color: Color(0xFF2E7D32), size: 28),
              const SizedBox(width: 8),
              const Text(
                'Your Business Roadmap',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_roadmapData != null)
            Text(
              '${_roadmapData!['business_name']} • ${_roadmapData!['total_duration']}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          const SizedBox(height: 24),

          if (_isLoading) ...[
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2E7D32).withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const SizedBox(
                            width: 60,
                            height: 60,
                            child: CircularProgressIndicator(
                              color: Color(0xFF2E7D32),
                              strokeWidth: 3,
                            ),
                          ),
                          Icon(
                            Icons.auto_awesome,
                            color: const Color(0xFF2E7D32),
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'AI is crafting your roadmap...',
                      style: context.textStyles.bodyMedium.grey(context),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Creating a personalized business roadmap with AI insights',
                      style: context.textStyles.bodySmall.darkGrey(context),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            Expanded(
              child: DefaultTabController(
                length: 4,
                child: Column(
                  children: [
                    const TabBar(
                      labelColor: Color(0xFF2E7D32),
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Color(0xFF2E7D32),
                      tabs: [
                        Tab(text: 'Phases'),
                        Tab(text: 'Milestones'),
                        Tab(text: 'Resources'),
                        Tab(text: 'Metrics'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildPhasesTab(),
                          _buildMilestonesTab(),
                          _buildResourcesTab(),
                          _buildMetricsTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // Navigation buttons
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton(
                onPressed: widget.onBack,
                child: const Text(
                  'Back to Evaluation',
                  style: TextStyle(color: Color(0xFF2E7D32)),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _roadmapData != null ? widget.onComplete : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text('Complete Planning'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhasesTab() {
    final phases = _roadmapData!['phases'] as List;
    return ListView.builder(
      itemCount: phases.length,
      itemBuilder: (context, index) {
        final phase = phases[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF2E7D32),
              child: Text(
                '${phase['phase_number']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              phase['title'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            subtitle: Text(
              'Duration: ${phase['duration']}',
              style: context.textStyles.labelSmall.darkGrey(context),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tasks :',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...(phase['tasks'] as List).map(
                      (task) => _buildTaskCard(task),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    Color priorityColor;
    switch (task['priority']) {
      case 'high':
        priorityColor = Colors.red;
        break;
      case 'medium':
        priorityColor = Colors.orange;
        break;
      default:
        priorityColor = Colors.green;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task['task'],
                    style: context.textStyles.labelMedium,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: priorityColor.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: priorityColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    task['priority'].toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      color: priorityColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              task['description'],
              style: context.textStyles.labelSmall.darkGrey(context),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.schedule, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  task['duration'],
                  style: context.textStyles.labelSmall.darkGrey(context),
                ),
                const SizedBox(width: 16),
                Icon(Icons.build, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    (task['resources'] as List).join(', '),
                    style: context.textStyles.labelSmall.darkGrey(context),
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestonesTab() {
    final milestones = _roadmapData!['milestones'] as List;
    return ListView.builder(
      itemCount: milestones.length,
      itemBuilder: (context, index) {
        final milestone = milestones[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF4CAF50),
              child: Icon(Icons.flag, color: Colors.white, size: 20),
            ),
            title: Text(
              milestone['title'],
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E7D32),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'Target: ${milestone['target_date']}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  milestone['description'],
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResourcesTab() {
    final resources = _roadmapData!['resources'] as List;
    return ListView.builder(
      itemCount: resources.length,
      itemBuilder: (context, index) {
        final resourceCategory = resources[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            title: Text(
              resourceCategory['category'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: (resourceCategory['items'] as List)
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle_outline,
                                color: Color(0xFF4CAF50),
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricsTab() {
    final metrics = _roadmapData!['success_metrics'] as List;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Key Success Metrics to Track',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 16),
            ...metrics.map(
              (metric) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.analytics,
                      color: Color(0xFF2E7D32),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        metric,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.blue.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Track these metrics monthly to ensure you\'re on the right path to success.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
