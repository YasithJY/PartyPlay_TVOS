# PartyPlay TV — Your Living Room Game Show
**Module:** SE4041 Mobile Application Design and Development (MADD)  
**Assignment:** Assignment 02 – Part B: Native Apple tvOS Application  
**Student ID:** IT22136374  
**Target Environment:** Xcode 15.2 • macOS Ventura/Sonoma • Swift 5.9 • tvOS 17 SDK  
**Platform Architecture:** Apple TV 4K & HD (10-foot UI / Siri Remote Focus Engine)  

---

## 1. Project Overview & Concept
**PartyPlay TV** transforms an Apple TV into a high-energy, interactive multiplayer game-show stage right in the living room. Inspired by party gaming staples like Jackbox Games, Kahoot!, and classic television game shows, PartyPlay TV solves the social friction of traditional board games and split-screen video games:
- The **television acts as the broadcast host screen**, rendering vivid category themes, synchronized countdown clocks, real-time question prompts, and celebratory podium rankings.
- **Universal Siri Remote Interaction:** Fully operable directly from the living room couch with arrow/clickpad focus controls and smooth parallax card scaling.
- **Dual-Mode Architecture (Offline Demo & Phone Companion Ready):** Operates 100% offline out-of-the-box with bundled trivia and simulated bot participants, while providing a CoreImage-rendered QR code and room code system for smartphone companion controllers.

---

## 2. Key Features
1. **Curated Multi-Category Trivia:**
   - 42 bundled, fully validated trivia questions across 6 distinctive categories:
     - *General Knowledge*, *Science & Technology*, *Movies & Entertainment*, *Gaming*, *Sri Lanka Quiz* (heritage, history & sports), and *Kids & Family*.
   - Filterable by difficulty (*Easy [100 pts]*, *Medium [200 pts]*, *Hard [300 pts]*, and *All Difficulties*).
2. **Interactive Game Engine & Scoring:**
   - Real-time countdown timer with color warnings (cyan → amber → red) and pulse animations.
   - Dynamic scoring policy awarding base difficulty points plus up to 50% extra speed bonuses for rapid responses.
   - Prevention of duplicate submissions and automatic time-out handling.
   - Tie-resolved leaderboard generation ranking players by total points, correct answers, and accuracy percentage.
3. **Simulated Party Lobby (Offline First):**
   - 6-character room code generation (e.g., `PLAY88`).
   - Dynamic CoreImage QR code generator encoding companion join URLs.
   - Simulated AI bot participants ("Kasun", "Nethmi", "Shenal", etc.) with distinct avatars and ready indicators.
4. **tvOS Focus & 10-Foot Design System:**
   - Built specifically for the Siri Remote using `@FocusState`, custom `ButtonStyle`, and `FocusableGameCard`.
   - Rich dark charcoal aesthetic with electric purple (`#7C4DFF`), vivid blue, neon cyan, and amber gold accents.
   - Television-calibrated typography readable from several meters away.
   - Smooth focus lift scaling (1.05x–1.08x) and glowing cyan borders.
5. **Local Persistence:**
   - `UserDefaults` for lightweight user preferences (sound effects, reduced motion, default timers).
   - Application Support JSON storage (`game_history.json`) persisting completed match results and high scores.
6. **Full Accessibility & Settings:**
   - Reduce motion toggle, high contrast border enhancement, and storage reset.

---

## 3. Project Architecture & File Structure

PartyPlay TV adheres strictly to the **MVVM (Model-View-ViewModel)** architectural pattern with centralized Dependency Injection via `AppContainer`.

