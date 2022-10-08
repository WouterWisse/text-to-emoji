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
   <img src="https://img.shields.io/badge/ios%20-13-orange.svg">
   <a href="https://www.twitter.com/wouterwisse" target="_blank">
      <img src="https://img.shields.io/badge/contact%20-@wouterwisse-blue.svg">
   </a>
</p>

## Installation
`Xcode` → `File` → `Add packages...` → enter url → `https://github.com/WouterWisse/text-to-emoji`

## How to use
**Initialization**<br />
```swift
let textToEmoji = TextToEmoji()
```

**Get an emoji**<br />
```swift
let emoji = await textToEmoji.emoji(for: "tomato") // 🍅
```
This is an `async` method that will `throw` the error `noMatchFound` if no emoji has been matched with the given text.

**Get an emoji for a preferred category**<br />
```swift
let shrimp = textToEmoji.emoji(for: "shrimp", preferredCategory: .foodAndDrink) // 🍤
```
```swift
let shrimp = textToEmoji.emoji(for: "shrimp", preferredCategory: .animalsAndNature) // 🦐
```
With `preferredCategory`, you can give a certain emoji category a higher priority. This can be very useful if you already know the context in which you are searching. For example, when looking for the word `shrimp`, two matching emoji's could be: `🦐` and `🍤`.<br/>
By passing `.foodAndDrink` as the `preferredCategory`, the first match will be `🍤`. Passing `.animalsAndNature` would result in `🦐`.

See `EmojiCategory.swift` for all categories.

## Localization
| Languages    | Supported   |
|--------------|-------------|
| 🇬🇧 English   | ✅          |
| 🇳🇱 Dutch     | Coming soon |
| 🇩🇪 Deutsch   | Coming soon-ish |
| 🇪🇸 Español   | Coming soon-ish |
| 🇫🇷 Français  | Coming soon-ish |
| 🇮🇹 Italiano  | Coming soon-ish |
| 🇵🇹 Português | Coming soon-ish |

## Contribution
Feel free to contribute to this project via a `pull request`.

## Keep me caffeinated
   <a href="https://www.buymeacoffee.com/wouterwisse" target="_blank">
      <img width="220" src=".github/assets/bmc-button.png" alt="Buy me a Coffee">
   </a>
