import os, strutils, sequtils, random, times

type
  TypingGame = object
    words: seq[string]
    gameWords: seq[string]
    correct: int

proc loadWords(filename: string): seq[string] =
  let content = readFile(filename)
  result = content.splitWhitespace()

proc selectWords(self: var TypingGame, count: int) =
  for i in 0..<count:
    let idx = rand(self.words.len - 1)
    self.gameWords.add(self.words[idx])

proc play(self: var TypingGame) =
  let startTime = epochTime()
  echo "\e[2J\e[HMinimalist Typing Game (Nim)"
  echo "Type these ", self.gameWords.len, " words (press Enter after each):\n"
  self.correct = 0
  for i, word in self.gameWords:
    var attempt = 1
    while true:
      stdout.write $(i+1), ". ", word, ": "
      let input = stdin.readLine().strip()
      if input == word:
        inc self.correct
        if attempt == 1:
          echo "\e[32mCorrect!\e[0m"
        else:
          echo "\e[32mCorrect after ", attempt, " attempts!\e[0m"
        break
      else:
        echo "\e[31mWrong! Try again.\e[0m"
        inc attempt
  let endTime = epochTime()
  let elapsed = endTime - startTime
  let wpm = (float(self.gameWords.len) / elapsed) * 60
  echo "\nGame Over! You typed ", self.correct, " out of ", self.gameWords.len, " words correctly."
  echo "Time taken: ", formatFloat(elapsed, ffDecimal, 2), " seconds"
  echo "WPM: ", formatFloat(wpm, ffDecimal, 2)

proc main() =
  if paramCount() < 1:
    echo "Usage: ", getAppFilename(), " <wordlist.txt>"
    quit(1)
  let filename = paramStr(1)
  var game = TypingGame(words: loadWords(filename))
  if game.words.len == 0:
    echo "No words found in wordlist!"
    quit(1)
  randomize()
  game.selectWords(20)
  game.play()

main()
