# Flip Clock

A customizable, mechanical-style flip clock application built with Flutter. Transform any device into a beautiful, functional timepiece with extensive customization options and a premium user experience.

## 🎯 Core Features

### Time Display
- **Realistic Flip Animation**: Accurately mimics the motion of a physical mechanical flip clock with smooth 60fps transitions
- **Large, Easy-to-Read Digits**: Perfect for any room or environment
- **Optional Seconds Display**: Toggle precision timing on/off
- **12/24 Hour Format**: Choose your preferred time format

## 🎨 Extensive Customization

### Visual Personalization
- **10+ Google Fonts**: Choose from modern to retro typography for both digits and date
- **Full Color Control**: Customize digit colors, background colors, and accent elements
- **Colon Dots Styling**: Adjust separator colors to match your aesthetic
- **Adjustable Font Sizes**: Scale digits (40-120px) and date (10-36px) for perfect visibility

### Background System
- **Image Background Support**: Use personal photos as clock backdrop
- **Smart Image Fitting**: Cover (full screen) or Contain (show full image) modes
- **Color Backgrounds**: Extensive color picker for solid backgrounds
- **Seamless Integration**: Background works perfectly with all clock elements

### Typography & Layout
- **Digit Font Selection**: Choose from 10+ Google Fonts for time display
- **Date Font Selection**: Separate font control for date display
- **Custom Date Formats**: Multiple professional date patterns
- **Perfect Vertical Centering**: Digits centered perfectly regardless of font choice

## 📱 Smart User Experience

### Intuitive Interface
- **Touch-to-Show Settings**: Clean interface with auto-hide controls
- **Smooth Animations**: Professional fade transitions and micro-interactions
- **Immersive Mode**: Settings disappear after 5 seconds for distraction-free viewing
- **One-Tap Access**: Simple screen tap reveals controls when needed

### Smart Controls
- **Auto-Dim Functionality**: Button dims to 50% opacity after appearing
- **Auto-Hide Timer**: Button disappears after 5 seconds of inactivity
- **Touch Prevention**: IgnorePointer prevents accidental taps when hidden
- **Timer Reset**: Auto-hide timer resets when settings menu is closed

## ⚙️ Additional Features

### Audio & Animation
- **Flip Sound Effects**: Realistic mechanical flip sounds (Linux/ALSA support)
- **Toggle Animations**: Enable/disable flip animations for static display
- **Sound Toggle**: Mute/unmute flip sounds as needed

### Performance & Quality
- **Smooth 60fps Animations**: Hardware-accelerated flip transitions
- **Optimized Performance**: Minimal battery usage
- **Responsive Design**: Works on all screen sizes and orientations
- **Persistent Settings**: All preferences save automatically

## 🏆 Perfect For

- **Home Offices**: Elegant desk clock for professional environments
- **Bedrooms**: Soft, readable display for nightstands  
- **Living Rooms**: Stylish wall clock replacement
- **Kitchens**: Clean time display while cooking
- **Study Spaces**: Minimalist focus timer

## 💎 Premium Differentiators

- **Retro-Modern Fusion**: Classic flip clock with contemporary customization
- **Zero Distraction Design**: Auto-hide interface for pure time display
- **Professional Polish**: Smooth animations and thoughtful micro-interactions
- **Complete Personalization**: Every visual element is customizable
- **Smart UX**: Intuitive touch controls that stay out of your way

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

### Key Technologies
- **Flutter**: Cross-platform UI framework
- **Google Fonts**: Extensive typography options
- **Image Picker**: Background image selection
- **Shared Preferences**: Persistent settings storage
- **Animation Controllers**: Smooth flip transitions

## License

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

### What This Means

**✅ What you CAN do:**
- Use this app for free
- Modify and improve the code
- Distribute your versions
- Use it commercially (but must share your code changes)

**❌ What you CANNOT do:**
- Make closed-source modifications
- Hide your improvements
- Use this code without proper attribution
- Remove copyright notices

**🤝 Contributing:**
Any modifications must be shared under the same GPL v3 license, ensuring the community benefits from improvements.

## ☕ Support Development

If you enjoy this flip clock app and want to support its continued development, consider buying me a coffee!

<a href='https://ko-fi.com/R5R11TOYR8' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://storage.ko-fi.com/cdn/kofi2.png?v=6' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

Your support helps maintain and improve the app with new features and bug fixes.
