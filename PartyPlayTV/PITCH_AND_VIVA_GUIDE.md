# PartyPlay TV — Investor Pitch & Viva Presentation Outline
**SE4041 Mobile Application Design and Development — Part B (tvOS)**  
**Student ID:** IT22136374  

---

## 1. Problem & Opportunity
- **The Modern Living Room Paradox:** Smart televisions have evolved with 4K displays and powerful chips, yet group entertainment in the living room often defaults to passive streaming or solitary mobile gaming.
- **Social Trivia Friction:** Traditional trivia board games are slow and require manual card reading, while mobile-only quiz games isolate players into individual small screens.
- **The Opportunity:** The Apple TV is the undisputed centerpiece of premium home theater systems. A native tvOS party game that turns the Apple TV into a game-show host unlocks effortless, spontaneous social gatherings.

---

## 2. The Solution: PartyPlay TV
**PartyPlay TV** delivers an authentic, broadcast-grade trivia game show directly to Apple TV:
- **Big-Screen Visual Stage:** High-contrast 10-foot UI designed specifically for distance viewing, dynamic countdown clocks, and celebratory podium rankings.
- **Zero Friction Setup:** Works completely offline with bundled trivia and simulated bots for solo play, while providing a CoreImage QR code and room code for phone controllers.
- **Native Apple tvOS Excellence:** Leverages the Siri Remote focus engine with intuitive touch navigation, parallax card lift effects, and accessible controls.

---

## 3. Target Audience
1. **Families & Gatherings:** Multi-generational households looking for family-friendly trivia (featuring *Kids & Family* and *Sri Lanka Quiz*).
2. **University Students & Social Clubs:** Fast-paced competitive party games for game nights and dorms.
3. **Casual Apple TV Owners:** Users seeking quick, offline couch entertainment without requiring console controllers.

---

## 4. Market & Competitor Analysis
| Product | Strengths | Weaknesses | PartyPlay TV Advantage |
| :--- | :--- | :--- | :--- |
| **Jackbox Party Games** | Iconic comedy, phone controls | Expensive ($30/pack), heavy installation, requires internet | Native tvOS performance, zero cost barrier, instant offline mode |
| **Kahoot!** | Large question base, education focus | Mobile/web UI not optimized for TV remote; corporate subscription model | Custom 10-foot UI, Siri Remote native interaction, Sri Lankan localized content |
| **Trivia Crack** | Highly viral, casual gameplay | Mobile-first; clunky on TV screens | Dedicated Apple TV game-show experience with focus engine polish |

---

## 5. Revenue Model
- **Freemium Core:** The base game includes 6 foundational trivia categories and offline solo/bot modes for free.
- **Premium Expansion Packs:**
  - Specialized trivia packs (e.g., *World Cinema*, *Advanced Tech & Coding*, *Sri Lankan History Master*).
  - Custom game-show themes and sound packs.
- **Party Pro Subscription / One-time Unlock:** Enables unlimited companion phone connections and custom question creator.

---

## 6. Technical Architecture & Feasibility
- **Platform:** Native Swift 5.9 and SwiftUI on tvOS 17 SDK (Xcode 15.2).
- **Architecture:** Clean MVVM architecture with protocol-based services (`GameRoomServiceProtocol`, `PersistenceServiceProtocol`).
- **Core Frameworks:**
  - `SwiftUI` & `FocusState` for Siri Remote navigation.
  - `CoreImage` (`CIFilter.qrCodeGenerator`) for live QR code rendering.
  - `Combine` for asynchronous timers and reactive state updates.
  - `XCTest` unit test suite for question integrity and scoring math.

---

## 7. Viva Demonstration Script (Step-by-Step)
1. **Introduction (1 min):**
   - Introduce *PartyPlay TV* as a native Apple tvOS multiplayer game show developed in Xcode 15.2.
   - Highlight the 10-foot UI principles and dark charcoal game-show design system.
2. **Hero Screen & Category Selection (1.5 min):**
   - Demonstrate Siri Remote focus interaction moving smoothly across "Play Now", "Join Game", and the featured categories.
   - Enter **Choose Quiz Category** and highlight the 6 themes, pointing out the localized *Sri Lanka Quiz*.
3. **Configuration & Lobby (2 min):**
   - Select difficulty (*Medium*), match length (*5 Questions*), and timer (*15s*).
   - Show the **Game Lobby**: highlight the dynamically generated 6-letter room code and CoreImage QR code.
   - Demonstrate the simulated offline bots ("Kasun", "Nethmi") joining the room.
4. **Live Gameplay & Scoring (2.5 min):**
   - Start the game show. Show the circular countdown timer with shifting color states.
   - Answer using the Siri Remote. Point out the instant feedback banner showing points and historical explanations.
   - Show how the speed bonus rewards quick responses.
5. **Leaderboard & Persistence (1.5 min):**
   - Complete the match to reveal the **Game Show Champion** podium.
   - Show how rankings and accuracy percentages are calculated from actual gameplay.
   - Navigate to **Settings** to demonstrate user preference persistence and data clearing.
6. **Code Architecture & Tests (1.5 min):**
   - Present the MVVM file structure and show the green 10/10 passing unit test suite in Xcode.
