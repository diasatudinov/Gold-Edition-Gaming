import SwiftUI

struct MenuView: View {
    @State private var showGame = false
    @State private var showShop = false
    @State private var showAchievement = false
    @State private var showCalendar = false
    @State private var showSettings = false
    
    @StateObject var achievementVM = AchievementsViewModel()
    @StateObject var settingsVM = SettingsViewModelGE()
    @StateObject var calendarVM = CalendarViewModel()
    @StateObject var shopVM = ShopViewModelGE()
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading) {
                        MoneyBgGE()
                        
                        Button {
                            showCalendar = true
                        } label: {
                            Image(.calendarIconGE)
                                .resizable()
                                .scaledToFit()
                                .frame(height: GEDeviceManager.shared.deviceType == .pad ? 160:80)
                        }
                    }
                    Spacer()
                    
                    Button {
                        showSettings = true
                    } label: {
                        Image(.settingsIconGE)
                            .resizable()
                            .scaledToFit()
                            .frame(height: GEDeviceManager.shared.deviceType == .pad ? 140:70)
                    }
                }
                
                
                Spacer()
                Button {
                    showGame = true
                } label: {
                    Image(.playIconGE)
                        .resizable()
                        .scaledToFit()
                        .frame(height: GEDeviceManager.shared.deviceType == .pad ? 240:120)
                }
                
                Spacer()
                
                HStack {
                    
                    
                    Button {
                        showShop = true
                    } label: {
                        Image(.shopIconGE)
                            .resizable()
                            .scaledToFit()
                            .frame(height: GEDeviceManager.shared.deviceType == .pad ? 180:90)
                    }
                    Spacer()
                    Button {
                        showAchievement = true
                    } label: {
                        Image(.achievementsIconGE)
                            .resizable()
                            .scaledToFit()
                            .frame(height: GEDeviceManager.shared.deviceType == .pad ? 180:90)
                    }
                }
            }.padding()
        }
        .background(
            ZStack {
                Image(.menuBgGE)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
            }
        )
                    .onAppear {
                        if settingsVM.musicEnabled {
                            GEMusicManager.shared.playBackgroundMusic()
                        }
                    }
                    .onChange(of: settingsVM.musicEnabled) { enabled in
                        if enabled {
                            GEMusicManager.shared.playBackgroundMusic()
                        } else {
                            GEMusicManager.shared.stopBackgroundMusic()
                        }
                    }
        .fullScreenCover(isPresented: $showGame) {
            SelectGameView(shopVM: shopVM)
        }
        .fullScreenCover(isPresented: $showCalendar) {
            CalendarView(viewModel: calendarVM)
        }
        .fullScreenCover(isPresented: $showAchievement) {
            AchievementsView(viewModel: achievementVM)
        }
        .fullScreenCover(isPresented: $showShop) {
            ShopViewGE(viewModel: shopVM)
        }
        .fullScreenCover(isPresented: $showSettings) {
            SettingsView(settingsVM: settingsVM)
        }
        
        
        
        
    }
    
}

#Preview {
    MenuView()
}
