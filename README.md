<p align="center">
   <img width="180" src=".github/assets/icon-readme@2x.png" alt="text-to-emoji">
</p>
<p align="center">
   <strong>text-to-🤩</strong><BR>
   🤷‍♂️ Not sure why you'd need this.
</p>
<p align="center">
   <img src="https://github.com/WouterWisse/text-to-emoji/actions/workflows/main.yml/badge.svg">
   <a href="https://swiftpackageindex.com/WouterWisse/text-to-emoji">
      <img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FWouterWisse%2Ftext-to-emoji%2Fbadge%3Ftype%3Dplatforms">
   </a>
   <a href="https://swiftpackageindex.com/WouterWisse/text-to-emoji">
      <img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FWouterWisse%2Ftext-to-emoji%2Fbadge%3Ftype%3Dswift-versions">
   </a>
</p>

## Installation
`Xcode` → `File` → `Add packages...` → enter url → `https://github.com/WouterWisse/text-to-emoji`

## How to use
#### Get an emoji
```swift
let emoji = await TextToEmoji.emoji(for: "tomato") // 🍅
```
This is an `async` method that will `throw` the error `noMatchFound` if no emoji has been matched with the given text.

#### Get an emoji for a preferred category
```swift
let shrimp = TextToEmoji.emoji(for: "shrimp", preferredCategory: .foodAndDrink) // 🍤
```
```swift
let shrimp = TextToEmoji.emoji(for: "shrimp", preferredCategory: .animalsAndNature) // 🦐
```
With `preferredCategory` a certain emoji category can be given a higher priority. This can be very useful if the context of the search is known. For example, when looking for the word `shrimp`, two matching emoji's could be: `🦐` and `🍤`.<br/>
By passing `.foodAndDrink` as the `preferredCategory`, the first match will be `🍤`. Passing `.animalsAndNature` would result in `🦐`.

See `EmojiCategory.swift` for all categories.

## Localization
| Languages    | Supported   |
|--------------|-------------|
| 🇬🇧 English   | ✅          |
| 🇳🇱 Dutch     | ✅          |
| 🇩🇪 Deutsch   | ⏳          |
| 🇪🇸 Español   | ⏳          |
| 🇫🇷 Français  | ⏳          |
| 🇮🇹 Italiano  | ⏳          |
| 🇵🇹 Português | ⏳          |

## Contribution
Feel free to help me out here, especially with the localization.

## Keep me caffeinated
<a href="https://www.buymeacoffee.com/wouterwisse" target="_blank">
   <img width="220" src=".github/assets/bmc-button.png" alt="Buy me a Coffee">
</a>
