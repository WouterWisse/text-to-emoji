<div align="center">
   <img width="600" src=".github/assets/logo-light@2x.png?raw=true#gh-light-mode-only" alt="Text To Emoji - Logo">
   <img width="600" src=".github/assets/logo-dark@2x.png?raw=true#gh-dark-mode-only" alt="Text To Emoji - Logo">
</div>

<div align="center">
   <img height="24" src=".github/assets/github-swift-package-logo-light@2x.png?raw=true#gh-light-mode-only" alt="Text To Emoji - Logo">
   <img height="24" src=".github/assets/github-swift-package-logo-dark@2x.png?raw=true#gh-dark-mode-only" alt="Text To Emoji - Logo">
</div>

<br />

<p align="center">
   <img src="https://github.com/WouterWisse/text-to-emoji/actions/workflows/main.yml/badge.svg">
   <a href="https://www.twitter.com/wouterwisse" target="_blank">
      <img src="https://img.shields.io/badge/contact%20-@wouterwisse-blue.svg">
   </a>
</p>

## Installation
`Xcode` → `File` → `Add packages...` → enter url → `https://github.com/WouterWisse/text-to-emoji`

## How to use
**Basic initialization**<br />
```swift
let textToEmoji = TextToEmoji()
```

**Advanced initialization**<br />
You could pass your own `DispatchQueue` if you'd like.
```swift
let textToEmoji = TextToEmoji(
   globalDispatchQueue: DispatchQueue.global(), // a global dispatch queue to do the heavy lifting
   mainDispatchQueue: DispatchQueue.main // the main queue to return the emoji on
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

**Advanced, with a preferred emoji category**<br />
With `preferredCategory`, you can give a certain emoji category a higher priority. This can be very useful if you already know the context in which you are searching. For example, when looking for the word `shrimp`, two matching emoji's would be: `🦐` and `🍤`.<br/>
By passing `.foodAndDrink` as the `preferredCategory`, the only match will be `🍤`, since the preferred category is about food (and drink). Passing `.animalsAndNature` would result in `🦐`. See `EmojiCategory.swift` for all categories.
```swift
let shrimp = textToEmoji.emoji(for: "shrimp", preferredCategory: .foodAndDrink) // 🍤
```
```swift
let shrimp = textToEmoji.emoji(for: "shrimp", preferredCategory: .animalsAndNature) // 🦐
```

## Localization
| Languages    | Supported   |
|--------------|-------------|
| 🇬🇧 English   | ✅          |
| 🇳🇱 Dutch     | Coming soon |
| 🇩🇪 Deutsch   | Coming soon |
| 🇪🇸 Español   | Coming soon |
| 🇫🇷 Français  | Coming soon |
| 🇮🇹 Italiano  | Coming soon |
| 🇵🇹 Português | Coming soon |

## Contribution
Feel free to contribute to this project via a `pull-request`.

## Keep me caffeinated
   <a href="https://www.buymeacoffee.com/wouterwisse" target="_blank">
      <img width="220" src=".github/assets/bmc-button.png" alt="Buy me a Coffee">
   </a>
