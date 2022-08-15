import SwiftUI
import TextToEmoji

struct ContentView: View {
    
    private let textToEmoji = TextToEmoji()
    @State private var text: String = ""
    @State private var emoji: String = "🤷‍♂️"
    
    private let accuracyOptions: [TextToEmoji.MatchAccuracy] = [.low, .medium, .high, .perfect]
    @State private var selectedAccuracyOption = 1
    
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
                Text("Accuracy")
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Picker("Accuracy", selection: $selectedAccuracyOption) {
                    Text("Low").tag(0)
                    Text("Medium").tag(1)
                    Text("High").tag(2)
                    Text("Perfect").tag(3)
                }
                .pickerStyle(.segmented)
                
                Text("The higher the accuracy, the more accurate the results.\nA higher accuracy is less forgiving in terms of typo's.")
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            
            VStack {
                Text("Preferred Category")
                    .fontWeight(.semibold)
                
                Picker("Category", selection: $selectedCategoryOption) {
                    Text("All").tag(-1)
                    Text("😃 Smileys & People").tag(0)
                    Text("🐻 Animals & Nature").tag(1)
                    Text("🍔 Food & Drink").tag(2)
                    Text("⚽ Activity").tag(3)
                    Text("🚀 Travel & Places").tag(4)
                    Text("💡 Objects").tag(5)
                    Text("💕 Symbols").tag(6)
                    Text("🎌 Flags").tag(7)
                }
                .pickerStyle(.automatic)
                Text("The preferred category will be given a higher priorty when multiple emoji’s match the given text.\nFor example: “Shrimp” could match 🦐 and 🍤.\nThe latter is returned when Food & Drink is selected.")
                
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            
            VStack {
                TextField("Text to Emoji", text: $text)
                    .font(.system(.title))
                    .multilineTextAlignment(.center)
                    .onSubmit {
                        Task {
                            let accuracy = accuracyOptions[selectedAccuracyOption]
                            let category = selectedCategoryOption < 0 ? nil : categoryOptions[selectedCategoryOption]
                            self.emoji = await textToEmoji.emoji(
                                for: text,
                                preferredCategory: category,
                                accuracy: accuracy
                            ) ?? "🤷‍♂️"
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
