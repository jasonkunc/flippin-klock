# Flip Clock

A customizable, mechanical-style flip clock application built with Flutter.

## Features

- **Realistic Flip Animation**: Accurately mimics the motion of a physical mechanical flip clock.
- **Color Customization**: Customize background, digit background, digit text, and date color.
- **Typography Selection**: Choose from various Google Fonts for the date display.
- **Custom Date Format**: Support for custom date formatting patterns (e.g., `MM/dd/yyyy`).
- **Toggles**:
  - 12/24-hour time format.
  - Show/hide seconds.
  - Enable/disable flip animation.
  - Enable/disable flip sound effects.
- **Responsive Layout**: Digits and date text scale proportionally to fit different screen sizes.

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Android Studio / VS Code with Flutter extension
- (Linux) `aplay` utility for sound effects

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/jasonkunc/flip-clock.git
   ```
2. Navigate to the project directory:
   ```bash
   cd flip-clock
   ```
3. Get dependencies:
   ```bash
   flutter pub get
   ```
4. Run the application:
   ```bash
   flutter run
   ```

## Development

This project was developed with a focus on smooth 3D animations and high customizability. The flip animation uses `Transform` and `AnimationController` to handle the 180-degree rotation of the digit flaps.
