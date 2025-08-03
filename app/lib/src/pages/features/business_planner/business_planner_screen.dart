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
    setState(() {
      _selectedIdea = idea;
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
                    _updateSkills(skills);
                    _moveToNextStep();
                  },
                  onBack: () => Navigator.pop(context),
                ),

                // Step 2: Business Ideas Generation
                BusinessIdeasScreen(
                  skills: _userSkills,
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
