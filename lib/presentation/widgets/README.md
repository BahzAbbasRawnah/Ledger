# Reusable Widgets and Styles

This directory contains reusable widgets and styles for the app. These components are designed to be used across the app to maintain consistency and reduce code duplication.

## How to Use

Import the barrel file to access all reusable widgets:

```dart
import 'package:your_app_name/presentation/widgets/app_widgets.dart';
```

## Available Components

### Text Widgets

- `LargeText`: For headings (24px, bold)
- `MediumText`: For subheadings (18px, semi-bold)
- `SmallText`: For regular content (14px, normal)
- `ExtraSmallText`: For captions and hints (12px, normal)

Example:
```dart
LargeText(
  'Heading Text',
  color: Colors.black,
  textAlign: TextAlign.center,
)
```

### Container Widgets

- `RoundedContainer`: A container with rounded corners and optional border
- `CardContainer`: A card-like container with shadow
- `HeaderContainer`: A container for table or section headers
- `FooterContainer`: A container for table or section footers
- `SectionContainer`: A container with header, content, and optional footer

Example:
```dart
CardContainer(
  padding: AppStyles.mediumPadding,
  child: Column(
    children: [
      LargeText('Card Title'),
      SmallText('Card content goes here'),
    ],
  ),
)
```

### Other Widgets

- `CustomButton`: A reusable button with consistent styling
- `CustomTextField`: A reusable text field with consistent styling
- `DashboardCard`: A card for dashboard items
- `EmptyWidget`: A widget to display when a list is empty

## Styles

The app also includes reusable styles in `lib/core/theme/app_styles.dart`:

- Text styles: `largeText()`, `mediumText()`, `smallText()`, `extraSmallText()`
- Container decorations: `roundedContainerDecoration()`, `cardDecoration()`, `headerDecoration()`, `footerDecoration()`
- Common paddings: `smallPadding`, `mediumPadding`, `largePadding`, etc.

Example:
```dart
Text(
  'Styled text',
  style: AppStyles.mediumText(
    color: AppTheme.primaryColor,
    fontWeight: FontWeight.bold,
  ),
)
```

## Best Practices

1. Always use these reusable components instead of creating new ones
2. If you need a new style or widget, add it to the appropriate file
3. Keep the components simple and focused on a single responsibility
4. Use the barrel file (`app_widgets.dart`) for imports to reduce import statements
5. Follow the naming conventions for consistency
