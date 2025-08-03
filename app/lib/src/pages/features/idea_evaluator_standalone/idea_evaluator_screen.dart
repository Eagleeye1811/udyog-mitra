import 'package:flutter/material.dart';
import 'package:udyogmitra/src/config/themes/app_theme.dart';
import 'package:udyogmitra/src/config/themes/helpers.dart';
import '../business_planner/screens/idea_evaluation_screen.dart';
import '../business_planner/screens/roadmap_generation_screen.dart';
import '../../../services/api_service.dart';

class IdeaEvaluatorScreen extends StatefulWidget {
  const IdeaEvaluatorScreen({super.key});

  @override
  State<IdeaEvaluatorScreen> createState() => _IdeaEvaluatorScreenState();
}

class _IdeaEvaluatorScreenState extends State<IdeaEvaluatorScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Data flow
  Map<String, dynamic>? _ideaData;
  Map<String, dynamic>? _evaluationResult;

  void _moveToNextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _moveToPreviousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _updateIdeaData(Map<String, dynamic> idea) {
    setState(() {
      _ideaData = idea;
    });
  }

  void _updateEvaluation(Map<String, dynamic> evaluation) {
    setState(() {
      _evaluationResult = evaluation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Idea Evaluator'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Progress Indicator
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF2E7D32),
            child: Row(
              children: [
                for (int i = 0; i < 3; i++) ...[
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: i <= _currentStep
                            ? Colors.white
                            : Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  if (i < 2) const SizedBox(width: 8),
                ],
              ],
            ),
          ),

          // Step Indicator
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: const Color(0xFF388E3C),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _getStepTitle(_currentStep),
                  style: context.textStyles.bodyMedium,
                ),
                const SizedBox(width: 8),
                Text(
                  'Step ${_currentStep + 1} of 3',
                  style: context.textStyles.labelSmall.grey(context),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Step 1: Idea Input
                IdeaInputScreen(
                  onIdeaSubmitted: (idea) {
                    _updateIdeaData(idea);
                    _moveToNextStep();
                  },
                  onBack: () => Navigator.pop(context),
                ),

                // Step 2: Idea Evaluation
                _ideaData != null
                    ? IdeaEvaluationScreen(
                        selectedIdea: _ideaData!,
                        userSkills:
                            const [], // No skills for standalone evaluation
                        onEvaluationComplete: (evaluation) {
                          _updateEvaluation(evaluation);
                          _moveToNextStep();
                        },
                        onBack: _moveToPreviousStep,
                      )
                    : const Center(child: CircularProgressIndicator()),

                // Step 3: Roadmap Generation
                _evaluationResult != null && _ideaData != null
                    ? RoadmapGenerationScreen(
                        evaluationResult: _evaluationResult!,
                        selectedIdea: _ideaData!,
                        userSkills:
                            const [], // No skills for standalone evaluation
                        onBack: _moveToPreviousStep,
                        onComplete: () => Navigator.pop(context),
                      )
                    : const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'Describe Your Idea';
      case 1:
        return 'Evaluation Results';
      case 2:
        return 'Business Roadmap';
      default:
        return 'Idea Evaluation';
    }
  }
}

class IdeaInputScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onIdeaSubmitted;
  final VoidCallback onBack;

  const IdeaInputScreen({
    super.key,
    required this.onIdeaSubmitted,
    required this.onBack,
  });

  @override
  State<IdeaInputScreen> createState() => _IdeaInputScreenState();
}

class _IdeaInputScreenState extends State<IdeaInputScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetMarketController = TextEditingController();
  final _revenueModelController = TextEditingController();

  String _selectedCategory = 'Technology';
  String _selectedInvestment = 'Low (₹50,000 - ₹2,00,000)';
  bool _isLoading = false;

  final List<String> _categories = [
    'Technology',
    'Healthcare',
    'Education',
    'Finance',
    'Retail',
    'Food & Beverage',
    'Manufacturing',
    'Services',
    'Agriculture',
    'Other',
  ];

  final List<String> _investmentRanges = [
    'Very Low (Under ₹50,000)',
    'Low (₹50,000 - ₹2,00,000)',
    'Medium (₹2,00,000 - ₹10,00,000)',
    'High (₹10,00,000 - ₹50,00,000)',
    'Very High (Above ₹50,00,000)',
  ];

  bool get _isFormValid {
    return _titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _targetMarketController.text.isNotEmpty;
  }

  void _submitIdea() async {
    if (_isFormValid && !_isLoading) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Create the full idea description for API evaluation
        final fullIdeaDescription =
            '''
Business Idea: ${_titleController.text}

Description: ${_descriptionController.text}

Category: $_selectedCategory
Target Market: ${_targetMarketController.text}
Expected Investment: $_selectedInvestment
${_revenueModelController.text.isNotEmpty ? 'Revenue Model: ${_revenueModelController.text}' : ''}
        ''';

        // Call the API to evaluate the idea
        final evaluationResponse = await IdeaEvaluatorApiService.validateIdea(
          idea: fullIdeaDescription,
          location: 'India', // Default location, can be made configurable
        );

        // Create idea data structure that matches what the UI expects
        final ideaData = {
          'title': _titleController.text,
          'description': _descriptionController.text,
          'category': _selectedCategory,
          'target_market': _targetMarketController.text,
          'revenue_model': _revenueModelController.text.isNotEmpty
              ? _revenueModelController.text
              : 'To be determined',
          'investment_range': _selectedInvestment,
          'api_evaluation': evaluationResponse,
        };

        setState(() {
          _isLoading = false;
        });

        widget.onIdeaSubmitted(ideaData);
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to evaluate idea: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tell us about your business idea',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Provide details about your idea to get a comprehensive evaluation.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          Expanded(
            child: ListView(
              children: [
                // Idea Title
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Business Idea Title *',
                    hintText: 'e.g., AI-powered Food Delivery App',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),

                // Description
                TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Detailed Description *',
                    hintText:
                        'Describe your business idea, what problem it solves, and how it works...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                    alignLabelWithHint: true,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),

                // Category Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Business Category',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Target Market
                TextField(
                  controller: _targetMarketController,
                  decoration: const InputDecoration(
                    labelText: 'Target Market *',
                    hintText: 'e.g., Young professionals in urban areas',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.people),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),

                // Revenue Model
                TextField(
                  controller: _revenueModelController,
                  decoration: const InputDecoration(
                    labelText: 'Revenue Model (Optional)',
                    hintText:
                        'e.g., Subscription, Commission, One-time payment',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.monetization_on),
                  ),
                ),
                const SizedBox(height: 16),

                // Investment Range
                DropdownButtonFormField<String>(
                  value: _selectedInvestment,
                  decoration: const InputDecoration(
                    labelText: 'Expected Investment Range',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  items: _investmentRanges.map((range) {
                    return DropdownMenuItem(value: range, child: Text(range));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedInvestment = value!;
                    });
                  },
                ),
              ],
            ),
          ),

          // Navigation buttons
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton(
                onPressed: widget.onBack,
                child: const Text(
                  'Back',
                  style: TextStyle(color: Color(0xFF2E7D32)),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _isFormValid && !_isLoading ? _submitIdea : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Evaluate Idea'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _targetMarketController.dispose();
    _revenueModelController.dispose();
    super.dispose();
  }
}
