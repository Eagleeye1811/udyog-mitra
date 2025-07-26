# UdyogMitra Integration Guide 🔗

## Overview

This guide explains how the **Flutter frontend** connects with the **FastAPI backend** to provide AI-powered business planning services. Think of it as a bridge between what users see (Flutter app) and the smart AI brain (FastAPI server).

---

## 🏗️ Architecture Overview

```
┌─────────────────┐    HTTP Requests    ┌─────────────────┐
│                 │ ──────────────────► │                 │
│  Flutter App    │                     │  FastAPI Server │
│  (Frontend)     │ ◄────────────────── │  (Backend)      │
│                 │    JSON Responses   │                 │
└─────────────────┘                     └─────────────────┘
```

---

## 📱 Flutter Frontend Components

### 1. **HTTP Client Setup (Dio)**

**Location**: `lib/src/api/api_config.dart`

**What it does**: Creates a smart HTTP client that can talk to our backend server.

```dart
// Think of this as a messenger that carries data between app and server
class DioConfig {
  static Dio createDio() {
    final dio = Dio(BaseOptions(
      baseUrl: 'http://localhost:8000',  // Where our FastAPI server lives
      connectTimeout: Duration(minutes: 2),  // How long to wait for connection
      receiveTimeout: Duration(minutes: 3),  // How long to wait for response
    ));

    // Add smart features:
    dio.interceptors.add(LogInterceptor());     // Logs all requests (for debugging)
    dio.interceptors.add(RetryInterceptor());   // Retries failed requests

    return dio;
  }
}
```

**Simple Explanation**: Like having a smart postman who:

- Knows where to deliver messages (backend URL)
- Waits patiently for responses
- Tries again if delivery fails
- Keeps a record of all deliveries

### 2. **API Service Layer**

**Location**: `lib/src/api/api_service.dart`

**What it does**: Provides easy-to-use methods for different AI services.

```dart
class ApiService {
  // 🧠 Skill-to-Business Mapping
  static Future<Map<String, dynamic>> mapSkillsToBusiness({
    required List<String> skills,
    required String location,
  }) async {
    // Sends user skills to AI and gets business suggestions
    final response = await _dio.post('/skill-to-business', data: {
      'skills': skills,
      'location': location,
    });
    return response.data;
  }

  // 📊 Idea Evaluation
  static Future<Map<String, dynamic>> validateIdea({
    required String idea,
    required String location,
  }) async {
    // Sends business idea to AI for detailed analysis
    final response = await _dio.post('/validate-idea', data: {
      'idea': idea,
      'location': location,
    });
    return response.data;
  }

  // 🗺️ Roadmap Generation
  static Future<Map<String, dynamic>> generateRoadmap({
    required String idea,
    required String location,
  }) async {
    // Gets step-by-step business roadmap from AI
    final response = await _dio.post('/generate-roadmap', data: {
      'idea': idea,
      'location': location,
    });
    return response.data;
  }
}
```

**Simple Explanation**: Like having specialized assistants:

- **Skill Mapper**: "Give me your skills, I'll suggest businesses"
- **Idea Validator**: "Tell me your idea, I'll analyze its potential"
- **Roadmap Creator**: "Share your plan, I'll create step-by-step guidance"

### 3. **UI Screens with API Integration**

#### Business Ideas Screen

**Location**: `lib/src/pages/features/business_planner/screens/business_ideas_screen.dart`

```dart
class BusinessIdeasScreen extends StatefulWidget {
  void _generateBusinessIdeas() async {
    setState(() => _isLoading = true);

    try {
      // Call API to get AI-generated business ideas
      final response = await ApiService.mapSkillsToBusiness(
        skills: widget.skills,
        location: 'India',
      );

      // Convert API response to UI format
      setState(() {
        _skillMappingResponse = SkillMappingResponse.fromJson(response);
        _isLoading = false;
      });
    } catch (error) {
      // Show error if something goes wrong
      setState(() {
        _errorMessage = 'Failed to generate ideas: $error';
        _isLoading = false;
      });
    }
  }
}
```

