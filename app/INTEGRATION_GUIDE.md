# FastAPI + Flutter Integration Guide (Using Dio)

## 🎯 **Overview**

This guide explains how the UdyogMitra Flutter app integrates with the FastAPI backend to provide AI-powered business recommendations using Mistral LLM. **We use Dio instead of the basic `http` package** for superior API handling.

## 🚀 **Why Dio Over HTTP Package?**

Based on feature comparison, Dio provides significant advantages for our LLM-powered API integration:

| Feature                  | Basic `http` | Dio | Why Important for UdyogMitra         |
| ------------------------ | ------------ | --- | ------------------------------------ |
| **Interceptors**         | ❌           | ✅  | Auth tokens, logging, error handling |
| **Request Cancellation** | ❌           | ✅  | Cancel slow LLM API calls            |
| **Advanced Timeout**     | Basic        | ✅  | Better control for AI responses      |
| **Retry Policies**       | ❌           | ✅  | Auto-retry failed AI requests        |
| **Global Headers**       | Manual       | ✅  | Easy auth management                 |
| **Progress Tracking**    | ❌           | ✅  | Future file upload features          |

### **Critical Benefits for AI Integration:**

- **🤖 LLM calls can be slow** → Advanced timeout handling
- **📱 Mobile networks are unreliable** → Automatic retry logic
- **👤 Better UX** → Request cancellation and progress tracking
- **🔐 Future authentication** → Global interceptors
- **🐛 Easier debugging** → Built-in request/response logging

## 📋 **Architecture**

```
┌─────────────────┐    HTTP/JSON    ┌──────────────────┐    LLM API    ┌─────────────┐
│   Flutter App   │ ────────────► │  FastAPI Backend │ ───────────► │ Mistral LLM │
│   (Frontend)    │ ◄──────────── │    (Python)      │ ◄─────────── │   (AI/ML)   │
└─────────────────┘               └──────────────────┘               └─────────────┘
```

## � **Required Dependencies**

Before implementing the integration, ensure you have Dio added to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  dio: ^5.4.0 # Advanced HTTP client
  dio_retry_interceptor: ^1.0.0 # Retry functionality (optional)
```

```bash
# Add dependencies
flutter pub add dio dio_retry_interceptor
flutter pub get
```

## �🔧 **Integration Components**

### **1. API Configuration** (`lib/src/services/api_config.dart`)

```dart
import 'package:dio/dio.dart';
import 'package:dio_retry_interceptor/dio_retry_interceptor.dart';

class ApiConfig {
  // ⚠️ IMPORTANT: Update this for your environment
  static const String baseUrl = 'http://10.0.2.2:8000/api';  // Android Emulator

  // Dio instance with advanced configuration
  static Dio get dio {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30), // LLM calls can be slow
      sendTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add logging interceptor for debugging
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
      logPrint: (obj) => print('🌐 API: $obj'),
    ));

    // Add retry interceptor for failed requests
    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      retries: 3,
      retryDelays: const [
        Duration(seconds: 1),
        Duration(seconds: 2),
        Duration(seconds: 3),
      ],
    ));

    return dio;
  }
}
```

### **2. API Service Layer** (`lib/src/services/api_service.dart`)

```dart
import 'package:dio/dio.dart';
import 'api_config.dart';

class ApiService {
  static final Dio _dio = ApiConfig.dio;

