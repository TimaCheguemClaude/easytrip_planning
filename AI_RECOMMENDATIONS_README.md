# AI Travel Recommendations Feature

A complete Flutter feature for tourism apps that provides AI-powered travel recommendations using Google's Gemini API.

## Features

✅ **Local Dataset**: Mock touristic sites with comprehensive data
✅ **User Input Dialog**: Clean form for trip preferences
✅ **AI Integration**: Google Gemini API for intelligent recommendations
✅ **Smart Recommendations**: JSON parsing with fallback handling
✅ **Save Functionality**: Local storage for favorite recommendations
✅ **Booking Flow**: Complete booking workflow with form validation
✅ **Error Handling**: Robust error handling and user feedback
✅ **Modern UI**: Material Design 3 with smooth animations

## Quick Start

### Option 1: Standalone Example App
For a quick demo, use the standalone example:

```bash
# Copy the example file content to your main.dart
cp example_ai_recommendations_app.dart lib/main.dart

# Run the app
flutter run
```

### Option 2: Integration with Existing App

1. **Add Dependencies**
```yaml
dependencies:
  google_generative_ai: ^0.4.6
  shared_preferences: ^2.5.3
```

2. **Copy Files**
```bash
# Copy all the feature files to your project
lib/
├── data/
│   ├── model/touristic_site.dart
│   └── touristic_sites_dataset.dart
├── services/
│   ├── gemini_service.dart
│   └── storage_service.dart
└── presentation/
    ├── screens/
    │   ├── ai_recommendations_screen.dart
    │   └── booking_screen.dart
    └── widgets/
        ├── trip_input_dialog.dart
        └── recommendation_card.dart
```

3. **Setup Gemini API**
```dart
// In lib/services/gemini_service.dart
static const String _apiKey = 'YOUR_ACTUAL_GEMINI_API_KEY';
```

4. **Add to Navigation**
```dart
// Add to your main screen or navigation
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const AIRecommendationsScreen(),
  ),
);
```

## API Key Setup

1. Get your Gemini API key from [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Replace `YOUR_GEMINI_API_KEY` in `lib/services/gemini_service.dart`
3. For production, use environment variables or secure storage

## Dataset Structure

The feature includes a comprehensive dataset with:

```dart
TouristicSite(
  title: 'Site Name',
  city: 'City Name',
  activities: ['Activity1', 'Activity2'],
  price: 25000, // Price in CFA
  image: 'assets/image.jpg',
  description: 'Detailed description...',
)
```

**Included Cities**: Douala, Yaounde, Kribi, Limbe, Buea, Bamenda
**Activity Types**: Museum Tours, Beach Relaxation, Hiking, Cultural Learning, etc.

## User Flow

1. **Input**: User taps FAB → Opens preference dialog
2. **Processing**: Sends preferences + dataset to Gemini API
3. **Results**: Displays 3 AI-recommended sites with reasons
4. **Actions**: User can save recommendations or book trips
5. **Booking**: Complete booking form with validation

## AI Prompt Engineering

The feature uses a carefully crafted prompt that:
- Provides the complete dataset to Gemini
- Includes user preferences (budget, city, people, activity)
- Enforces JSON response format
- Limits to exactly 3 recommendations
- Requires reasoning for each recommendation

## Error Handling

- **API Failures**: Falls back to local mock recommendations
- **JSON Parsing**: Graceful handling of malformed responses
- **Network Issues**: User-friendly error messages
- **Validation**: Form validation with helpful error messages

## Customization

### Adding New Sites
```dart
// In lib/data/touristic_sites_dataset.dart
TouristicSite(
  title: 'Your New Site',
  city: 'Your City',
  activities: ['Your Activities'],
  price: 30000,
  image: 'assets/your_image.jpg',
  description: 'Your description...',
)
```

### Modifying UI Theme
```dart
// The feature respects your app's theme
Theme.of(context).primaryColor // Used throughout
```

### Custom Activities
```dart
// Add new activities to any site's activities list
activities: ['Custom Activity', 'Another Activity']
```

## File Structure

```
lib/
├── data/
│   ├── model/
│   │   └── touristic_site.dart          # Data models
│   └── touristic_sites_dataset.dart     # Mock dataset
├── services/
│   ├── gemini_service.dart              # AI integration
│   └── storage_service.dart             # Local storage
└── presentation/
    ├── screens/
    │   ├── ai_recommendations_screen.dart # Main screen
    │   └── booking_screen.dart           # Booking flow
    └── widgets/
        ├── trip_input_dialog.dart        # Input form
        └── recommendation_card.dart      # Recommendation UI
```

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_generative_ai: ^0.4.6  # Gemini AI integration
  shared_preferences: ^2.5.3    # Local storage
  # Your existing dependencies...
```

## Screenshots & Demo

The feature includes:
- 🎯 Smart input dialog with dropdowns and validation
- 🤖 AI-powered recommendations with reasoning
- 💾 Save/remove functionality with local storage
- 📱 Responsive cards with images and actions
- ✈️ Complete booking flow with confirmation
- 🔄 Loading states and error handling

## Production Considerations

1. **API Key Security**: Use environment variables
2. **Image Optimization**: Optimize asset images for production
3. **Caching**: Implement recommendation caching
4. **Analytics**: Add analytics for user interactions
5. **Testing**: Add unit tests for services and widgets
6. **Localization**: Add multi-language support

## Support

This feature is designed to be:
- ✅ **Production Ready**: Robust error handling and validation
- ✅ **Customizable**: Easy to modify and extend
- ✅ **Well Documented**: Clear code structure and comments
- ✅ **Modern**: Uses latest Flutter and Material Design patterns

For questions or customization needs, refer to the inline code documentation.
