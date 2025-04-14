import SwiftUI

struct LoaderView: View {
    @State private var scale: CGFloat = 1.0
    @State private var progress: CGFloat = 0.0
    @State private var timer: Timer?
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                ZStack {
                    Image("logoGE")
                        .resizable()
                        .scaledToFit()
                    
                    
                }
                .frame(height: 150)
                
                Spacer()
                
                Image(.loadingTextGE)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 34)
                    .scaleEffect(scale)
                    .animation(
                        Animation.easeInOut(duration: 0.8)
                            .repeatForever(autoreverses: true),
                        value: scale
                    )
                    .onAppear {
                        scale = 0.8
                    }
                    .padding(.bottom, 15)
                
                ZStack {
                    Image(.loaderLineGE)
                        .resizable()
                        .scaledToFit()
                        .colorMultiply(.gray)
                    
                    Image(.loaderLineGE)
                        .resizable()
                        .scaledToFit()
                        .mask(
                            Rectangle()
                                .frame(width: progress * 400)
                                .padding(.trailing, (1 - progress) * 400)
                        )
                }
                .frame(width: 400)
            }
        }.background(
            Image(.bgLoaderGE)
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .scaledToFill()
            
        )
        .onAppear {
            startTimer()
        }
    }
    
    func startTimer() {
        timer?.invalidate()
        progress = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { timer in
            if progress < 1 {
                progress += 0.01
            } else {
                timer.invalidate()
            }
        }
    }
}

#Preview {
    LoaderView()
}
