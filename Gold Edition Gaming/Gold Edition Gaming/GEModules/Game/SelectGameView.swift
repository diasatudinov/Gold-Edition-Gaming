import SwiftUI

struct SelectGameView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var shopVM: ShopViewModelGE
    
    @State private var showAiGame = false
    @State private var showTwoPlayerGame = false
    @State private var showOnlineGame = false
    var body: some View {
        ZStack {
            
            VStack {
                Button {
                    showAiGame = true
                } label: {
                    Image(.withAiIconGE)
                        .resizable()
                        .scaledToFit()
                        .frame(height: GEDeviceManager.shared.deviceType == .pad ? 180:90)
                }
                
                Button {
                    showTwoPlayerGame = true
                } label: {
                    Image(.twoPlayersIconGE)
                        .resizable()
                        .scaledToFit()
                        .frame(height: GEDeviceManager.shared.deviceType == .pad ? 180:90)
                }
                
                Button {
                    showOnlineGame = true
                } label: {
                    Image(.onlineIconGE)
                        .resizable()
                        .scaledToFit()
                        .frame(height: GEDeviceManager.shared.deviceType == .pad ? 180:90)
                }
                
            }
            
            VStack {
                HStack {
                    HStack(alignment: .top) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                            
                        } label: {
                            Image(.backIconGE)
                                .resizable()
                                .scaledToFit()
                                .frame(height: GEDeviceManager.shared.deviceType == .pad ? 150:75)
                        }
                        Spacer()
                       
                    }.padding([.horizontal, .top])
                }
                Spacer()
            }
        }.background(
            ZStack {
                Image(.menuBgGE)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
            }
        )
        .fullScreenCover(isPresented: $showAiGame) {
            AgainstAiView(shopVM: shopVM)
        }
        .fullScreenCover(isPresented: $showTwoPlayerGame) {
            TwoPlayersView(shopVM: shopVM)
        }
        .fullScreenCover(isPresented: $showOnlineGame) {
            AgainstAiView(shopVM: shopVM)
        }
    }
}

#Preview {
    SelectGameView(shopVM: ShopViewModelGE())
}