```
PartyPlayTV/
├── PartyPlayTV.xcodeproj/            # Native Xcode 15.2 project
├── PartyPlayTV/
│   ├── App/
│   │   ├── PartyPlayTVApp.swift      # Main @main entry point & NavigationStack
│   │   └── AppContainer.swift        # Central singleton container & DI
│   ├── Core/
│   │   ├── Theme/
│   │   │   ├── AppColors.swift       # Color palette, gradients & hex parser
│   │   │   ├── AppTypography.swift   # 10-foot viewing distance fonts
│   │   │   └── AppSpacing.swift      # Overscan margins & layout metrics
│   │   └── Extensions/
│   │       └── View+Extensions.swift # Ambient background ViewModifier
│   ├── Models/
│   │   ├── QuizCategory.swift        # 6 trivia categories with hex themes
│   │   ├── DifficultyLevel.swift     # Easy, Medium, Hard weights
│   │   ├── QuizQuestion.swift        # Question and AnswerOption structs
│   │   ├── Player.swift              # Player model (human & simulated bots)
│   │   ├── Team.swift                # Team representation
│   │   ├── GameConfiguration.swift   # Match parameters (timer, count, mode)
│   │   ├── PlayerAnswer.swift        # Submission & QuestionResult models
│   │   ├── LeaderboardEntry.swift    # Ranked entries & accuracy calculations
│   │   ├── GameSession.swift         # Active game session state
│   │   └── AppSettings.swift         # User preferences model
│   ├── ViewModels/
│   │   ├── HomeViewModel.swift       # Home feed, recent game & AppRoute enum
│   │   ├── GameSetupViewModel.swift  # Match parameter adjustments
│   │   ├── GameLobbyViewModel.swift  # Room code, QR code & bot roster
│   │   ├── LeaderboardViewModel.swift# Podium presentation logic
│   │   └── SettingsViewModel.swift   # Preferences persistence logic
│   ├── Views/
│   │   ├── Home/
│   │   │   └── HomeView.swift        # Hero game show screen & quick launch
│   │   ├── GameModes/
│   │   │   └── GameModeSelectionView.swift # 3x2 responsive category grid
│   │   ├── GameSetup/
│   │   │   └── GameSetupView.swift   # Timer, count, and difficulty options
│   │   ├── Lobby/
│   │   │   └── GameLobbyView.swift   # Simulated lobby & companion QR
│   │   ├── Gameplay/
│   │   │   └── QuizGameplayView.swift# Primary quiz screen & answer reveal
│   │   ├── Leaderboard/
│   │   │   └── LeaderboardView.swift # Animated winner podium & rankings
│   │   ├── JoinGame/
│   │   │   └── JoinGameView.swift    # Phone companion setup instructions
│   │   ├── HowToPlay/
│   │   │   └── HowToPlayView.swift   # Siri Remote guide & scoring breakdown
│   │   └── Settings/
│   │       └── SettingsView.swift    # Audio, accessibility & data reset
│   ├── Components/
│   │   ├── Buttons/
│   │   │   └── PrimaryButtonStyle.swift # tvOS focus scaling button styles
│   │   ├── Cards/
│   │   │   ├── FocusableGameCard.swift  # Parallax focus card
│   │   │   ├── AnswerOptionCard.swift   # Siri Remote answer button (A-D)
│   │   │   └── GameModeCard.swift       # Category card with icon badge
│   │   ├── Layout/
│   │   │   └── SectionHeader.swift      # Standardized TV header
│   │   ├── Players/
│   │   │   └── PlayerAvatarView.swift   # Avatar with bot & crown badges
│   │   └── Feedback/
│   │       ├── ScoreBadge.swift         # Gold score pill
│   │       ├── CountdownView.swift      # Animated circular timer ring
│   │       └── EmptyStateView.swift     # Empty and loading states
│   ├── Services/
│   │   ├── QuizDataService.swift        # Question parser, validator & filter
│   │   ├── ScoreService.swift           # Pure scoring & tie-break calculations
│   │   ├── PersistenceService.swift     # UserDefaults & Application Support JSON
│   │   ├── QRCodeService.swift          # CoreImage CIFilter QR generator
│   │   ├── GameRoomServiceProtocol.swift# Multi-client room abstraction
│   │   ├── LocalDemoRoomService.swift   # Offline bot simulation engine
│   │   └── GameEngine.swift             # Game state coordinator & timer
│   └── Resources/
│       ├── QuizQuestions.json           # 42 bundled trivia questions
│       ├── Assets.xcassets/             # Brand assets & AppIcon layers
│       └── Info.plist                   # tvOS application configuration
└── PartyPlayTVTests/
    ├── QuizDataServiceTests.swift       # Data integrity & filter tests
    ├── ScoreServiceTests.swift          # Scoring, bonuses & ranking tests
    └── GameEngineTests.swift            # Game loop, timer & submission tests
```

---

## 4. Xcode 15.2 Build & Execution Instructions

### Prerequisites
- macOS 13.5+ (Ventura) or macOS 14+ (Sonoma)
- Xcode 15.2 (Build 15C500b) with the **tvOS 17.2 SDK** installed

