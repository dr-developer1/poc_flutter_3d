# 🌌 Solar System Explorer

An interactive 3D solar system explorer built with Flutter. Explore all planets, moons, and asteroids with scientifically accurate data, beautiful 3D models, and real-time orbital animations.

![Flutter](https://img.shields.io/badge/Flutter-3.9.2+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.9.2+-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-Educational-green)

## ✨ Features

### Core Features
- **Complete Solar System**: View the Sun, all 8 planets, Earth's Moon, and 5 asteroids
- **Dual View Modes**:
  - **3D Model View**: Inspect high-quality GLB models with rotation and zoom
  - **Orbital View**: Watch all planets orbit the sun in real-time animation
- **Interactive Navigation**: Tap to select and explore different celestial bodies
- **Scientific Data**: 
  - Relative sizes (compared to Earth)
  - Distance from Sun (in AU)
  - Orbital speeds (km/s)
  - 38+ interesting facts

### Advanced Features
- **Time Control System**: 
  - Adjust animation speed (1x to 100x)
  - Play/pause orbital motion
  - Quick speed presets (1x, 10x, 50x, 100x)
- **Search Functionality**: Find planets quickly by name
- **Comparison Mode**: Compare two planets side-by-side with:
  - Visual size comparison bars
  - Statistics table
  - Facts comparison
- **Beautiful UI**: 
  - Dark space-themed interface
  - Custom gradients and glow effects
  - Color-coded planet elements
  - Smooth animated transitions
- **Responsive Design**: Works on Android, iOS, and emulators

## 📁 Project Structure

```
lib/
├── main.dart                              # App entry point
├── models/
│   └── planet.dart                        # CelestialBody data model
├── data/
│   └── solar_system_data.dart            # Solar system data repository
├── screens/
│   ├── solar_system_explorer_screen.dart # Main exploration screen
│   └── comparison_screen.dart            # Planet comparison screen
└── widgets/
    ├── celestial_body_3d_widget.dart     # 3D viewer component
    ├── orbital_system_view.dart          # 2D orbital animation
    └── time_control_widget.dart          # Time control UI
```

## 🏗️ Architecture & Best Practices

### Data Layer
- **Immutable Models**: `CelestialBody` class with `const` constructor
- **Centralized Data**: All solar system data in `SolarSystemData` repository
- **Type Safety**: Enum for `CelestialBodyType` (star, planet, moon, asteroid)
- **Scientific Accuracy**: Real relative sizes, distances, and orbital speeds

### UI Layer
- **Component-Based**: Reusable `CelestialBody3DWidget` 
- **State Management**: Clean StatefulWidget with proper lifecycle
- **Separation of Concerns**: Screen handles UI, widget handles 3D rendering
- **Responsive Layout**: Flexible column layout with scrollable content

### Code Quality
- **Null Safety**: Full null-safety support
- **Documentation**: Comprehensive dartdoc comments
- **Error Handling**: Proper error callbacks and user feedback
- **Resource Management**: Proper dispose patterns
- **Zero Warnings**: All deprecation warnings fixed

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.9.2)
- Android Studio / Xcode (for mobile development)
- Android Emulator or iOS Simulator

### Installation

1. Clone the repository:
```bash
git clone https://github.com/dr-developer1/poc_flutter_3d.git
cd solar_system_explorer
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Android Configuration

The app requires network permissions for the 3D viewer. These are already configured:

**AndroidManifest.xml:**
- `INTERNET` permission for loading 3D models
- Network security config for localhost access (required for flutter_3d_controller)

## 🎮 How to Use

### Getting Started
1. **Launch the app** - Opens with Sun in 3D model view
2. **Select planets** - Scroll the bottom bar and tap to select
3. **3D Model View**:
   - Drag to rotate the model
   - Pinch to zoom in/out
   - Read facts and data below

### Orbital View
1. **Switch views** - Tap the 🌍 icon in the app bar
2. **Watch orbits** - See all planets orbiting the sun in real-time
3. **Control time**:
   - Adjust slider for speed (1x to 100x)
   - Tap play/pause button
   - Use preset buttons for quick changes
4. **Tap planets** - Select planets directly from the orbital view

### Search & Compare
1. **Search** - Tap 🔍 icon and search for planets by name
2. **Compare** - Tap comparison icon to compare two planets:
   - View size differences visually
   - Compare statistics side-by-side
   - Read facts for both planets

## 📦 Dependencies

```yaml
dependencies:
  flutter_3d_controller: ^2.3.0  # For displaying 3D GLB models
