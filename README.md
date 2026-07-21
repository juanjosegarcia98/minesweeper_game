# 💣 My Minesweeper clone project
By Juan José García.

> Note: it may have some little bugs and lack of responsiveness. Maybe I'll keep building features, making improvements or fixing bugs. Or maybe not. I'm always happy to get issues or proposals from anyone.

This is my humble attempt to challenge myself and think a minesweeper from scratch. I've tried to use as little AI as possible, just for tutoring me on some topics or tasks like building the AppImage for Linux (I've put the assets and a script to build it).

## How did I thought it?

First, by analyzing and dissecting an actual minesweeper game. Whatever you want, the Windows version, a mobile version you can find on the app stores, etcetera. 
I chose the KDE's version, KMines. Because I do most of my computing in Linux and because it's quite simple.

So, what do you get after analyzing the game? 
That the game is pretty simple (but you have to think a few things): 
- It has a rectangular board of cells (a matrix, simple math and data structure) that has a given width and height, and a certain number of mines you have to find (or avoid clicking).
- Each cell has a state: its initial state, flagged or clicked. It can have a mine or not.
- It also has a stopwatch to see how quick you beat the game, and optionally save your best times.
- The game starts when you click the first cell: it places the mines [pseudo]randomly and gives you at least the neighbor cells to that first clicked cell, that always remain with no mines so it is more fair, I guess.
- Another interesting thing is that when you click the cell, if the cell has no neighbor mines it clicks also the neighbor cells and do this recursively until it finds a cell with neighbor mines (I have some minor issues in my implementation that I have to solve yet, but nothing to worry about).
- Besides clicking the cell to find if it has a mine (trying to be sure there is not, that's the whole idea: leaving only the mines without clicking so you can win), you can place a flag on it: this makes the cell not clickable and helps you to keep track of the mines you have found so far.
- If after clicking a cell there only remain the mine cells (with or without flags), the game ends and you win. If you click a mine like I said earlier you lose, miserably (dramatic).
- You can reset the game and keep the current mines' positions or start a new game.
- You can pause the game so the stopwatch does not run (obviously you cannot do anything in pause).
- You have some pre-set difficulties (each one with a different height, width and number of mines set). You have also a custom difficulty you can customize.


## Some ideas for the future that came to my mind

> Note: Since I tried until now to build using only Flutter's built-in libraries just for fun, I've left some features that may sound pretty basic for later.

- ~~Persisting the configuration.~~
- ~~Saving best times.~~
- A countdown mode, In which you set a timer that goes backwards and you lose if you run out of time.
- A prettier UI.
- Custom UI theming.
- Custom boards, with different shapes, spaces between cells, etc.