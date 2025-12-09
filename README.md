# Friends Puzzle Game

<div align="center">
  <!-- 
    PLACEHOLDER FOR IMAGES 
    Please upload your screenshots to the 'assets/images/' folder 
    and rename them to 'screenshot1.png' and 'screenshot2.png' 
    or update the paths below.
  -->
  <img src="assets/images/screenshot1.png" alt="Game Screenshot 1" width="45%" />
  <img src="assets/images/screenshot2.png" alt="Game Screenshot 2" width="45%" />
</div>

<br />

## 🎮 Overview

**Friends Puzzle Game** is a professionally crafted jigsaw puzzle application built with Flutter. Designed to provide an engaging and educational experience for children, the game features realistic puzzle mechanics, smooth animations, and a fully localized Arabic interface.

The project demonstrates advanced Flutter capabilities including custom painting, complex path clipping (Bezier curves), and precise gesture handling.

## ✨ Key Features

- **🧩 Realistic Jigsaw Engine**: 
  - Uses `CustomClipper<Path>` to generate procedurally interlocking puzzle pieces.
  - Deterministic logic ensures tabs and blanks fit perfectly every time.
  
- **👆 Interactive Drag & Drop**:
  - Smooth draggable pieces with scaling effects during interaction.
  - "Snap-to-grid" logic with tolerance zones.

- **🎨 Visual Feedback System**:
  - Immediate visual cues for correct (Green Checkmark) and incorrect (Red Cross) placements.
  - Animated feedback overlays that appear *above* the puzzle pieces.

- **🌍 Localization**:
  - Native Arabic support (`ar` locale) with RTL layout optimization.
  
- **📱 Responsive Layout**:
  - Adaptive design that supports both Portrait and Landscape orientations.

## 🛠️ Technical Stack

- **Framework**: Flutter (Dart)
- **Rendering**: `CustomPainter`, `CustomClipper`, `Stack`, `Positioned`
- **State Management**: `StatefulWidget` (Local State)
- **Assets**: Custom asset management for puzzle images.

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (Latest Stable)
- Dart SDK

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/prog-hussain5/puzzel_flutter_game.git
   cd puzzel_flutter_game
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

## 📂 Project Structure

```
lib/
└── main.dart          # Core application logic, UI, and Puzzle Engine
assets/
└── images/            # Game assets (puzzle images)
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