```

## 🌍 Celestial Bodies Included

### Star
- ☀️ **Sun** - Our star and center of the solar system

### Inner Planets (Rocky)
- ☿️ **Mercury** - Smallest planet, extreme temperatures
- ♀️ **Venus** - Hottest planet, thick atmosphere
- 🌍 **Earth** - Our home, only known planet with life
- ♂️ **Mars** - The Red Planet, has Olympus Mons

### Outer Planets (Gas Giants)
- ♃ **Jupiter** - Largest planet, Great Red Spot storm
- ♄ **Saturn** - Beautiful ring system
- ♅ **Uranus** - Rotates on its side
- ♆ **Neptune** - Farthest planet, strongest winds

### Moons
- 🌙 **Moon** - Earth's natural satellite

### Asteroids
- 🪨 5 asteroids from the asteroid belt between Mars and Jupiter

## 🔬 Scientific Accuracy

All data is based on real astronomical measurements:
- **Sizes**: Relative to Earth's diameter (Earth = 1.0)
- **Distances**: In Astronomical Units (1 AU = Earth-Sun distance)
- **Orbital Speeds**: In kilometers per second

## 🎨 Design Features

- **Space-themed Gradient**: Deep blue-black gradient background
- **Color-coded Bodies**: Each celestial body has its characteristic color
- **Smooth Animations**: 60 FPS animations with AnimationController
- **Glow Effects**: Selection glows using RadialGradient shaders
- **Responsive Cards**: Information cards with facts and data
- **Icon System**: Custom icons for each body type

## � Technical Specifications

- **Total Lines of Code**: 2,200+
- **Dart Files**: 9
- **Celestial Bodies**: 15 (1 star, 8 planets, 1 moon, 5 asteroids)
- **Facts Database**: 38+ educational facts
- **Animation Speeds**: 1x - 100x with non-linear slider
- **View Modes**: 2 (3D Model, Orbital)
- **Code Quality**: 0 warnings, 0 errors

## �🔧 Troubleshooting

### 3D Model not loading on Android
- Ensure `INTERNET` permission is in AndroidManifest.xml
- Verify network security config allows cleartext for localhost
- Check that asset paths are correct in pubspec.yaml

### Performance Issues
- Test on a physical device rather than emulator
- Ensure device supports WebGL for 3D rendering
- Check available memory for 3D model loading

### Build Errors
```bash
flutter clean
flutter pub get
flutter run
```

## 📝 Future Enhancements

Potential features for future versions:
- [ ] AR mode for viewing planets in real world
- [ ] Quiz mode to test knowledge
- [ ] Haptic feedback for interactions
- [ ] Sound effects for selections
- [ ] More moons (Europa, Titan, Ganymede)
- [ ] Dwarf planets (Pluto, Ceres, Eris)
- [ ] Comet tracking
- [ ] Historical planetary positions
- [ ] Space mission trajectories

## 📚 Documentation

Additional documentation available:
- `ARCHITECTURE.md` - Detailed system architecture
- `DEVELOPER_GUIDE.md` - Quick developer reference
- `IMPLEMENTATION_SUMMARY.md` - Implementation metrics
- `PHASES_4-7_COMPLETE.md` - Feature completion details

## 🤝 Contributing

This is an educational project. Feel free to fork and experiment!

## 📄 License

This project is for educational purposes.

## 🙏 Acknowledgments

- **3D Models**: GLB format planetary models
- **Scientific Data**: NASA and JPL
- **Flutter Package**: [flutter_3d_controller](https://pub.dev/packages/flutter_3d_controller)
- **Inspiration**: The beauty of our solar system

## 📬 Contact

- **Repository**: [poc_flutter_3d](https://github.com/dr-developer1/poc_flutter_3d)
- **Issues**: Report bugs or request features via GitHub Issues

---

**Built with ❤️ using Flutter**

*Explore the cosmos from your pocket!* 🚀

---

### 📸 Screenshots

> Add screenshots here to showcase the app's features

### 🎬 Demo

> Add video demo or GIF here

---

**Made by dr-developer1** | **October 2025**