**Simple Explanation**:

1. User enters their skills
2. App shows loading screen
3. App asks AI for business suggestions
4. AI analyzes skills and returns ideas
5. App displays ideas to user

#### Idea Evaluation Screen

**Location**: `lib/src/pages/features/business_planner/screens/idea_evaluation_screen.dart`

```dart
void _evaluateIdea() async {
  setState(() => _isLoading = true);

  try {
    // Send selected idea to AI for detailed analysis
    final response = await ApiService.validateIdea(
      idea: widget.selectedIdea['description'],
      location: 'India',
    );

    // Convert AI response to user-friendly format
    final evaluation = _convertApiEvaluationToUIFormat(response);

    setState(() {
      _evaluationResult = evaluation;
      _isLoading = false;
    });
  } catch (error) {
    // Handle errors gracefully
    setState(() {
      _errorMessage = 'Evaluation failed: $error';
      _isLoading = false;
    });
  }
}
```

**Simple Explanation**:

1. User selects a business idea
2. App sends idea to AI for deep analysis
3. AI evaluates feasibility, market potential, risks
4. App converts AI response to scores and insights
5. User sees detailed evaluation with recommendations

---

## 🖥️ FastAPI Backend Components

### 1. **Server Setup**

**Location**: `udyog-mitra-backend/main.py`

```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="UdyogMitra AI Backend")

# Allow Flutter app to connect (CORS)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins (Flutter app can connect)
    allow_methods=["*"],  # Allow all HTTP methods
    allow_headers=["*"],  # Allow all headers
)
```

**Simple Explanation**: Creates a server that:

- Welcomes requests from Flutter app
- Allows all types of communication
- Is ready to process AI requests

### 2. **API Endpoints**

#### Skill-to-Business Mapping

**Location**: `app/api/routes_skills.py`

```python
@router.post("/skill-to-business")
async def map_skills_to_business(request: SkillMappingRequest):
    """
    Takes user skills and generates personalized business ideas
    """
    # Build AI prompt with user skills
    prompt = f"""
    User Skills: {', '.join(request.skills)}
    Location: {request.location}

    Generate 5 personalized business ideas...
    """

    # Send to AI (LLM) for processing
    ai_response = await llm_service.generate_response(prompt)

    # Structure the response for Flutter app
    return {
        "introduction": "Based on your skills...",
        "business_ideas": parse_business_ideas(ai_response),
        "success": True
    }
```

#### Idea Validation

**Location**: `app/api/routes_idea.py`

```python
@router.post("/validate-idea")
async def validate_business_idea(request: IdeaValidationRequest):
    """
    Analyzes a business idea and provides detailed evaluation
    """
    prompt = f"""
    Business Idea: {request.idea}
    Location: {request.location}

    Analyze this idea for:
    - Market feasibility
    - Financial viability
    - Risk assessment
    - Growth potential
    """

    ai_response = await llm_service.generate_response(prompt)

    return {
        "summary": extract_summary(ai_response),
        "market_demand": extract_market_analysis(ai_response),
        "score": calculate_overall_score(ai_response),
        "suggestions": extract_suggestions(ai_response)
    }
```

### 3. **AI Integration**

**Location**: `app/inference/llm_service.py`

```python
class LLMService:
    def __init__(self):
        # Connect to AI model (like ChatGPT, Gemini, etc.)
        self.client = initialize_ai_model()

    async def generate_response(self, prompt: str) -> str:
        """
        Sends prompt to AI and gets intelligent response
        """
        response = await self.client.generate(
            prompt=prompt,
            max_tokens=2000,
            temperature=0.7  # Controls creativity
        )
        return response.text
```

**Simple Explanation**: This is the AI brain that:

- Takes business questions from Flutter app
- Thinks about them using advanced AI
- Returns smart, helpful answers
- Handles different types of business analysis