  // 🆕 Generate business ideas with request cancellation
  static Future<Map<String, dynamic>> generateBusinessIdeas({
    required String skill,
    required String location,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        '/generate-business-ideas',
        data: {'skill': skill, 'location': location},
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // 🆕 Ingest documents
  static Future<Map<String, dynamic>> ingestDocument({
    required String content,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        '/ingest',
        data: {'content': content},
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // 🆕 Chat with the system
  static Future<Map<String, dynamic>> chat({
    required String message,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        '/chat',
        data: {'message': message},
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

// Enhanced error handling
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? type;

  ApiException(this.message, {this.statusCode, this.type});

  factory ApiException.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException('Connection timeout', type: 'timeout');
      case DioExceptionType.receiveTimeout:
        return ApiException('Response timeout', type: 'timeout');
      case DioExceptionType.sendTimeout:
        return ApiException('Request timeout', type: 'timeout');
      case DioExceptionType.cancel:
        return ApiException('Request was cancelled', type: 'cancelled');
      case DioExceptionType.connectionError:
        return ApiException('No internet connection', type: 'network');
      default:
        return ApiException(
          e.response?.data?['detail'] ?? 'Unknown error occurred',
          statusCode: e.response?.statusCode,
          type: 'server'
        );
    }
  }

  @override
  String toString() => message;
}
```

### **3. Data Models** (`lib/src/services/api_models.dart`)

Maps FastAPI response schemas to Dart classes:

```dart
// Request Models
class SkillMappingRequest {
  final String skill;
  final String location;
}

class IdeaEvaluationRequest {
  final String idea;
  final String location;
}

// Response Models
class SkillMappingResponse {
  final String introduction;
  final List<BusinessIdea> businessIdeas;
  final String conclusion;
}

class IdeaEvaluationResponse {
  final String summary;
  final String marketDemand;
  final String score;
  // ... more fields
}
```

### **4. UI Implementation** (`lib/src/screens/business_ideas_screen.dart`)

Example of using the enhanced API service with request cancellation:

```dart
class _BusinessIdeasScreenState extends State<BusinessIdeasScreen> {
  CancelToken? _cancelToken;

  @override
  void dispose() {
    _cancelToken?.cancel('Widget disposed');
    super.dispose();
  }

  Future<void> _generateIdeas() async {
    // Cancel previous request if still running
    _cancelToken?.cancel('New request started');
    _cancelToken = CancelToken();

    try {
      final response = await ApiService.generateBusinessIdeas(
        skill: _skillController.text,
        location: _locationController.text,
        cancelToken: _cancelToken,
      );

      // Process successful response
      setState(() {
        _businessIdeas = response['business_ideas'];
      });
    } on ApiException catch (e) {
      if (e.type != 'cancelled') {
        _showErrorDialog(e.message);
      }
    }
  }
}
```

## 🌐 **API Endpoints**

### **Backend Routes** (FastAPI)

| Endpoint                 | Method | Purpose                             | Request Body               | Response                                       |
| ------------------------ | ------ | ----------------------------------- | -------------------------- | ---------------------------------------------- |
| `/api/skill-to-business` | POST   | Generate business ideas from skills | `{skill, location}`        | `{introduction, business_ideas[], conclusion}` |
| `/api/validate-idea`     | POST   | Evaluate business idea              | `{idea, location}`         | `{summary, market_demand, score, ...}`         |
| `/api/generate-roadmap`  | POST   | Create business roadmap             | `{idea/idea_id, location}` | `{licenses, funding, timeline, ...}`           |

### **Request/Response Flow**

1. **Skill to Business Ideas**:

```json
// Request
POST /api/skill-to-business
{
  "skill": "Digital Marketing, Web Development",
  "location": "India"
}

// Response
{
  "response": {
    "introduction": "Based on your skills...",
    "business_ideas": [
      {
        "id": "idea_1",
        "title": "Digital Marketing Agency",
        "description": "Start a full-service digital marketing agency..."
      }
    ],
    "conclusion": "These ideas leverage your expertise..."
  }
}
```

2. **Idea Validation**:

```json
// Request
POST /api/validate-idea
{
  "idea": "AI-powered food delivery app for small cities",
  "location": "India"
}

// Response
{
  "response": {
    "summary": "This is a promising business idea...",
    "market_demand": "High demand in tier-2 cities...",
    "score": "8.5",
    "suggestions": "Focus on local partnerships...",
    // ... more evaluation fields
  }
}
```

## 🔄 **Integration Patterns**

### **1. Loading States**

```dart
class _BusinessIdeasScreenState extends State<BusinessIdeasScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _response;
  CancelToken? _cancelToken;

  void _generateBusinessIdeas() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Cancel previous request if still running
    _cancelToken?.cancel('New request started');
    _cancelToken = CancelToken();

    try {
      final response = await ApiService.generateBusinessIdeas(
        skill: skillsText,
        location: 'India',
        cancelToken: _cancelToken,
      );

      setState(() {
        _response = response;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      if (e.type != 'cancelled') {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to generate ideas: ${e.message}';
        });
      }
    }
  }
}
```

### **2. Error Handling**

```dart
// Enhanced error handling with Dio
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? type;

  ApiException(this.message, {this.statusCode, this.type});

  factory ApiException.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException('Connection timeout', type: 'timeout');
      case DioExceptionType.receiveTimeout:
        return ApiException('Response timeout', type: 'timeout');
      case DioExceptionType.sendTimeout:
        return ApiException('Request timeout', type: 'timeout');
      case DioExceptionType.cancel:
        return ApiException('Request was cancelled', type: 'cancelled');
      case DioExceptionType.connectionError:
        return ApiException('No internet connection', type: 'network');
      default:
        return ApiException(
          e.response?.data?['detail'] ?? 'Unknown error occurred',
          statusCode: e.response?.statusCode,
          type: 'server'
        );
    }
  }
}

