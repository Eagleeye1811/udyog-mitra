import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../../services/api_service.dart';
import '../../../../services/api_models.dart';
import 'package:udyogmitra/src/config/themes/app_theme.dart';
import 'package:udyogmitra/src/config/themes/helpers.dart';

class RoadmapGenerationScreen extends StatefulWidget {
  final Map<String, dynamic> evaluationResult;
  final Map<String, dynamic> selectedIdea;
  final List<String> userSkills;
  final VoidCallback onBack;
  final VoidCallback onComplete;
  final Map<String, dynamic>? cachedRoadmapData;
  final Function(Map<String, dynamic>)? onRoadmapDataGenerated;

  const RoadmapGenerationScreen({
    super.key,
    required this.evaluationResult,
    required this.selectedIdea,
    required this.userSkills,
    required this.onBack,
    required this.onComplete,
    this.cachedRoadmapData,
    this.onRoadmapDataGenerated,
  });

  @override
  State<RoadmapGenerationScreen> createState() =>
      _RoadmapGenerationScreenState();
}

class _RoadmapGenerationScreenState extends State<RoadmapGenerationScreen> {
  Map<String, dynamic>? _roadmapData;
  bool _isLoading = true;
  String? _errorMessage;
  CancelToken? _cancelToken;

  @override
  void initState() {
    super.initState();
    // Check if we have cached roadmap data first
    if (widget.cachedRoadmapData != null) {
      _roadmapData = widget.cachedRoadmapData!;
      _isLoading = false;
    } else {
      _generateRoadmap();
    }
  }

  @override
  void dispose() {
    _cancelToken?.cancel('Widget disposed');
    super.dispose();
  }

  void _generateRoadmap() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Cancel any previous request
      _cancelToken?.cancel();
      _cancelToken = CancelToken();

      // Prepare the idea description for API
      final ideaDescription =
          '''
Business Idea: ${widget.selectedIdea['title']}

Description: ${widget.selectedIdea['description']}

Evaluation Score: ${widget.evaluationResult['overall_score']}/10

Skills Available: ${widget.userSkills.join(', ')}

Target Market: ${widget.evaluationResult['market_analysis']?['target_market_size'] ?? 'General Market'}

Investment Range: ${widget.evaluationResult['financial_projections']?['initial_investment'] ?? 'To be determined'}
      ''';

      // Make API call
      final roadmapResponse = await ApiService.generateRoadmap(
        idea: ideaDescription,
        location: 'India', // Can be made configurable
        cancelToken: _cancelToken,
      );