---

## 🔄 Complete Integration Flow

### Step-by-Step Data Journey

1. **User Input** (Flutter)

   ```
   User enters: ["Web Development", "Marketing", "Design"]
   ```

2. **API Call** (Flutter → FastAPI)

   ```dart
   ApiService.mapSkillsToBusiness(
     skills: ["Web Development", "Marketing", "Design"],
     location: "India"
   )
   ```

3. **HTTP Request** (Network)

   ```http
   POST http://localhost:8000/skill-to-business
   Content-Type: application/json

   {
     "skills": ["Web Development", "Marketing", "Design"],
     "location": "India"
   }
   ```

4. **AI Processing** (FastAPI)

   ```python
   # Server receives request
   # Builds AI prompt
   # Sends to LLM
   # Gets AI response
   # Structures data for Flutter
   ```

5. **AI Response** (FastAPI → Flutter)

   ```json
   {
     "introduction": "Based on your skills in web development...",
     "business_ideas": [
       {
         "title": "Digital Agency",
         "description": "Start a web design and marketing agency...",
         "match_percentage": 95,
         "investment_range": "Low"
       }
     ],
     "success": true
   }
   ```

6. **UI Update** (Flutter)
   ```dart
   // Flutter receives response
   // Converts to UI format
   // Updates screen
   // Shows business ideas to user
   ```

---

## 🛡️ Error Handling & Reliability

### Frontend Error Handling

```dart
try {
  final response = await ApiService.mapSkillsToBusiness(...);
  // Success: Update UI
} on DioException catch (e) {
  if (e.type == DioExceptionType.connectionTimeout) {
    showError("Connection timeout - please check your internet");
  } else if (e.type == DioExceptionType.receiveTimeout) {
    showError("Server is taking too long - please try again");
  } else {
    showError("Something went wrong - please try again");
  }
} catch (e) {
  showError("Unexpected error occurred");
}
```

### Backend Error Handling

```python
@router.post("/skill-to-business")
async def map_skills_to_business(request: SkillMappingRequest):
    try:
        # Process request
        result = await process_skills(request)
        return {"success": True, "data": result}
    except LLMServiceError as e:
        raise HTTPException(status_code=503, detail="AI service unavailable")
    except Exception as e:
        raise HTTPException(status_code=500, detail="Internal server error")
```

---

## 🔧 Development Setup

### 1. **Backend Setup**

```bash
cd udyog-mitra-backend
pip install -r requirements.txt
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### 2. **Frontend Setup**

```bash
cd udyog-mitra/app
flutter pub get
flutter run
```

### 3. **Testing Connection**

```dart
// Test if backend is reachable
await ApiService.testConnection();
```

---

## 📊 Data Flow Summary

```
User Skills Input
       ↓
Flutter API Service
       ↓
HTTP Request (Dio)
       ↓
FastAPI Router
       ↓
AI Service (LLM)
       ↓
Structured Response
       ↓
Flutter UI Update
       ↓
User Sees Results
```

---

## 🚀 Key Benefits of This Integration

1. **🔄 Real-time AI**: User gets instant AI-powered business insights
2. **📱 Smooth UX**: Loading states and error handling provide great user experience
3. **🛡️ Reliable**: Retry logic and timeouts handle network issues
4. **🎯 Scalable**: Easy to add new AI features
5. **🔧 Maintainable**: Clean separation between frontend and backend
6. **🌐 Flexible**: Can work with different AI models and services

---

## 🎯 Next Steps for Developers

1. **Add Authentication**: Secure API calls with user tokens
2. **Caching**: Store frequently used responses
3. **Offline Support**: Save important data locally
4. **Performance**: Optimize API calls and responses
5. **Analytics**: Track user interactions and API usage

---

This integration creates a seamless bridge between Flutter's beautiful UI and FastAPI's powerful AI capabilities, giving users a smart, responsive business planning experience! 🎉