// In API service - Dio implementation
try {
  final response = await _dio.post('/generate-business-ideas', data: data);
  return response.data;
} on DioException catch (e) {
  throw ApiException.fromDioException(e);
}
```

### **3. UI Integration**

```dart
// Conditional rendering based on API state
if (_isLoading) ...[
  CircularProgressIndicator(),
] else if (_errorMessage != null) ...[
  ErrorWidget(
    message: _errorMessage!,
    onRetry: _generateBusinessIdeas,
  ),
] else if (_response != null) ...[
  ListView.builder(
    itemCount: _response!.businessIdeas.length,
    itemBuilder: (context, index) {
      final idea = _response!.businessIdeas[index];
      return BusinessIdeaCard(idea: idea);
    },
  ),
],
```

## 🛠️ **Setup Instructions**

### **Step 1: Backend Setup**

```bash
# Navigate to backend directory
cd udyog-mitra-backend

# Install dependencies
pip install -r requirements.txt

# Start FastAPI server
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### **Step 2: Flutter Setup**

```bash
# Navigate to Flutter app
cd udyog-mitra/app

# Add Dio dependency to pubspec.yaml
flutter pub add dio

# Optional: Add dio_retry_interceptor for retry functionality
flutter pub add dio_retry_interceptor

# Get dependencies
flutter pub get

# Update API base URL in lib/src/services/api_config.dart
# For Android Emulator: http://10.0.2.2:8000/api
# For iOS Simulator: http://localhost:8000/api
# For Physical Device: http://YOUR_COMPUTER_IP:8000/api

# Run the app
flutter run
```

#### **Required Dependencies in pubspec.yaml:**

```yaml
dependencies:
  flutter:
    sdk: flutter
  dio: ^5.4.0 # HTTP client with advanced features
  dio_retry_interceptor: ^1.0.0 # Optional: For retry functionality
```

### **Step 3: Network Configuration**

#### **For Android Emulator:**

```dart
static const String baseUrl = 'http://10.0.2.2:8000/api';
```

#### **For iOS Simulator:**

```dart
static const String baseUrl = 'http://localhost:8000/api';
```

#### **For Physical Device:**

```bash
# Find your computer's IP
# Windows: ipconfig
# macOS/Linux: ifconfig

# Update baseUrl with your IP
static const String baseUrl = 'http://192.168.1.100:8000/api';
```

## 🔍 **Troubleshooting**

### **Common Issues:**

1. **Connection Refused Error**

   - **Problem**: Flutter can't reach the backend
   - **Solution**: Update API base URL to use correct IP address
   - **Check**: Ensure backend server is running on `0.0.0.0:8000`

2. **Timeout Errors**

   - **Problem**: API calls taking too long
   - **Solution**: Increase timeout in HTTP client or optimize backend
   - **Check**: Backend logs for slow LLM responses

