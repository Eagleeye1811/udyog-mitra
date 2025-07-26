// Data models for API requests and responses

class SkillMappingRequest {
  final String skill;
  final String location;

  SkillMappingRequest({required this.skill, required this.location});

  Map<String, dynamic> toJson() => {'skill': skill, 'location': location};
}

class BusinessIdea {
  final String? id;
  final String title;
  final String description;

  BusinessIdea({this.id, required this.title, required this.description});

  factory BusinessIdea.fromJson(Map<String, dynamic> json) => BusinessIdea(
    id: json['id'],
    title: json['title'],
    description: json['description'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
  };
}

class SkillMappingResponse {
  final String introduction;
  final List<BusinessIdea> businessIdeas;
  final String conclusion;

  SkillMappingResponse({
    required this.introduction,
    required this.businessIdeas,
    required this.conclusion,
  });

  factory SkillMappingResponse.fromJson(Map<String, dynamic> json) =>
      SkillMappingResponse(
        introduction: json['introduction'] ?? '',
        businessIdeas:
            (json['business_ideas'] as List<dynamic>?)
                ?.map((e) => BusinessIdea.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        conclusion: json['conclusion'] ?? '',
      );
}

class IdeaEvaluationRequest {
  final String idea;
  final String location;

  IdeaEvaluationRequest({required this.idea, required this.location});

  Map<String, dynamic> toJson() => {'idea': idea, 'location': location};
}

class IdeaEvaluationResponse {
  final String summary;
  final String marketDemand;
  final String? suggestions;
  final String? challenges;
  final String? roadmap;
  final String? govSchemes;
  final String? competitors;
  final String? investmentPotential;
  final String? growthOpportunities;
  final String score;

  IdeaEvaluationResponse({
    required this.summary,
    required this.marketDemand,
    this.suggestions,
    this.challenges,
    this.roadmap,
    this.govSchemes,
    this.competitors,
    this.investmentPotential,
    this.growthOpportunities,
    required this.score,
  });

  factory IdeaEvaluationResponse.fromJson(Map<String, dynamic> json) =>
      IdeaEvaluationResponse(
        summary: json['summary'] ?? '',
        marketDemand: json['market_demand'] ?? '',
        suggestions: json['suggestions'],
        challenges: json['challenges'],
        roadmap: json['roadmap'],
        govSchemes: json['gov_schemes'],
        competitors: json['competitors'],
        investmentPotential: json['investment_potential'],
        growthOpportunities: json['growth_opportunities'],
        score: json['score'] ?? '0',
      );
}

class RoadmapRequest {
  final String? idea;
  final String? ideaId;
  final String location;

  RoadmapRequest({this.idea, this.ideaId, required this.location});

  Map<String, dynamic> toJson() => {
    'idea': idea,
    'idea_id': ideaId,
    'location': location,
  };
}

class RoadmapResponse {
  final String licensesAndRegistrations;
  final String fundingAndCost;
  final String timelineAndMilestones;
  final String marketingPlan;
  final String risksAndOpportunities;
  final String partnershipsAndScaling;

  RoadmapResponse({
    required this.licensesAndRegistrations,
    required this.fundingAndCost,
    required this.timelineAndMilestones,
    required this.marketingPlan,
    required this.risksAndOpportunities,
    required this.partnershipsAndScaling,
  });

  factory RoadmapResponse.fromJson(Map<String, dynamic> json) =>
      RoadmapResponse(
        licensesAndRegistrations: json['licenses_and_registrations'] ?? '',
        fundingAndCost: json['funding_and_cost'] ?? '',
        timelineAndMilestones: json['timeline_and_milestones'] ?? '',
        marketingPlan: json['marketing_plan'] ?? '',
        risksAndOpportunities: json['risks_and_opportunities'] ?? '',
        partnershipsAndScaling: json['partnerships_and_scaling'] ?? '',
      );
}

class IdeaSelectionRequest {
  final String ideaId;

  IdeaSelectionRequest({required this.ideaId});

  Map<String, dynamic> toJson() => {'idea_id': ideaId};
}
