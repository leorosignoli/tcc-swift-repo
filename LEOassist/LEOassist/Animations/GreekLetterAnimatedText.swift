import SwiftUI

struct GreekLetterAnimatedText: View {
    let text: String
    let characterDelay: TimeInterval
    let randomLetterDisplayDuration: TimeInterval
    
    @State private var displayedText = ""
    
    init(text: String, characterDelay: TimeInterval = 0.05, randomLetterDisplayDuration: TimeInterval = 0.03) {
            self.text = text
            self.characterDelay = characterDelay
            self.randomLetterDisplayDuration = randomLetterDisplayDuration
        }
    
    var body: some View {
        Text(displayedText)
            .onAppear {
                let displayLink = Timer.scheduledTimer(withTimeInterval: characterDelay, repeats: true) { timer in
                    if displayedText.count < text.count {
                        let randomGreekLetter = generateRandomGreekLetter()
                        displayedText.append(randomGreekLetter)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + randomLetterDisplayDuration) {
                            displayedText = String(displayedText.dropLast())
                            displayedText.append(text.dropFirst(displayedText.count).first ?? Character(""))
                        }
                    } else {
                        timer.invalidate()
                    }
                }
                let _ = displayLink
            }
    }
    
    private func generateRandomGreekLetter() -> Character {
        let greekLetters = (0x03B1...0x03C9)
        let randomGreekLetterUnicode = Int.random(in: greekLetters)
        let randomGreekLetter = Character(UnicodeScalar(randomGreekLetterUnicode) ?? "α")
        return randomGreekLetter
    }
}