3. **CORS Issues** (Web only)

   - **Problem**: Browser blocking cross-origin requests
   - **Solution**: Configure CORS in FastAPI backend

   ```python
   from fastapi.middleware.cors import CORSMiddleware

   app.add_middleware(
       CORSMiddleware,
       allow_origins=["*"],
       allow_methods=["*"],
       allow_headers=["*"],
   )
   ```

4. **JSON Parsing Errors**
   - **Problem**: Response format mismatch
   - **Solution**: Verify API response structure matches data models
   - **Check**: Backend response format and Flutter model definitions

### **Debug Tips:**

1. **Enable Dio Logging:**

```dart
import 'dart:developer' as developer;

// Dio already has built-in logging via LogInterceptor
// Additional custom logging can be added:
dio.interceptors.add(InterceptorsWrapper(
  onRequest: (options, handler) {
    developer.log('🚀 REQUEST: ${options.method} ${options.path}');
    developer.log('📦 DATA: ${options.data}');
    handler.next(options);
  },
  onResponse: (response, handler) {
    developer.log('✅ RESPONSE: ${response.statusCode}');
    developer.log('📄 DATA: ${response.data}');
    handler.next(response);
  },
  onError: (error, handler) {
    developer.log('❌ ERROR: ${error.message}');
    handler.next(error);
  },
));
```

2. **Test API Endpoints:**

```bash
# Test backend directly
curl -X POST http://localhost:8000/api/skill-to-business \
  -H "Content-Type: application/json" \
  -d '{"skill": "Programming", "location": "India"}'
```

3. **Check Network Connectivity with Dio:**

```dart
// Add to Flutter app for debugging
void _testConnection() async {
  try {
    final response = await ApiConfig.dio.get('/health');
    print('Connection successful: ${response.statusCode}');
  } on DioException catch (e) {
    print('Connection failed: ${e.message}');
  }
}
```

## 📱 **Platform-Specific Considerations**

### **Android**

- Use `10.0.2.2` for localhost mapping in emulator
- Add network permissions in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

### **iOS**

- Use `localhost` in simulator
- Add network configuration in `ios/Runner/Info.plist` for HTTP:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

### **Web**

- Use full URL with domain/IP
- Ensure CORS is properly configured in backend

## 📈 **Performance Optimization**

1. **Response Caching**: Cache API responses for repeated requests
2. **Request Debouncing**: Avoid rapid API calls during user input
3. **Pagination**: Implement pagination for large result sets
4. **Connection Pooling**: Reuse HTTP connections
5. **Error Retry Logic**: Implement exponential backoff for failed requests

## 🔐 **Security Considerations**

1. **API Authentication**: Add bearer tokens or API keys
2. **Request Validation**: Validate all inputs before API calls
3. **HTTPS**: Use HTTPS in production
4. **Rate Limiting**: Implement rate limiting on backend
5. **Input Sanitization**: Sanitize user inputs to prevent injection

---

## 📋 **Quick Reference**

### **API Base URLs**

- **Development**: `http://localhost:8000/api`
- **Android Emulator**: `http://10.0.2.2:8000/api`
- **Physical Device**: `http://YOUR_IP:8000/api`
- **Production**: `https://your-domain.com/api`

### **Key Files**

- `api_config.dart`: API configuration and base URLs
- `api_models.dart`: Request/response data models
- `api_service.dart`: HTTP service layer
- `business_ideas_screen.dart`: Skill-to-business integration
- `idea_evaluator_screen.dart`: Idea validation integration

### **Testing Commands**

```bash
# Start backend
uvicorn main:app --reload --host 0.0.0.0 --port 8000

# Run Flutter
flutter run --debug

# Test API
curl -X POST http://localhost:8000/api/skill-to-business \
  -H "Content-Type: application/json" \
  -d '{"skill": "test", "location": "India"}'
```

This integration provides a seamless connection between the Flutter frontend and FastAPI backend, enabling real-time AI-powered business recommendations and evaluations.
