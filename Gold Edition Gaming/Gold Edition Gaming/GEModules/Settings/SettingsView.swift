import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var settingsVM: SettingsViewModelGE
    var body: some View {
        ZStack {
            
            ZStack {
                Image(.settingsViewBgGE)
                    .resizable()
                    .scaledToFit()
                VStack(spacing: 30) {
                    HStack {
                        Image(.soundIconGE)
                            .resizable()
                            .scaledToFit()
                            .frame(height: GEDeviceManager.shared.deviceType == .pad ? 80:40)
                        VStack {
                            Image(.soundTextGE)
                                .resizable()
                                .scaledToFit()
                                .frame(height: GEDeviceManager.shared.deviceType == .pad ? 30:15)
                            Button {
                                withAnimation {
                                    settingsVM.soundEnabled.toggle()
                                }
                            } label: {
                                
                                Image(settingsVM.soundEnabled ? .onIconGE:.offIconGE)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: GEDeviceManager.shared.deviceType == .pad ? 40:20)
                            }
                        }
                    }
                    
                    HStack {
                        Image(.musicIconGE)
                            .resizable()
                            .scaledToFit()
                            .frame(height: GEDeviceManager.shared.deviceType == .pad ? 110:55)
                        VStack {
                            Image(.musicTextGE)
                                .resizable()
                                .scaledToFit()
                                .frame(height: GEDeviceManager.shared.deviceType == .pad ? 30:15)
                            Button {
                                withAnimation {
                                    settingsVM.musicEnabled.toggle()
                                }
                            } label: {
                                
                                Image(settingsVM.musicEnabled ? .onIconGE:.offIconGE)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: GEDeviceManager.shared.deviceType == .pad ? 40:20)
                            }
                        }
                    }
                }
            }.frame(height: GEDeviceManager.shared.deviceType == .pad ? 600:300)
            
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
    SettingsView(settingsVM: SettingsViewModelGE())
}
