import 'package:flutter/material.dart';
import 'package:udyogmitra/src/config/themes/app_theme.dart';
import 'package:udyogmitra/src/config/themes/helpers.dart';

class BusinessIdeasScreen extends StatefulWidget {
  final List<String> skills;
  final Function(Map<String, dynamic>) onIdeaSelected;
  final VoidCallback onBack;

  const BusinessIdeasScreen({
    super.key,
    required this.skills,
    required this.onIdeaSelected,
    required this.onBack,
  });

  @override
  State<BusinessIdeasScreen> createState() => _BusinessIdeasScreenState();
}

class _BusinessIdeasScreenState extends State<BusinessIdeasScreen> {
  List<Map<String, dynamic>> _businessIdeas = [];
  bool _isLoading = true;
  int? _selectedIdeaIndex;

  @override
  void initState() {
    super.initState();
    _generateBusinessIdeas();
  }

  void _generateBusinessIdeas() {
    // Simulate API call to generate business ideas based on skills
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _businessIdeas = _getGeneratedIdeas();
        _isLoading = false;
      });
    });
  }

  List<Map<String, dynamic>> _getGeneratedIdeas() {
    // This would normally come from your backend API
    return [
      {
        'title': 'Freelance Digital Agency',
        'description':
            'Start a digital marketing agency offering web development, graphic design, and social media management services.',
        'match_percentage': 95,
        'investment_range': 'Low (₹50,000 - ₹2,00,000)',
        'market_potential': 'High',
        'difficulty': 'Medium',
        'timeframe': '3-6 months',
        'revenue_model': 'Project-based and retainer fees',
        'key_skills_used': widget.skills
            .where(
              (skill) => [
                'Digital Marketing',
                'Web Development',
                'Graphic Design',
                'Social Media Management',
              ].any((s) => skill.toLowerCase().contains(s.toLowerCase())),
            )
            .toList(),
      },
      {
        'title': 'Online Course Platform',
        'description':
            'Create and sell online courses based on your expertise in various skills.',
        'match_percentage': 88,
        'investment_range': 'Low (₹25,000 - ₹1,00,000)',
        'market_potential': 'Very High',
        'difficulty': 'Easy',
        'timeframe': '2-4 months',
        'revenue_model': 'Course sales and subscription',
        'key_skills_used': widget.skills
            .where(
              (skill) => [
                'Teaching',
                'Content Writing',
                'Video Editing',
              ].any((s) => skill.toLowerCase().contains(s.toLowerCase())),
            )
            .toList(),
      },
      {
        'title': 'E-commerce Store',
        'description':
            'Launch an online store selling products related to your skills and interests.',
        'match_percentage': 82,
        'investment_range': 'Medium (₹1,00,000 - ₹5,00,000)',
        'market_potential': 'High',
        'difficulty': 'Medium',
        'timeframe': '4-8 months',
        'revenue_model': 'Product sales and affiliate marketing',
        'key_skills_used': widget.skills
            .where(
              (skill) => [
                'Digital Marketing',
                'Customer Service',
                'Data Analysis',
              ].any((s) => skill.toLowerCase().contains(s.toLowerCase())),
            )
            .toList(),
      },
      {
        'title': 'Consulting Business',
        'description':
            'Offer consulting services in your area of expertise to businesses and individuals.',
        'match_percentage': 90,
        'investment_range': 'Very Low (₹10,000 - ₹50,000)',
        'market_potential': 'Medium',
        'difficulty': 'Easy',
        'timeframe': '1-3 months',
        'revenue_model': 'Hourly consulting fees',
        'key_skills_used': widget.skills
            .where(
              (skill) => [
                'Consulting',
                'Project Management',
                'Data Analysis',
              ].any((s) => skill.toLowerCase().contains(s.toLowerCase())),
            )
            .toList(),
      },
    ];
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
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
              const Icon(Icons.lightbulb, color: Color(0xFF2E7D32), size: 28),
              const SizedBox(width: 8),
              const Text(
                'Business Ideas',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Based on your skills: ${widget.skills.join(', ')}',
            style: context.textStyles.bodySmall
                .grey(context)
                .copyWith(fontStyle: FontStyle.italic),
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
                      'UdyogMitra AI is analyzing your skills...',
                      style: context.textStyles.bodyMedium.grey(context),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Generating personalized business opportunities',
                      style: context.textStyles.bodySmall.darkGrey(context),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            Expanded(
              child: ListView.builder(
                itemCount: _businessIdeas.length,
                itemBuilder: (context, index) {
                  final idea = _businessIdeas[index];
                  final isSelected = _selectedIdeaIndex == index;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: isSelected ? 8 : 2,
                    color: isSelected ? const Color(0xFFF1F8E9) : null,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedIdeaIndex = index;
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    idea['title'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2E7D32),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4CAF50),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${idea['match_percentage']}% Match',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              idea['description'],
                              style: isSelected
                                  ? context.textStyles.bodySmall.black()
                                  : context.textStyles.bodySmall,
                            ),
                            const SizedBox(height: 12),

                            // Key metrics row
                            Row(
                              children: [
                                _buildMetricChip(
                                  Icons.attach_money,
                                  idea['investment_range'],
                                  Colors.blue,
                                ),
                                const SizedBox(width: 8),
                                _buildMetricChip(
                                  Icons.trending_up,
                                  idea['market_potential'],
                                  Colors.purple,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _buildMetricChip(
                                  Icons.speed,
                                  idea['difficulty'],
                                  _getDifficultyColor(idea['difficulty']),
                                ),
                                const SizedBox(width: 8),
                                _buildMetricChip(
                                  Icons.schedule,
                                  idea['timeframe'],
                                  Colors.orange,
                                ),
                              ],
                            ),

                            if (idea['key_skills_used'].isNotEmpty) ...[
                              const SizedBox(height: 12),
                              const Text(
                                'Your matching skills:',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: idea['key_skills_used'].map<Widget>((
                                  skill,
                                ) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.green.shade300,
                                      ),
                                    ),
                                    child: Text(
                                      skill,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.green.shade700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],

                            if (isSelected) ...[
                              const SizedBox(height: 12),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2E7D32),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: Text(
                                    '✓ Selected for evaluation',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
                  'Back to Skills',
                  style: TextStyle(color: Color(0xFF2E7D32)),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _selectedIdeaIndex != null
                    ? () => widget.onIdeaSelected(
                        _businessIdeas[_selectedIdeaIndex!],
                      )
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text('Evaluate This Idea'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
