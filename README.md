# Imaginarium Board — iPad Digital Game Board

## Overview

**Imaginarium Board** is a digital companion app for the popular association-based board game *Imaginarium* (Имаджинариум). The app replaces the physical game board, player tokens, and score tracking — allowing **up to 16 players** to play simultaneously (the physical game only supports up to 7).

The app is designed for **iPad in portrait orientation** and serves as a shared game board placed in the center of the table while players hold their physical cards.

## Why This App?

The physical Imaginarium game is limited to 7 players due to the number of tokens and board spaces. This app removes that limitation:

- **16 unique player colors** are available (black, white, gray, orange, yellow, red, light pink, magenta, violet, blue, turquoise, light blue, dark green, acid green, brown, beige)
- **No card count restrictions** — the app assumes you have multiple physical decks
- **Victory at 40 points** (cell 39 on the board), but the game can continue beyond if players choose

## Game Rules (Quick Reference)

Imaginarium is a game of associations played with illustrated cards.

### Setup
1. Each player picks a color and gets voting tokens equal to the number of players
2. Deal 6 cards to each player from the combined deck(s)
3. Choose a starting leader (host)

### Round Flow
1. **Leader's Association** — The leader picks a card and announces an association (word, phrase, quote, gesture, sound — anything)
2. **Other Players Choose** — Everyone else picks the card from their hand that best matches the association and places it face-down
3. **Shuffle & Reveal** — All cards (including the leader's) are shuffled and laid out face-up, numbered for voting
4. **Vote** — Each non-leader player secretly votes for the card they think is the leader's (cannot vote for their own card)
5. **Score** — Points are awarded based on who guessed correctly

### Scoring
| Who | Condition | Points |
|-----|-----------|--------|
| Leader | At least one (but not all) players guessed correctly | **3** + 1 per correct guesser |
| Leader | Everyone guessed correctly (too easy) | **0** |
| Leader | Nobody guessed correctly (too hard) | **0** |
| Guesser | Correctly identified the leader's card | **3** |
| Any non-leader | For each vote their own card received from other players | **+1** per vote |

6. **End of Round** — Discard played cards, draw replacements to refill to 6, pass the leader role clockwise

### Special Cells on the Board
Certain board positions have special rules for the leader's association:
- **4 Words** (cells 3, 18, 25, 28) — Association must be exactly 4 words
- **Question** (cells 6, 10, 17, 26) — Association must be phrased as a question
- **Brand/Logo** (cells 12, 23, 29, 35) — Association must reference a brand or logo
- **TV/Cinema** (cells 5, 21, 31, 38) — Association must be from a movie or TV show
- **Narrative** (cells 8, 15, 19, 32) — Association must be a story or narrative phrase

### End of Game
The game ends when any player reaches or passes **cell 39 (40 points)**. The player furthest ahead wins. Players may agree to continue playing beyond 40 if desired.

## App Architecture

### Tech Stack
- **Swift 6** with strict concurrency
- **SwiftUI** with `@Observable` macro (iOS 17+)
- **iPad-only**, portrait orientation

### Project Structure

```
ImaginariumBoardiPad/
├── ImaginariumBoardiPad.swift    # App entry point
├── Root.swift                     # Main view with board, players, controls
├── Models/
│   ├── Player.swift               # Player data model
│   ├── Tile.swift                 # Board tile model & types
│   └── GameState.swift            # Central observable game state
├── Views/
│   ├── BoardView.swift            # The 39-cell serpentine game board
│   ├── TileCell.swift             # Individual board cell with player tokens
│   ├── PlayerListView.swift       # Horizontal scrollable player bar
│   ├── PlayerCardView.swift       # Player avatar (first letter icon)
│   ├── PlayerTrainTileView.swift  # Color tile in player list / color picker
│   └── ScoreEntryView.swift       # Round scoring dialog
├── Dialogs/
│   ├── PlayerAddDialog.swift      # Add new player (name + color picker)
│   ├── MakeTurnDialog.swift       # Score entry per round
│   └── SettingsDialog.swift       # Game settings (reset, continue past 40)
├── UI/
│   ├── GameControlButton.swift    # Styled action button
│   └── Modal/
│       ├── Modal.swift            # Custom modal overlay modifier
│       └── ModalTextEditor.swift  # Text input with placeholder
├── Extensions/
│   └── Color.swift                # Color(hex:) convenience initializer
└── DataStructures/
    └── Queue.swift                # Simple FIFO queue
```

### State Management

The app uses SwiftUI's `@Observable` macro (replacing the legacy Flux/Reducer pattern):

- **`GameState`** — Single source of truth containing players, current leader index, game settings
- Player actions (add, remove, move on board, score) are methods on `GameState`
- Board tile data is computed/static and doesn't change during gameplay

### Key Features

| Feature | Description |
|---------|-------------|
| **16-player support** | Pick from 16 distinct colors; board cells show all player tokens |
| **Serpentine board** | 39 cells arranged in a snake pattern (right→left→right…) matching the physical board |
| **Special cells** | Visual indicators for special association rules on designated cells |
| **Score tracking** | Per-round scoring dialog: mark who guessed correctly, auto-calculate points |
| **Player tokens on board** | Each cell shows colored dots/icons for all players currently on that cell |
| **Current leader indicator** | Visual highlight showing whose turn it is to lead |
| **Continue past 40** | Optional setting to keep playing after someone reaches the finish |
| **Add/remove players** | Manage players at any time during the game |
| **Undo last move** | Roll back the most recent scoring round |

## How to Use

1. Launch the app on an iPad (portrait orientation)
2. Tap **"Add Player"** to add 4–16 players, choosing a name and color for each
3. Tap **"New Round"** when the leader has given their association and voting is complete
4. In the scoring dialog, mark which players guessed correctly and enter any bonus votes
5. The board updates automatically — player tokens move along the serpentine path
6. First player to reach cell 39 wins! (or keep going if you want)

## Development Notes

- Minimum deployment target: **iOS 17.0** (for `@Observable`)
- Optimized for **iPad portrait** — landscape is not officially supported
- No network features — fully offline, single-device shared board
- Test Data button populates all 16 player colors for development/demo purposes
