import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _generateEvaluation();
  }

  void _generateEvaluation() {
    // Simulate API call to evaluate the business idea
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _evaluationResult = _getDetailedEvaluation();
        _isLoading = false;
      });
    });
  }

  Map<String, dynamic> _getDetailedEvaluation() {
    // This would normally come from your backend API
    return {
      'overall_score': 8.4,
      'feasibility_score': 8.8,
      'market_potential_score': 8.0,
      'financial_viability_score': 8.2,
      'risk_assessment_score': 7.5,
      'strengths': [
        'High demand in digital market',
        'Leverages your existing skills',
        'Low initial investment required',
        'Scalable business model',
        'Multiple revenue streams possible',
      ],
      'challenges': [
        'High competition in digital space',
        'Need to build client base',
        'Requires continuous skill updating',
        'Client acquisition can be challenging initially',
      ],
      'required_skills': [
        'Project Management',
        'Client Communication',
        'Business Development',
        'Financial Planning',
      ],
      'skill_gaps': ['Business Development', 'Financial Planning'],
      'financial_projections': {
        'initial_investment': '₹1,50,000',
        'monthly_expenses': '₹25,000',
        'break_even_time': '6-8 months',
        'year_1_revenue': '₹8,00,000 - ₹12,00,000',
        'year_2_revenue': '₹15,00,000 - ₹25,00,000',
        'profit_margin': '25-35%',
      },
      'market_analysis': {
        'target_market_size': 'Large (SMBs and Startups)',
        'competition_level': 'High',
        'growth_potential': 'Very High',
        'market_trends': 'Digital transformation increasing demand',
      },
      'next_steps': [
        'Create a detailed business plan',
        'Build a portfolio website',
        'Network with potential clients',
        'Set up legal structure (LLP/Pvt Ltd)',
        'Develop service packages and pricing',
        'Create marketing strategy',
      ],
      'government_schemes': [
        'Startup India Scheme',
        'MUDRA Loan',
        'Digital India Initiative',
        'Skill India Program',
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
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Color(0xFF2E7D32)),
                    SizedBox(height: 16),
                    Text(
                      'Analyzing your business idea...',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'This may take a few moments',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
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
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E7D32),
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
