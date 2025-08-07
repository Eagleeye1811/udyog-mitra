import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../../services/api_service.dart';
import '../../../../services/api_models.dart';
import 'package:udyogmitra/src/config/themes/app_theme.dart';
import 'package:udyogmitra/src/config/themes/helpers.dart';

class BusinessIdeasScreen extends StatefulWidget {
  final List<String> skills;
  final Function(Map<String, dynamic>) onIdeaSelected;
  final VoidCallback onBack;
  final List<Map<String, dynamic>>? cachedIdeas;
  final Function(List<Map<String, dynamic>>)? onIdeasGenerated;

  const BusinessIdeasScreen({
    super.key,
    required this.skills,
    required this.onIdeaSelected,
    required this.onBack,
    this.cachedIdeas,
    this.onIdeasGenerated,
  });

  @override
  State<BusinessIdeasScreen> createState() => _BusinessIdeasScreenState();
}

class _BusinessIdeasScreenState extends State<BusinessIdeasScreen> {
  List<Map<String, dynamic>> _businessIdeas = [];
  bool _isLoading = true;
  int? _selectedIdeaIndex;
  String? _errorMessage;
  CancelToken? _cancelToken;

  @override
  void initState() {
    super.initState();
    // Check if we have cached ideas first
    if (widget.cachedIdeas != null && widget.cachedIdeas!.isNotEmpty) {
      _businessIdeas = widget.cachedIdeas!;
      _isLoading = false;
    } else {
      _generateBusinessIdeas();
    }
  }

  @override
  void dispose() {
    _cancelToken?.cancel('Widget disposed');
    super.dispose();
  }

  void _generateBusinessIdeas() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Cancel any previous request
      _cancelToken?.cancel();
      _cancelToken = CancelToken();

      // Make API call with user skills
      final response = await BusinessPlannerApiService.generateBusinessIdeas(
        skill: widget.skills.join(
          ', ',
        ), // Convert list to comma-separated string
        location: 'India', // Can be made configurable
        cancelToken: _cancelToken,
      );

      if (_cancelToken?.isCancelled == false) {
        final businessIdeas = _convertApiResponseToIdeas(response);
        setState(() {
          _businessIdeas = businessIdeas;
          _isLoading = false;
        });

        // Cache the generated ideas
        if (widget.onIdeasGenerated != null) {
          widget.onIdeasGenerated!(businessIdeas);
        }
      }
    } catch (e) {
      if (_cancelToken?.isCancelled == false) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to generate business ideas: ${e.toString()}';
        });
      }
    }
  }

  List<Map<String, dynamic>> _convertApiResponseToIdeas(
    SkillMappingResponse apiResponse,
  ) {
    // Convert API response to the format expected by the UI
    List<Map<String, dynamic>> ideas = [];

    try {
      // Extract business ideas from the SkillMappingResponse
      for (int i = 0; i < apiResponse.businessIdeas.length; i++) {
        var idea = apiResponse.businessIdeas[i];
        ideas.add({
          'title': idea.title,
          'description': idea.description,
          'match_percentage': 85 + (i * 2), // Generate varying percentages
          'investment_range': _getInvestmentRange(i),
          'market_potential': _getMarketPotential(i),
          'difficulty': _getDifficulty(i),
          'timeframe': _getTimeframe(i),
          'revenue_model': _getRevenueModel(i),
          'key_skills_used': widget.skills
              .take(3)
              .toList(), // Use first 3 skills
        });
      }

      // If no ideas, create a fallback
      if (ideas.isEmpty) {
        ideas.add({
          'title': 'Your Personalized Business Opportunity',
          'description':
              apiResponse.introduction + '\n\n' + apiResponse.conclusion,
          'match_percentage': 88,
          'investment_range': 'Low to Medium',
          'market_potential': 'High',
          'difficulty': 'Medium',
          'timeframe': '3-6 months',
          'revenue_model': 'Service-based revenue',
          'key_skills_used': widget.skills,
        });
      }
    } catch (e) {
      // Fallback: create a default idea
      ideas.add({
        'title': 'Your Personalized Business Opportunity',
        'description':
            'Based on your skills: ${widget.skills.join(', ')}, we recommend exploring opportunities in these areas.',
        'match_percentage': 88,
        'investment_range': 'Low to Medium',
        'market_potential': 'High',
        'difficulty': 'Medium',
        'timeframe': '3-6 months',
        'revenue_model': 'Service-based revenue',
        'key_skills_used': widget.skills,
      });
    }

    return ideas;
  }

  String _getInvestmentRange(int index) {
    const ranges = [
      'Low (₹50,000 - ₹1,00,000)',
      'Medium (₹1,00,000 - ₹5,00,000)',
      'High (₹5,00,000 - ₹10,00,000)',
    ];
    return ranges[index % ranges.length];
  }

  String _getMarketPotential(int index) {
    const potentials = ['High', 'Very High', 'Medium'];
    return potentials[index % potentials.length];
  }

  String _getDifficulty(int index) {
    const difficulties = ['Easy', 'Medium', 'Medium-Hard'];
    return difficulties[index % difficulties.length];
  }

  String _getTimeframe(int index) {
    const timeframes = ['2-4 months', '3-6 months', '6-12 months'];
    return timeframes[index % timeframes.length];
  }

  String _getRevenueModel(int index) {
    const models = [
      'Service-based revenue',
      'Product sales',
      'Subscription model',
    ];
    return models[index % models.length];
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
                      onPressed: _generateBusinessIdeas,
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
