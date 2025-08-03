import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:udyogmitra/src/config/themes/app_theme.dart';
import 'package:udyogmitra/src/config/themes/helpers.dart';
import '../../../../services/api_service.dart';
import '../../../../services/api_models.dart';

class IdeaEvaluationScreen extends StatefulWidget {
  final Map<String, dynamic> selectedIdea;
  final List<String> userSkills;
  final Function(Map<String, dynamic>) onEvaluationComplete;
  final VoidCallback onBack;

  const IdeaEvaluationScreen({
    super.key,
    required this.selectedIdea,
    required this.userSkills,
    required this.onEvaluationComplete,
    required this.onBack,
  });

  @override
  State<IdeaEvaluationScreen> createState() => _IdeaEvaluationScreenState();
}

class _IdeaEvaluationScreenState extends State<IdeaEvaluationScreen> {
  Map<String, dynamic>? _evaluationResult;
  bool _isLoading = true;
  String? _errorMessage;
  CancelToken? _cancelToken;

  @override
  void initState() {
    super.initState();
    _generateEvaluation();
  }

  @override
  void dispose() {
    _cancelToken?.cancel('Widget disposed');
    super.dispose();
  }

  void _generateEvaluation() async {
    // Check if we already have API evaluation data (from standalone flow)
    if (widget.selectedIdea.containsKey('api_evaluation')) {
      setState(() {
        _evaluationResult = _convertApiEvaluationToUIFormat(
          widget.selectedIdea['api_evaluation'],
        );
        _isLoading = false;
      });
    } else {
      // For business planner flow, make actual API call
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

Skills Available: ${widget.userSkills.join(', ')}
        ''';

        // Make API call
        final evaluationResponse = await ApiService.validateIdea(
          idea: ideaDescription,
          location: 'India', // Can be made configurable
          cancelToken: _cancelToken,
        );

        if (_cancelToken?.isCancelled == false) {
          setState(() {
            _evaluationResult = _convertApiEvaluationToUIFormat(
              evaluationResponse['response'],
            );
            _isLoading = false;
          });
        }
      } catch (e) {
        if (_cancelToken?.isCancelled == false) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Failed to evaluate idea: ${e.toString()}';
          });
        }
      }
    }
  }

  Map<String, dynamic> _convertApiEvaluationToUIFormat(dynamic apiEvaluation) {
    // Convert the API evaluation response to the format expected by the UI
    // Handle both IdeaEvaluationResponse object and raw API response

    String summary = '';
    String marketDemand = '';
    String? suggestions;
    String? challenges;
    String? govSchemes;
    String? competitors;
    String? investmentPotential;
    String? growthOpportunities;
    String score = '7.5';

    if (apiEvaluation is IdeaEvaluationResponse) {
      summary = apiEvaluation.summary;
      marketDemand = apiEvaluation.marketDemand;
      suggestions = apiEvaluation.suggestions;
      challenges = apiEvaluation.challenges;
      govSchemes = apiEvaluation.govSchemes;
      competitors = apiEvaluation.competitors;
      investmentPotential = apiEvaluation.investmentPotential;
      growthOpportunities = apiEvaluation.growthOpportunities;
      score = apiEvaluation.score;
    } else if (apiEvaluation is Map<String, dynamic>) {
      summary = apiEvaluation['summary'] ?? '';
      marketDemand = apiEvaluation['market_demand'] ?? '';
      suggestions = apiEvaluation['suggestions'];
      challenges = apiEvaluation['challenges'];
      govSchemes = apiEvaluation['gov_schemes'];
      competitors = apiEvaluation['competitors'];
      investmentPotential = apiEvaluation['investment_potential'];
      growthOpportunities = apiEvaluation['growth_opportunities'];
      score = apiEvaluation['score'] ?? '7.5';
    } else if (apiEvaluation is String) {
      // Handle case where API returns raw text
      summary = apiEvaluation;
      
      // Try to extract score from text
      RegExp scorePattern = RegExp(r'(\d+(?:\.\d+)?)\s*(?:out of|\/)\s*10');
      Match? scoreMatch = scorePattern.firstMatch(apiEvaluation);
      if (scoreMatch != null) {
        score = scoreMatch.group(1) ?? '7.5';
      }
      
      // Try to extract sections from text
      suggestions = _extractSection(apiEvaluation, ['strength', 'advantage', 'benefit', 'positive']);
      challenges = _extractSection(apiEvaluation, ['challenge', 'risk', 'weakness', 'limitation']);
      marketDemand = _extractSection(apiEvaluation, ['market', 'demand', 'customer', 'target']);
      competitors = _extractSection(apiEvaluation, ['competitor', 'competition', 'rival']);
      investmentPotential = _extractSection(apiEvaluation, ['investment', 'fund', 'capital', 'money']);
      govSchemes = _extractSection(apiEvaluation, ['government', 'scheme', 'policy', 'support']);
      growthOpportunities = _extractSection(apiEvaluation, ['growth', 'expansion', 'scale', 'opportunity']);
    }

    // Parse the score and create sub-scores
    double mainScore = double.tryParse(score) ?? 7.5;

    // Generate realistic sub-scores based on main score with some variation
    double feasibilityScore = (mainScore + (mainScore * 0.1 - 0.5)).clamp(
      0.0,
      10.0,
    );
    double marketScore = (mainScore - (mainScore * 0.1 - 0.3)).clamp(0.0, 10.0);
    double financialScore = (mainScore + (mainScore * 0.05 - 0.2)).clamp(
      0.0,
      10.0,
    );
    double riskScore = (mainScore - (mainScore * 0.15)).clamp(0.0, 10.0);

    // Extract structured data from text responses
    List<String> strengthsList = _extractListFromText(
      suggestions ?? summary,
      'strength',
    );
    List<String> challengesList = _extractListFromText(
      challenges ?? '',
      'challenge',
    );
    List<String> governmentSchemes = _extractListFromText(
      govSchemes ?? '',
      'scheme',
    );

    return {
      'overall_score': mainScore,
      'feasibility_score': feasibilityScore,
      'market_potential_score': marketScore,
      'financial_viability_score': financialScore,
      'risk_assessment_score': riskScore,
      'api_summary': summary,
      'api_market_demand': marketDemand,
      'api_suggestions': suggestions,
      'api_challenges': challenges,
      'api_competitors': competitors,
      'api_investment_potential': investmentPotential,
      'api_growth_opportunities': growthOpportunities,
      'api_gov_schemes': govSchemes,
      'strengths': strengthsList.isNotEmpty
          ? strengthsList
          : [
              'AI-powered evaluation completed',
              'Leverages your skills: ${widget.userSkills.join(', ')}',
              'Market analysis provided',
              'Investment potential assessed',
            ],
      'challenges': challengesList.isNotEmpty
          ? challengesList
          : [
              'Market competition to consider',
              'Initial setup requirements',
              'Skill development may be needed',
            ],
      'required_skills': widget.userSkills.isNotEmpty
          ? widget.userSkills
          : [
              'Project Management',
              'Client Communication',
              'Business Development',
            ],
      'skill_gaps': _identifySkillGaps(suggestions ?? summary),
      'financial_projections': {
        'initial_investment':
            _extractFinancialInfo(investmentPotential, 'investment') ??
            widget.selectedIdea['investment_range'] ??
            '₹2,00,000 - ₹5,00,000',
        'monthly_expenses':
            _extractFinancialInfo(summary, 'expenses') ?? '₹25,000 - ₹50,000',
        'break_even_time': _extractTimeInfo(summary) ?? '6-12 months',
        'year_1_revenue':
            _extractFinancialInfo(summary, 'revenue') ??
            '₹6,00,000 - ₹12,00,000',
        'year_2_revenue':
            _extractFinancialInfo(growthOpportunities, 'growth') ??
            '₹12,00,000 - ₹25,00,000',
        'profit_margin': '20-35%',
      },
      'market_analysis': {
        'target_market_size':
            _extractMarketInfo(marketDemand, 'size') ??
            'Growing market segment',
        'competition_level':
            _extractMarketInfo(competitors, 'competition') ??
            'Moderate to High',
        'growth_potential':
            _extractMarketInfo(growthOpportunities, 'growth') ??
            'High potential',
        'market_trends':
            _extractMarketInfo(marketDemand, 'trends') ??
            'Positive market trends',
      },
      'next_steps': _extractActionItems(suggestions ?? summary),
      'government_schemes': governmentSchemes.isNotEmpty
          ? governmentSchemes
          : [
              'Startup India Scheme',
              'MUDRA Loan',
              'Digital India Initiative',
              'Stand-up India',
            ],
      'api_evaluation_data': apiEvaluation, // Store original API data
    };
  }

  // Helper method to extract specific sections from API text responses
  String _extractSection(String text, dynamic sectionType) {
    if (text.isEmpty) return '';

    // Handle both single string and list of keywords
    List<String> keywords = [];
    if (sectionType is String) {
      keywords = [sectionType];
    } else if (sectionType is List<String>) {
      keywords = sectionType;
    } else {
      return '';
    }

    // Convert to lowercase for case-insensitive matching
    String lowerText = text.toLowerCase();

    // Try each keyword to find the best match
    for (String keyword in keywords) {
      String lowerKeyword = keyword.toLowerCase();
      
      // Try to find section headers and extract content
      List<String> commonHeaders = [
        lowerKeyword,
        '${lowerKeyword}:',
        '**${lowerKeyword}**',
        '## ${lowerKeyword}',
        '### ${lowerKeyword}',
        '$lowerKeyword analysis',
        '$lowerKeyword overview',
        '${lowerKeyword}s:', // plural form
      ];

      for (String header in commonHeaders) {
        int headerIndex = lowerText.indexOf(header);
        if (headerIndex != -1) {
          // Find the start of content after the header
          int contentStart = headerIndex + header.length;
          
          // Skip any colons, asterisks, or whitespace
          while (contentStart < text.length && 
                 (text[contentStart] == ':' || text[contentStart] == '*' || 
                  text[contentStart] == ' ' || text[contentStart] == '\n')) {
            contentStart++;
          }

          // Find the end of this section (next header or end of text)
          int contentEnd = text.length;
          List<String> nextSectionMarkers = ['##', '**', '\n\n'];
          
          for (String marker in nextSectionMarkers) {
            int markerIndex = text.indexOf(marker, contentStart + 50); // Skip immediate area
            if (markerIndex != -1 && markerIndex < contentEnd) {
              contentEnd = markerIndex;
            }
          }

          // Extract and clean the content
          String content = text.substring(contentStart, contentEnd).trim();
          
          // Remove excessive newlines and clean up
          content = content.replaceAll(RegExp(r'\n{3,}'), '\n\n');
          content = content.replaceAll(RegExp(r'^\*+|^\-+|^#+'), '').trim();
          
          if (content.isNotEmpty) {
            return content;
          }
        }
      }
    }

    // If no specific section found, look for keywords in sentences
    List<String> sentences = text.split(RegExp(r'[.!?]')).where((s) => s.trim().isNotEmpty).toList();
    
    for (String keyword in keywords) {
      String lowerKeyword = keyword.toLowerCase();
      for (String sentence in sentences) {
        if (sentence.toLowerCase().contains(lowerKeyword)) {
          // Return this sentence and maybe the next one
          int index = sentences.indexOf(sentence);
          String result = sentence.trim();
          if (index + 1 < sentences.length) {
            result += '. ' + sentences[index + 1].trim();
          }
          return result + '.';
        }
      }
    }
    
    // Last resort: return a portion of the text
    if (sentences.length > 2) {
      return sentences.take(3).join('. ').trim() + '.';
    }
    
    return text.length > 200 ? text.substring(0, 200) + '...' : text;
  }

  // Helper methods to extract structured information from API text responses
  List<String> _extractListFromText(String text, String type) {
    if (text.isEmpty) return [];

    // Look for bullet points, numbered lists, or sentences that indicate the type
    List<String> items = [];

    // Split by common delimiters and filter relevant items
    List<String> sentences = text
        .split(RegExp(r'[.!?•\n-]'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty && s.length > 10)
        .toList();

    for (String sentence in sentences.take(5)) {
      // Limit to 5 items
      if (sentence.length > 15 && sentence.length < 150) {
        items.add(sentence);
      }
    }

    return items;
  }

  List<String> _identifySkillGaps(String text) {
    List<String> commonSkills = [
      'Business Development',
      'Marketing',
      'Financial Planning',
      'Project Management',
      'Digital Marketing',
      'Sales',
    ];

    List<String> gaps = [];
    for (String skill in commonSkills) {
      if (!widget.userSkills.contains(skill) &&
          text.toLowerCase().contains(skill.toLowerCase())) {
        gaps.add(skill);
      }
    }

    return gaps.take(3).toList(); // Limit to 3 skill gaps
  }

  String? _extractFinancialInfo(String? text, String type) {
    if (text == null || text.isEmpty) return null;

    // Look for currency amounts in the text
    RegExp rupeePattern = RegExp(r'₹[\d,]+(?:\s*-\s*₹[\d,]+)?');
    Match? match = rupeePattern.firstMatch(text);

    return match?.group(0);
  }

  String? _extractTimeInfo(String text) {
    // Look for time periods in the text
    RegExp timePattern = RegExp(r'\d+[-\s]*(?:months?|years?)');
    Match? match = timePattern.firstMatch(text);

    return match?.group(0);
  }

  String? _extractMarketInfo(String? text, String type) {
    if (text == null || text.isEmpty) return null;

    // Extract the first meaningful sentence
    List<String> sentences = text
        .split('.')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty && s.length > 20)
        .toList();

    return sentences.isNotEmpty ? sentences.first : null;
  }

  List<String> _extractActionItems(String text) {
    List<String> defaultActions = [
      'Conduct detailed market research',
      'Develop a comprehensive business plan',
      'Secure initial funding or investment',
      'Build a strong team with required skills',
      'Create a minimum viable product (MVP)',
      'Establish key partnerships',
      'Develop marketing and sales strategy',
    ];

    // Try to extract action items from the text, otherwise use defaults
    List<String> actions = _extractListFromText(text, 'action');

    return actions.isNotEmpty ? actions : defaultActions.take(5).toList();
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
              const Icon(Icons.analytics, color: Color(0xFF2E7D32), size: 28),
              const SizedBox(width: 8),
              const Text(
                'Idea Evaluation',
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
            'Evaluating: ${widget.selectedIdea['title']}',
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
                            Icons.psychology,
                            color: const Color(0xFF2E7D32),
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'AI is evaluating your idea...',
                      style: context.textStyles.bodyMedium.grey(context),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Analyzing feasibility, market potential, and providing insights',
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
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _generateEvaluation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ] else if (_evaluationResult != null) ...[
            Expanded(
              child: ListView(
                children: [
                  // Overall Score Card
                  _buildScoreCard(),
                  const SizedBox(height: 16),

                  // Detailed Scores
                  _buildDetailedScores(),
                  const SizedBox(height: 16),

                  // Strengths and Challenges
                  _buildStrengthsAndChallenges(),
                  const SizedBox(height: 16),

                  // Skill Analysis
                  _buildSkillAnalysis(),
                  const SizedBox(height: 16),

                  // Financial Projections
                  _buildFinancialProjections(),
                  const SizedBox(height: 16),

                  // Market Analysis
                  _buildMarketAnalysis(),
                  const SizedBox(height: 16),

                  // Government Schemes
                  _buildGovernmentSchemes(),
                  const SizedBox(height: 16),

                  // Next Steps
                  _buildNextSteps(),
                ],
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
                  'Back to Ideas',
                  style: TextStyle(color: Color(0xFF2E7D32)),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _evaluationResult != null
                    ? () => widget.onEvaluationComplete(_evaluationResult!)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text('Generate Roadmap'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard() {
    final score = _evaluationResult!['overall_score'];
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [const Color(0xFF2E7D32), const Color(0xFF4CAF50)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const Text(
              'Overall Viability Score',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '$score/10',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getScoreDescription(score),
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedScores() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detailed Analysis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 16),
            _buildScoreBar(
              'Feasibility',
              _evaluationResult!['feasibility_score'],
            ),
            _buildScoreBar(
              'Market Potential',
              _evaluationResult!['market_potential_score'],
            ),
            _buildScoreBar(
              'Financial Viability',
              _evaluationResult!['financial_viability_score'],
            ),
            _buildScoreBar(
              'Risk Assessment',
              _evaluationResult!['risk_assessment_score'],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBar(String label, double score) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$score/10',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: score / 10,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              score >= 8
                  ? Colors.green
                  : score >= 6
                  ? Colors.orange
                  : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStrengthsAndChallenges() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.thumb_up, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Strengths',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...(_evaluationResult!['strengths'] as List).map(
                    (strength) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '• ',
                            style: TextStyle(color: Colors.green),
                          ),
                          Expanded(
                            child: Text(
                              strength,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.orange, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Challenges',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...(_evaluationResult!['challenges'] as List).map(
                    (challenge) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '• ',
                            style: TextStyle(color: Colors.orange),
                          ),
                          Expanded(
                            child: Text(
                              challenge,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillAnalysis() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Skill Analysis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 16),

            // Required Skills
            const Text(
              'Required Skills:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (_evaluationResult!['required_skills'] as List)
                  .map(
                    (skill) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade300),
                      ),
                      child: Text(
                        skill,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 16),

            // Skill Gaps
            const Text(
              'Skills to Develop:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (_evaluationResult!['skill_gaps'] as List)
                  .map(
                    (skill) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade300),
                      ),
                      child: Text(
                        skill,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialProjections() {
    final financial = _evaluationResult!['financial_projections'];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Financial Projections',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 16),
            _buildFinancialRow(
              'Initial Investment',
              financial['initial_investment'],
            ),
            _buildFinancialRow(
              'Monthly Expenses',
              financial['monthly_expenses'],
            ),
            _buildFinancialRow('Break-even Time', financial['break_even_time']),
            _buildFinancialRow('Year 1 Revenue', financial['year_1_revenue']),
            _buildFinancialRow('Year 2 Revenue', financial['year_2_revenue']),
            _buildFinancialRow('Profit Margin', financial['profit_margin']),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E7D32),
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketAnalysis() {
    final market = _evaluationResult!['market_analysis'];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Market Analysis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 16),
            _buildFinancialRow('Target Market', market['target_market_size']),
            _buildFinancialRow('Competition', market['competition_level']),
            _buildFinancialRow('Growth Potential', market['growth_potential']),
            _buildFinancialRow('Market Trends', market['market_trends']),
          ],
        ),
      ),
    );
  }

  Widget _buildGovernmentSchemes() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Relevant Government Schemes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 16),
            ...(_evaluationResult!['government_schemes'] as List).map(
              (scheme) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.account_balance,
                      color: Color(0xFF2E7D32),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(scheme, style: const TextStyle(fontSize: 14)),
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

  Widget _buildNextSteps() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recommended Next Steps',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 16),
            ...(_evaluationResult!['next_steps'] as List).asMap().entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2E7D32),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${entry.key + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: const TextStyle(fontSize: 14),
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

  String _getScoreDescription(double score) {
    if (score >= 8.5) return 'Excellent opportunity!';
    if (score >= 7.5) return 'Very good potential';
    if (score >= 6.5) return 'Good potential with some considerations';
    if (score >= 5.0) return 'Moderate potential';
    return 'Needs significant improvements';
  }
}
