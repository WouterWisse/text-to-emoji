import SwiftUI
import TextToEmoji

struct ContentView: View {
    
    private let textToEmoji = TextToEmoji()
    @State private var text: String = ""
    @State private var emoji: String = "ð¤·ââï¸"
    
    private let categoryOptions: [TextToEmoji.EmojiCategory] = [
        .smileysAndPeople,
        .animalsAndNature,
        .foodAndDrink,
        .activity,
        .travelAndPlaces,
        .objects,
        .symbols,
        .flags
    ]
    @State private var selectedCategoryOption = -1
    
    var body: some View {
        VStack(alignment: .center) {
            VStack {
                Text("Preferred Category")
                    .fontWeight(.semibold)
                
                Picker("Category", selection: $selectedCategoryOption) {
                    Text("All").tag(-1)
                    Text("ð Smileys & People").tag(0)
                    Text("ð» Animals & Nature").tag(1)
                    Text("ð Food & Drink").tag(2)
                    Text("â½ Activity").tag(3)
                    Text("ð Travel & Places").tag(4)
                    Text("ð¡ Objects").tag(5)
                    Text("ð Symbols").tag(6)
                    Text("ð Flags").tag(7)
                }
                .pickerStyle(.automatic)
                
                Text("The preferred category will be given a higher priorty when multiple emojiâs match the given text.\n\nFor example: `'Shrimp'` could match `ð¦` and `ð¤`.\n\n**Food & Drink** will return `ð¤`\n**Animals & Nature** will return `ð¦`")
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            
            VStack {
                TextField("Text to Emoji", text: $text)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(.title))
                    .multilineTextAlignment(.center)
                    .onSubmit {
                        Task {
                            let category = selectedCategoryOption < 0 ? nil : categoryOptions[selectedCategoryOption]
                            self.emoji = try await textToEmoji.emoji(
                                for: text,
                                preferredCategory: category
                            ) ?? "ð¤·ââï¸"
                        }
                    }
                Text(emoji)
                    .font(.system(size: 144))
            }
            .padding()
            
            Spacer()
        }
    }
}

// MARK: Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