### Building & Running via Xcode UI
1. Open `PartyPlayTV/PartyPlayTV.xcodeproj` in **Xcode 15.2**.
2. Select the **PartyPlayTV** scheme in the top toolbar.
3. Select an Apple TV simulator destination (e.g., **Apple TV 4K (3rd generation)** or **Apple TV 4K at 1080p**).
4. Press **⌘R** (Product → Run).
5. The application will launch in the tvOS Simulator. Use the **Simulator Remote** (`Window` → `Show Remote` or `⌘⇧R`) or arrow keys to navigate.

### Building & Testing via Terminal
```bash
# Navigate to project directory
cd PartyPlayTV

# Build application for tvOS Simulator
xcodebuild -project PartyPlayTV.xcodeproj -scheme PartyPlayTV -destination "platform=tvOS Simulator,name=Apple TV 4K (3rd generation)" build

# Run complete unit test suite
xcodebuild test -project PartyPlayTV.xcodeproj -scheme PartyPlayTV -destination "platform=tvOS Simulator,name=Apple TV 4K (3rd generation)"
```

---

## 5. Offline Demo Mode & Multiplayer Architecture

### Offline Demo Mode (Current Implementation)
The application is engineered to work **100% standalone without an internet connection or external server**:
- Selecting **Solo Host Play** allows single-device couch play using the Siri Remote.
- Selecting **Simulated Party (Bots)** pre-populates the lobby with AI contestants ("Kasun", "Nethmi", "Shenal").
- Additional bots can be added on-the-fly via the "Add Bot" button in the Lobby.
- Bots simulate realistic response times (2–15 seconds) and maintain a natural ~70% correct answer distribution.

### Companion Multiplayer Architecture (Future Roadmap)
For full remote smartphone control:
1. **Network Transport:** Lightweight WebSocket server hosted on Node.js / Go or Cloudflare Workers.
2. **Room Code Handshake:** The Apple TV opens a WebSocket connection and registers room code `PLAY88`.
3. **Web Client:** Players scan the TV's QR code, opening a lightweight React/HTML5 web application (`partyplay.tv/join?room=PLAY88`).
4. **Real-time Event Flow:**
   - Apple TV emits: `{"event": "QUESTION_DISPLAYED", "questionId": "sl_001", "time": 15}`
   - Phone displays 4 colored buzzer buttons (A, B, C, D).
   - Phone emits: `{"event": "SUBMIT_ANSWER", "playerId": "p1", "choice": "B", "timeRemaining": 11.4}`
   - Apple TV evaluates answers, triggers reveal animations, and recalculates the leaderboard.

---

## 6. Unit Testing Summary
All 10 unit test cases across 3 test suites executed and **passed with 100% success rate** on Apple TV 4K (3rd generation) tvOS 17.2:
- `ScoreServiceTests`:
  - `testCorrectAnswerAwardsBasePoints`: Verified 100 base points awarded for Easy questions.
  - `testIncorrectAnswerAwardsZeroPoints`: Verified 0 points awarded for wrong answers.
  - `testRapidAnswerAwardsSpeedBonus`: Verified up to 50% speed bonus calculation.
  - `testLeaderboardOrderingAndTieResolution`: Verified deterministic sorting and tie resolution.
- `QuizDataServiceTests`:
  - `testBundledQuestionsLoadedSuccessfully`: Verified bundled JSON question loading.
  - `testFetchQuestionsByCategory`: Verified category filtering.
  - `testSriLankaQuizCategoryLoaded`: Verified Sri Lankan general knowledge content.
  - `testQuestionDataIntegrity`: Verified option counts, correct answer identifiers, and explanations.
- `GameEngineTests`:
  - `testStartNewGameInitializesCleanState`: Verified clean state initialization.
  - `testSubmitAnswerPreventsDuplicateSubmissions`: Verified single-submission lock.
  - `testGameAdvancementAndCompletion`: Verified progression to session completion.

---

## 7. AI-Assisted Development Disclosure
In accordance with assignment guidelines:
- **Assistance Utilized:** Antigravity AI was used for architectural prototyping, generating the initial Xcode project file structure, validating Swift 5.9 API compatibility, and drafting unit test suites.
- **Human Review & Refinement:** All quiz question content (specifically Sri Lankan historical and geographic facts), scoring logic, focus engine design, and MVVM service decoupling were verified and tested for native tvOS compliance.
