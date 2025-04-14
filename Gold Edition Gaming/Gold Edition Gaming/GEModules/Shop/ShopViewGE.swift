import SwiftUI

enum ShopSection: Codable, Hashable {
    case backgrounds
    case persons
}

struct ShopViewGE: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var user = GEUser.shared
    @State var section: ShopSection = .backgrounds
    @ObservedObject var viewModel: ShopViewModelGE
    var body: some View {
        ZStack {
            
            VStack {
                
                Image(section == .backgrounds ? .bgItemsGE : .personItemsGE)
                    .resizable()
                    .scaledToFit()
                    .frame(height: GEDeviceManager.shared.deviceType == .pad ? 160:80)
                    .onTapGesture {
                        withAnimation {
                            if section == .backgrounds {
                                section = .persons
                            } else {
                                section = .backgrounds
                            }
                        }
                    }
                Spacer()
                HStack(spacing: GEDeviceManager.shared.deviceType == .pad ? 60:30) {
                    if section == .backgrounds {
                        ForEach(viewModel.shopTeamItems.filter({ $0.section == .backgrounds }), id: \.self) { item in
                            ZStack {
                                Image(item.icon)
                                    .resizable()
                                    .scaledToFit()
                                
                                if viewModel.boughtItems.contains(where: { $0.name == item.name }) {
                                    VStack {
                                        Spacer()
                                        ZStack {
                                            Image(.btnBgGE)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: GEDeviceManager.shared.deviceType == .pad ? 100:50)
                                            if let currentItem = viewModel.currentBgItem, currentItem.name == item.name {
                                                Image(.stickGE)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: GEDeviceManager.shared.deviceType == .pad ? 70:35)
                                            } else {
                                                Text("Select")
                                                    .foregroundStyle(.black)
                                                    .font(.system(size: GEDeviceManager.shared.deviceType == .pad ? 40:20, weight: .bold))
                                            }
                                            
                                        }
                                    }
                                } else {
                                    
                                    VStack {
                                        Spacer()
                                        Image(.lockIconGE)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: GEDeviceManager.shared.deviceType == .pad ? 160:80)
                                        Spacer()
                                        ZStack {
                                            Image(.btnBgGE)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: GEDeviceManager.shared.deviceType == .pad ? 100:50)
                                            
                                            Text("\(item.price)")
                                                .font(.system(size: GEDeviceManager.shared.deviceType == .pad ? 40:20, weight: .bold))
                                                .foregroundStyle(.black)
                                            
                                        }
                                    }
                                    
                                }
                            }.frame(height: GEDeviceManager.shared.deviceType == .pad ? 500:250)
                                .onTapGesture {
                                    if viewModel.boughtItems.contains(where: { $0.name == item.name }) {
                                        viewModel.currentBgItem = item
                                    } else {
                                        if !viewModel.boughtItems.contains(where: { $0.name == item.name }) {
                                            if user.money >= item.price {
                                                user.minusUserMoney(for: item.price)
                                                viewModel.boughtItems.append(item)
                                            }
                                        }
                                    }
                                }
                        }
                    } else {
                        ForEach(viewModel.shopTeamItems.filter({ $0.section == .persons }), id: \.self) { item in
                            ZStack {
                                Image(item.icon)
                                    .resizable()
                                    .scaledToFit()
                                
                                
                                if viewModel.boughtItems.contains(where: { $0.name == item.name }) {
                                    VStack {
                                        Spacer()
                                        ZStack {
                                            Image(.btnBgGE)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: GEDeviceManager.shared.deviceType == .pad ? 100:50)
                                            if let currentItem = viewModel.currentPersonItem, currentItem.name == item.name {
                                                Image(.stickGE)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: GEDeviceManager.shared.deviceType == .pad ? 70:35)
                                            } else {
                                                Text("Select")
                                                    .foregroundStyle(.black)
                                                    .font(.system(size: GEDeviceManager.shared.deviceType == .pad ? 40:20, weight: .bold))
                                            }
                                            
                                        }
                                    }
                                } else {
                                    VStack {
                                        Spacer()
                                        Image(.lockIconGE)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: GEDeviceManager.shared.deviceType == .pad ? 160:80)
                                        Spacer()
                                        ZStack {
                                            Image(.btnBgGE)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: GEDeviceManager.shared.deviceType == .pad ? 100:50)
                                            
                                            Text("\(item.price)")
                                                .font(.system(size: GEDeviceManager.shared.deviceType == .pad ? 40:20, weight: .bold))
                                                .foregroundStyle(.black)
                                            
                                        }
                                    }
                                }
                                
                                
                            }.frame(height: GEDeviceManager.shared.deviceType == .pad ? 500:250)
                                .onTapGesture {
                                    if viewModel.boughtItems.contains(where: { $0.name == item.name }) {
                                        viewModel.currentPersonItem = item
                                    } else {
                                        if !viewModel.boughtItems.contains(where: { $0.name == item.name }) {
                                            
                                            if user.money >= item.price {
                                                user.minusUserMoney(for: item.price)
                                                viewModel.boughtItems.append(item)
                                            }
                                        }
                                    }
                                }
                        }
                    }
                }
                Spacer()
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
                        
                        MoneyBgGE()
                    }.padding([.horizontal, .top])
                }
                Spacer()
            }
            
        }.background(
            Image(.bgLoaderGE)
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .scaledToFill()
            
        )
    }
}

#Preview {
    ShopViewGE(viewModel: ShopViewModelGE())
}
