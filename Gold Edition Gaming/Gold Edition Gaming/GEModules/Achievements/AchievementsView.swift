import SwiftUI

struct AchievementsView: View {
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var viewModel: AchievementsViewModel
    var body: some View {
        ZStack {
            
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack {
                        VStack {
                            Image(.overallIconText)
                                .resizable()
                                .scaledToFit()
                                .frame(height: GEDeviceManager.shared.deviceType == .pad ? 80:40)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(viewModel.achievements.filter({ $0.category == .overall }), id: \.self) { achievement in
                                        ZStack {
                                            Image(achievement.image)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: GEDeviceManager.shared.deviceType == .pad ? 400:200)
                                            
                                            
                                            if !achievement.isAchieved {
                                                Image(.lockIconGE)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: GEDeviceManager.shared.deviceType == .pad ? 300:150)
                                            }
                                            
                                        }.onTapGesture {
                                            viewModel.achieveToggle(achievement)
                                        }
                                    }
                                }
                            }
                        }
                        
                        VStack {
                            Image(.strategicIconText)
                                .resizable()
                                .scaledToFit()
                                .frame(height: GEDeviceManager.shared.deviceType == .pad ? 80:40)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(viewModel.achievements.filter({ $0.category == .strategic }), id: \.self) { achievement in
                                        ZStack {
                                            Image(achievement.image)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: GEDeviceManager.shared.deviceType == .pad ? 400:200)
                                            
                                            
                                            if !achievement.isAchieved {
                                                Image(.lockIconGE)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: GEDeviceManager.shared.deviceType == .pad ? 300:150)
                                            }
                                            
                                        }.onTapGesture {
                                            viewModel.achieveToggle(achievement)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    VStack {
                        Image(.specialIconText)
                            .resizable()
                            .scaledToFit()
                            .frame(height: GEDeviceManager.shared.deviceType == .pad ? 80:40)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewModel.achievements.filter({ $0.category == .special }), id: \.self) { achievement in
                                    ZStack {
                                        Image(achievement.image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: GEDeviceManager.shared.deviceType == .pad ? 400:200)
                                        
                                        
                                        if !achievement.isAchieved {
                                            Image(.lockIconGE)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: GEDeviceManager.shared.deviceType == .pad ? 300:150)
                                        }
                                        
                                    }.onTapGesture {
                                        viewModel.achieveToggle(achievement)
                                    }
                                }
                            }
                        }
                    }
                
                
                VStack {
                    Image(.collectibleIconText)
                        .resizable()
                        .scaledToFit()
                        .frame(height: GEDeviceManager.shared.deviceType == .pad ? 80:40)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.achievements.filter({ $0.category == .collectible }), id: \.self) { achievement in
                                ZStack {
                                    Image(achievement.image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: GEDeviceManager.shared.deviceType == .pad ? 400:200)
                                    
                                    
                                    if !achievement.isAchieved {
                                        Image(.lockIconGE)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: GEDeviceManager.shared.deviceType == .pad ? 300:150)
                                    }
                                    
                                }.onTapGesture {
                                    viewModel.achieveToggle(achievement)
                                }
                            }
                        }
                    }
                }
            }
                
                
                    
                
            }.padding(.top, GEDeviceManager.shared.deviceType == .pad ? 64:32)
            
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
    }
}

#Preview {
    AchievementsView(viewModel: AchievementsViewModel())
}