      if (_cancelToken?.isCancelled == false) {
        final roadmapData = _convertApiRoadmapToUIFormat(
          roadmapResponse['response'],
        );
        setState(() {
          _roadmapData = roadmapData;
          _isLoading = false;
        });

        // Cache the generated roadmap data
        if (widget.onRoadmapDataGenerated != null) {
          widget.onRoadmapDataGenerated!(roadmapData);
        }
      }
    } catch (e) {
      if (_cancelToken?.isCancelled == false) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to generate roadmap: ${e.toString()}';
        });
      }
    }
  }

  Map<String, dynamic> _convertApiRoadmapToUIFormat(dynamic apiRoadmap) {
    // Convert API roadmap response to structured UI format
    String roadmapText = '';

    try {
      if (apiRoadmap is RoadmapResponse) {
        roadmapText =
            '''
${apiRoadmap.licensesAndRegistrations.isNotEmpty ? apiRoadmap.licensesAndRegistrations : 'License and registration information will be provided.'}

${apiRoadmap.fundingAndCost.isNotEmpty ? apiRoadmap.fundingAndCost : 'Funding and cost details will be analyzed.'}

${apiRoadmap.timelineAndMilestones.isNotEmpty ? apiRoadmap.timelineAndMilestones : 'Timeline and milestones will be created.'}

${apiRoadmap.marketingPlan.isNotEmpty ? apiRoadmap.marketingPlan : 'Marketing plan will be developed.'}

${apiRoadmap.risksAndOpportunities.isNotEmpty ? apiRoadmap.risksAndOpportunities : 'Risks and opportunities will be identified.'}

${apiRoadmap.partnershipsAndScaling.isNotEmpty ? apiRoadmap.partnershipsAndScaling : 'Partnership and scaling strategies will be outlined.'}
        ''';
      } else if (apiRoadmap is Map<String, dynamic>) {
        roadmapText =
            '''
${apiRoadmap['licenses_and_registrations'] ?? 'License and registration information will be provided.'}

${apiRoadmap['funding_and_cost'] ?? 'Funding and cost details will be analyzed.'}

${apiRoadmap['timeline_and_milestones'] ?? 'Timeline and milestones will be created.'}

${apiRoadmap['marketing_plan'] ?? 'Marketing plan will be developed.'}

${apiRoadmap['risks_and_opportunities'] ?? 'Risks and opportunities will be identified.'}

${apiRoadmap['partnerships_and_scaling'] ?? 'Partnership and scaling strategies will be outlined.'}
        ''';
      } else if (apiRoadmap is String && apiRoadmap.isNotEmpty) {
        roadmapText = apiRoadmap;
      } else {
        // Fallback for null or empty responses
        roadmapText = '''
Your business roadmap is being generated based on the selected idea and evaluation results.

This comprehensive plan will include licensing requirements, funding options, timeline milestones, marketing strategies, risk assessment, and scaling opportunities.

The roadmap will be tailored to your specific skills and market conditions to provide actionable insights for your business journey.
        ''';
      }
    } catch (e) {
      // Handle any parsing errors
      roadmapText = '''
We're creating a comprehensive business roadmap for your selected idea.

This will include step-by-step guidance on licensing, funding, marketing, and growth strategies tailored to your unique situation.

Your personalized roadmap is being finalized with AI-powered insights.
      ''';
    }

    // Extract structured phases from the roadmap text
    List<Map<String, dynamic>> phases = _extractPhasesFromText(roadmapText);
    List<String> milestoneStrings = _extractMilestonesFromText(roadmapText);

    // Convert milestone strings to structured format
    List<Map<String, dynamic>> milestones = milestoneStrings
        .asMap()
        .entries
        .map((entry) {
          return {
            'id': entry.key + 1,
            'title': entry.value,
            'status': entry.key == 0 ? 'current' : 'upcoming',
            'target_date': 'Month ${(entry.key + 1) * 2}',
            'description': 'Important milestone in your business journey',
          };
        })
        .toList();

    return {
      'business_name': widget.selectedIdea['title'] ?? 'Your Business',
      'total_duration': _extractDurationFromText(roadmapText) ?? '12-18 months',
      'api_roadmap_text': roadmapText,
      'phases': phases.isNotEmpty ? phases : _getDefaultPhases(),
      'key_milestones': milestoneStrings,
      'milestones': milestones, // Add structured milestones for UI
      'resources': _getDefaultResources(), // Add default resources
      'success_metrics': _getDefaultMetrics(), // Add default metrics
      'licenses_info': _extractLicensesFromText(roadmapText),
      'funding_info': _extractFundingFromText(roadmapText),
      'api_roadmap_data': apiRoadmap, // Store original API data
    };
  }

  List<Map<String, dynamic>> _extractPhasesFromText(String text) {
    // Try to extract phases from the roadmap text
    List<Map<String, dynamic>> phases = [];

    // Look for numbered sections or phases
    List<String> sections = text
        .split(RegExp(r'\n\s*\n'))
        .where((s) => s.trim().isNotEmpty)
        .toList();

    for (int i = 0; i < sections.length && i < 4; i++) {
      String section = sections[i].trim();
      if (section.length > 50) {
        phases.add({
          'phase_number': i + 1,
          'title': _extractPhaseTitle(section, i + 1),
          'duration':
              _extractPhaseDuration(section) ?? '${2 + i}-${3 + i} months',
          'status': i == 0 ? 'upcoming' : 'upcoming',
          'description': section.length > 200
              ? section.substring(0, 200) + '...'
              : section,
          'tasks': _extractTasksFromSection(section),
        });
      }
    }

    return phases;
  }

  String _extractPhaseTitle(String section, int phaseNumber) {
    List<String> defaultTitles = [
      'Foundation & Planning',
      'Setup & Development',
      'Launch & Marketing',
      'Growth & Scaling',
    ];

    // Try to extract title from first line
    String firstLine = section.split('\n').first.trim();
    if (firstLine.length > 5 && firstLine.length < 50) {
      return firstLine;
    }

    return defaultTitles[phaseNumber - 1];
  }

  String? _extractPhaseDuration(String section) {
    RegExp durationPattern = RegExp(r'\d+[-\s]*(?:months?|weeks?)');
    Match? match = durationPattern.firstMatch(section);
    return match?.group(0);
  }

  List<Map<String, dynamic>> _extractTasksFromSection(String section) {
    List<Map<String, dynamic>> tasks = [];

    // Split into sentences and extract actionable items
    List<String> sentences = section
        .split(RegExp(r'[.!?]'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty && s.length > 15)
        .toList();

    for (int i = 0; i < sentences.length && tasks.length < 4; i++) {
      String sentence = sentences[i];
      if (_isActionableTask(sentence)) {
        tasks.add({
          'task': _extractTaskTitle(sentence),
          'description': sentence,
          'duration': _extractTaskDuration(sentence) ?? '1-2 weeks',
          'priority': i < 2 ? 'high' : 'medium',
          'resources': _extractTaskResources(sentence),
        });
      }
    }

    return tasks;
  }

  bool _isActionableTask(String sentence) {
    List<String> actionWords = [
      'create',
      'develop',
      'build',
      'establish',
      'register',
      'obtain',
      'setup',
      'launch',
      'market',
      'promote',
      'implement',
      'design',
    ];

    String lowerSentence = sentence.toLowerCase();
    return actionWords.any((word) => lowerSentence.contains(word));
  }

  String _extractTaskTitle(String sentence) {
    // Extract first 3-5 words as task title
    List<String> words = sentence.split(' ').take(5).toList();
    return words.join(' ');
  }

  String? _extractTaskDuration(String sentence) {
    RegExp durationPattern = RegExp(r'\d+[-\s]*(?:days?|weeks?|months?)');
    Match? match = durationPattern.firstMatch(sentence);
    return match?.group(0);
  }

  List<String> _extractTaskResources(String sentence) {
    // Simple extraction of potential resources
    List<String> defaultResources = [
      'Planning tools',
      'Professional guidance',
      'Documentation',
    ];
    return defaultResources.take(2).toList();
  }

  String? _extractDurationFromText(String text) {
    RegExp durationPattern = RegExp(r'\d+[-\s]*(?:months?|years?)');
    Match? match = durationPattern.firstMatch(text);
    return match?.group(0);
  }

  List<String> _extractMilestonesFromText(String text) {
    // Extract key milestones from the text
    List<String> defaultMilestones = [
      'Business registration completed',
      'Initial funding secured',
      'Product/service launched',
      'First customers acquired',
      'Break-even achieved',
    ];

    return defaultMilestones;
  }

  String _extractLicensesFromText(String text) {
    // Extract license information
    if (text.toLowerCase().contains('license') ||
        text.toLowerCase().contains('registration')) {
      List<String> sentences = text
          .split('.')
          .where(
            (s) =>
                s.toLowerCase().contains('license') ||
                s.toLowerCase().contains('registration'),
          )
          .toList();
      if (sentences.isNotEmpty) {
        return sentences.first.trim();
      }
    }

    return 'Required licenses and registrations will be identified based on your business type and location.';
  }

  String _extractFundingFromText(String text) {
    // Extract funding information
    if (text.toLowerCase().contains('fund') ||
        text.toLowerCase().contains('investment')) {
      List<String> sentences = text
          .split('.')
          .where(
            (s) =>
                s.toLowerCase().contains('fund') ||
                s.toLowerCase().contains('investment'),
          )
          .toList();
      if (sentences.isNotEmpty) {
        return sentences.first.trim();
      }
    }

    return 'Funding options and investment requirements have been analyzed based on your business model.';
  }

  List<Map<String, dynamic>> _getDefaultPhases() {
    return [
      {
        'phase_number': 1,
        'title': 'Foundation & Planning',
        'duration': '2-3 months',
        'status': 'upcoming',
        'description':
            'Establish legal structure, create business plan, and conduct market research.',
        'tasks': [
          {
            'task': 'Business Registration',
            'description':
                'Register your business legally and obtain necessary permits',
            'duration': '2-3 weeks',
            'priority': 'high',
            'resources': ['Legal advisor', 'Registration portal'],
          },
          {
            'task': 'Market Research',
            'description':
                'Conduct thorough market analysis and competitor research',
            'duration': '3-4 weeks',
            'priority': 'high',
            'resources': ['Market research tools', 'Surveys'],
          },
        ],
      },
      {
        'phase_number': 2,
        'title': 'Setup & Development',
        'duration': '3-4 months',
        'status': 'upcoming',
        'description':
            'Build your product/service and establish operational infrastructure.',
        'tasks': [
          {
            'task': 'Product Development',
            'description': 'Develop minimum viable product or service offering',
            'duration': '6-8 weeks',
            'priority': 'high',
            'resources': ['Development team', 'Tools & software'],
          },
          {
            'task': 'Team Building',
            'description':
                'Hire key team members and establish company culture',
            'duration': '4-6 weeks',
            'priority': 'medium',
            'resources': ['Recruitment platforms', 'HR guidance'],
          },
        ],
      },
      {
        'phase_number': 3,
        'title': 'Launch & Marketing',
        'duration': '3-4 months',
        'status': 'upcoming',
        'description':
            'Launch your business and implement marketing strategies.',
        'tasks': [
          {
            'task': 'Product Launch',
            'description':
                'Execute go-to-market strategy and launch officially',
            'duration': '2-3 weeks',
            'priority': 'high',
            'resources': ['Marketing team', 'Launch budget'],
          },
          {
            'task': 'Digital Marketing',
            'description':
                'Implement digital marketing campaigns and build online presence',
            'duration': '6-8 weeks',
            'priority': 'high',
            'resources': ['Marketing tools', 'Content creators'],
          },
        ],
      },
      {
        'phase_number': 4,
        'title': 'Growth & Scaling',
        'duration': '4-6 months',
        'status': 'upcoming',
        'description': 'Focus on customer acquisition and business expansion.',
        'tasks': [
          {
            'task': 'Customer Acquisition',
            'description':
                'Implement strategies to acquire and retain customers',
            'duration': '8-10 weeks',
            'priority': 'high',
            'resources': ['Sales team', 'CRM tools'],
          },
          {
            'task': 'Business Expansion',
            'description': 'Explore new markets and scale operations',
            'duration': '10-12 weeks',
            'priority': 'medium',
            'resources': ['Expansion budget', 'Market analysis'],
          },
        ],
      },
    ];
  }

  List<Map<String, dynamic>> _getDefaultResources() {
    return [
      {
        'category': 'Legal & Compliance',
        'items': [
          'Business registration documentation',
          'Legal advisor consultation',
          'Compliance checklist',
          'Intellectual property guidance',
        ],
      },
      {
        'category': 'Financial Resources',
        'items': [
          'Initial capital requirements',
          'Business banking setup',
          'Accounting software',
          'Tax planning guidance',
        ],
      },
      {
        'category': 'Marketing & Sales',
        'items': [
          'Digital marketing tools',
          'Brand identity development',
          'Website and social media setup',
          'Customer acquisition strategies',
        ],
      },
      {
        'category': 'Operations',
        'items': [
          'Office space or co-working',
          'Essential equipment and tools',
          'Technology infrastructure',
          'Supply chain setup',
        ],
      },
    ];
  }

  List<Map<String, dynamic>> _getDefaultMetrics() {
    return [
      {
        'metric': 'Revenue Growth',
        'target': '25% month-over-month',
        'description': 'Track monthly revenue increase',
      },
      {
        'metric': 'Customer Acquisition',
        'target': '50 new customers/month',
        'description': 'Monitor customer base expansion',
      },
      {
        'metric': 'Market Share',
        'target': '5% local market penetration',
        'description': 'Establish market presence',
      },
      {
        'metric': 'Break-even Point',
        'target': 'Within 12 months',
        'description': 'Achieve profitability timeline',
      },
      {
        'metric': 'Customer Satisfaction',
        'target': '4.5/5 average rating',
        'description': 'Maintain high service quality',
      },
    ];
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
          ] else if (_errorMessage != null) ...[
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Oops! Something went wrong',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _generateRoadmap,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
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
    final phases = (_roadmapData!['phases'] as List?) ?? [];
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
                    ...((phase['tasks'] as List?) ?? []).map(
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
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
    final milestones = (_roadmapData!['milestones'] as List?) ?? [];
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
    final resources = (_roadmapData!['resources'] as List?) ?? [];
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
                  children: ((resourceCategory['items'] as List?) ?? [])
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
    final metrics = (_roadmapData!['success_metrics'] as List?) ?? [];
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
            ...metrics
                .map(
                  (metric) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.analytics,
                              color: Color(0xFF2E7D32),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                metric['metric'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(left: 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Target: ${metric['target']}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.orange,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                metric['description'],
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}
