# Flame Portfolio

This project is a web portfolio built using Dart and the Flame game engine. It showcases various projects and provides information about the portfolio owner. The application is structured to utilize the Flame engine for rendering and game logic, making it interactive and visually appealing.

## Project Structure

```
flame-portfolio
├── lib
│   ├── main.dart                  # Entry point of the application
│   ├── components                 # Contains reusable components
│   │   ├── background.dart        # Background rendering logic
│   │   ├── navigation.dart        # Navigation bar management
│   │   └── portfolio_item.dart    # Individual portfolio item representation
│   ├── screens                    # Different screens of the portfolio
│   │   ├── home_screen.dart       # Main landing page
│   │   ├── about_screen.dart      # About the portfolio owner
│   │   ├── projects_screen.dart    # Showcases projects
│   │   └── contact_screen.dart     # Contact information and form
│   ├── game                       # Game-related logic
│   │   ├── portfolio_game.dart    # Main game class managing state and rendering
│   │   └── game_world.dart        # Game world logic and interactions
│   └── utils                      # Utility functions and constants
│       ├── constants.dart         # Application constants
│       └── helpers.dart           # Helper functions
├── web
│   ├── index.html                 # Main HTML file
│   ├── manifest.json              # Web application metadata
│   └── favicon.ico                # Favicon for the web application
├── assets
│   ├── images                     # Image assets
│   └── fonts                      # Font assets
├── pubspec.yaml                   # Dart and Flutter configuration
└── README.md                      # Project documentation
```

## Setup Instructions

1. **Clone the repository**:
   ```
   git clone <repository-url>
   cd flame-portfolio
   ```

2. **Install dependencies**:
   ```
   dart pub get
   ```

3. **Run the application**:
   ```
   dart run
   ```

4. **Open the web application**:
   Navigate to `http://localhost:8080` in your web browser.

## Features

- Interactive portfolio showcasing various projects.
- Smooth animations and transitions powered by the Flame game engine.
- Responsive design for optimal viewing on different devices.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.