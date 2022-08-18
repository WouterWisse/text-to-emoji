<p align="center">
   <img width="180" src=".github/assets/icon-readme.png" alt="Text To Emoji - Logo">
</p>
<p align="center">
   <strong>Text to Emoji</strong><br />
   Not sure why you'd need this.
</p>
<p align="center">
   <img src="https://github.com/WouterWisse/text-to-emoji/actions/workflows/main.yml/badge.svg">
   <a href="https://www.twitter.com/wouterwisse" target="_blank">
      <img src="https://img.shields.io/badge/contact%20-@wouterwisse-blue.svg">
   </a>
</p>
<p align="center">
   <a href="https://www.buymeacoffee.com/wouterwisse" target="_blank">
      <img width="180" src=".github/assets/bmc-button.png" alt="Buy me a Coffee">
   </a>
</p>

## Installation
`Xcode` → `File` → `Add packages...` → enter the url of this repository → `https://github.com/WouterWisse/text-to-emoji`

## How to use
**Basic initialization**<br />
Use the default configuration.
```swift
let textToEmoji = TextToEmoji()
```

**Advanced initialization**<br />
You could pass your own `DispatchQueue` if you'd like.
```swift
let textToEmoji = TextToEmoji(
   globalDispatchQueue: DispatchQueue.global(), // a global dispatch queue to do the heavy lifting
   mainDispatchQueue: DispatchQueue.main // a main queue to return the emoji on
)
```

**Simple, synchronous**<br />
```swift
let emoji = textToEmoji.emoji(for: "tomato") // 🍅
```

**Simple, asynchronous with completion**<br />
```swift
let emoji = textToEmoji.emoji(for: "tomato", completion: { emoji in
            print(emoji) // 🍅
        })
```

**Simple, async await**<br />
```swift
let emoji = await textToEmoji.emoji(for: "tomato") // 🍅
```

## Localization
TBD

## Contribution
TBD
