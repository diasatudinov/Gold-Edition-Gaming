import SwiftUI

struct AnimatedTextView: View {
    @State private var showText = false

    var body: some View {
        VStack {
            Spacer()

            ZStack {
                if showText {
                    ZStack {
                        Circle()
                            .fill(Color.orange.opacity(0.3))
                            .frame(width: 200, height: 200)

                        Text("Hello!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                    }
                    .scaleEffect(showText ? 1 : 0)
                    .animation(.easeOut(duration: 3), value: showText)
                }
            }

            Spacer()

            Button("Trigger Text Animation") {
                triggerTextAnimation()
            }
            .padding()
        }
    }

    func triggerTextAnimation() {
        showText = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            showText = false
        }
    }
}