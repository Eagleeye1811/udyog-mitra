import 'package:flutter/material.dart';
import 'package:udyogmitra/src/config/themes/app_theme.dart';
import 'package:udyogmitra/src/config/themes/helpers.dart';
import 'screens/skill_input_screen.dart';
import 'screens/business_ideas_screen.dart';
import 'screens/idea_evaluation_screen.dart';
import 'screens/roadmap_generation_screen.dart';

class BusinessPlannerScreen extends StatefulWidget {
  const BusinessPlannerScreen({super.key});

  @override
  State<BusinessPlannerScreen> createState() => _BusinessPlannerScreenState();
}

class _BusinessPlannerScreenState extends State<BusinessPlannerScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Data flow through the journey
  List<String> _userSkills = [];
  Map<String, dynamic>? _selectedIdea;
  Map<String, dynamic>? _evaluationResult;

  // Cached API responses to avoid re-fetching
  List<Map<String, dynamic>>? _cachedBusinessIdeas;
  Map<String, dynamic>? _cachedEvaluationData;
  Map<String, dynamic>? _cachedRoadmapData;

  // Cache keys to track what data the cache is based on
  String? _cachedIdeasKey;
  String? _cachedEvaluationKey;
  String? _cachedRoadmapKey;

  void _moveToNextStep() {
    if (_currentStep < 3) {
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

  void _updateSkills(List<String> skills) {
    setState(() {
      _userSkills = skills;
    });
  }

  void _selectIdea(Map<String, dynamic> idea) {
    // Clear evaluation and roadmap cache if a different idea is selected
    if (_selectedIdea != null && _selectedIdea!['title'] != idea['title']) {
      setState(() {
        _cachedEvaluationData = null;
        _cachedEvaluationKey = null;
        _cachedRoadmapData = null;
        _cachedRoadmapKey = null;
        _evaluationResult = null;
      });
    }
    setState(() {
      _selectedIdea = idea;
    });
  }

  void _updateEvaluation(Map<String, dynamic> evaluation) {
    setState(() {
      _evaluationResult = evaluation;
    });
  }

  // Methods to cache API responses
  void _cacheBusinessIdeas(List<Map<String, dynamic>> ideas) {
    final newKey = _generateIdeasCacheKey();
    setState(() {
      _cachedBusinessIdeas = ideas;
      _cachedIdeasKey = newKey;
    });
  }

  void _cacheEvaluationData(Map<String, dynamic> evaluationData) {
    final newKey = _generateEvaluationCacheKey();
    setState(() {
      _cachedEvaluationData = evaluationData;
      _cachedEvaluationKey = newKey;
    });
  }

  void _cacheRoadmapData(Map<String, dynamic> roadmapData) {
    final newKey = _generateRoadmapCacheKey();
    setState(() {
      _cachedRoadmapData = roadmapData;
      _cachedRoadmapKey = newKey;
    });
  }

  // Generate cache keys based on input combinations
  String _generateIdeasCacheKey() {
    return _userSkills.join(',');
  }

  String _generateEvaluationCacheKey() {
    return '${_userSkills.join(',')}|${_selectedIdea?['title'] ?? ''}';
  }

  String _generateRoadmapCacheKey() {
    return '${_userSkills.join(',')}|${_selectedIdea?['title'] ?? ''}|${_evaluationResult?['feasibility'] ?? ''}';
  }

  // Check if cached data is valid for current inputs
  bool _isIdeasCacheValid() {
    return _cachedBusinessIdeas != null &&
        _cachedIdeasKey == _generateIdeasCacheKey();
  }

  bool _isEvaluationCacheValid() {
    return _cachedEvaluationData != null &&
        _cachedEvaluationKey == _generateEvaluationCacheKey();
  }

  bool _isRoadmapCacheValid() {
    return _cachedRoadmapData != null &&
        _cachedRoadmapKey == _generateRoadmapCacheKey();
  }

  // Clear cache when starting over or changing skills
  void _clearCache() {
    setState(() {
      _cachedBusinessIdeas = null;
      _cachedEvaluationData = null;
      _cachedRoadmapData = null;
      _cachedIdeasKey = null;
      _cachedEvaluationKey = null;
      _cachedRoadmapKey = null;
      _selectedIdea = null;
      _evaluationResult = null;
    });
  }

  // Helper method to compare two lists
  bool _areListsEqual(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Planner'),
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
                for (int i = 0; i < 4; i++) ...[
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: i <= _currentStep
                            ? Colors.white
                            : Colors.white.withAlpha(77),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  if (i < 3) const SizedBox(width: 8),
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
                  style: context.textStyles.labelLarge.white(),
                ),
                const SizedBox(width: 8),
                Text(
                  'Step ${_currentStep + 1} of 4',
                  style: context.textStyles.labelSmall.white(),
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
                // Step 1: Skill Input
                SkillInputScreen(
                  onSkillsSubmitted: (skills) {
                    // Clear cache when skills change
                    if (_userSkills.isNotEmpty &&
                        !_areListsEqual(_userSkills, skills)) {
                      _clearCache();
                    }
                    _updateSkills(skills);
                    _moveToNextStep();
                  },
                  onBack: () => Navigator.pop(context),
                ),

                // Step 2: Business Ideas Generation
                BusinessIdeasScreen(
                  skills: _userSkills,
                  cachedIdeas: _isIdeasCacheValid()
                      ? _cachedBusinessIdeas
                      : null,
                  onIdeasGenerated: _cacheBusinessIdeas,
                  onIdeaSelected: (idea) {
                    _selectIdea(idea);
                    _moveToNextStep();
                  },
                  onBack: _moveToPreviousStep,
                ),

                // Step 3: Idea Evaluation
                _selectedIdea != null
                    ? IdeaEvaluationScreen(
                        selectedIdea: _selectedIdea!,
                        userSkills: _userSkills,
                        cachedEvaluationData: _isEvaluationCacheValid()
                            ? _cachedEvaluationData
                            : null,
                        onEvaluationDataGenerated: _cacheEvaluationData,
                        onEvaluationComplete: (evaluation) {
                          _updateEvaluation(evaluation);
                          _moveToNextStep();
                        },
                        onBack: _moveToPreviousStep,
                      )
                    : const Center(child: CircularProgressIndicator()),

                // Step 4: Roadmap Generation
                _evaluationResult != null && _selectedIdea != null
                    ? RoadmapGenerationScreen(
                        evaluationResult: _evaluationResult!,
                        selectedIdea: _selectedIdea!,
                        userSkills: _userSkills,
                        cachedRoadmapData: _isRoadmapCacheValid()
                            ? _cachedRoadmapData
                            : null,
                        onRoadmapDataGenerated: _cacheRoadmapData,
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
        return 'Enter Your Skills';
      case 1:
        return 'Explore Business Ideas';
      case 2:
        return 'Evaluate Your Idea';
      case 3:
        return 'Generate Roadmap';
      default:
        return 'Business Planning';
    }
  }
}
