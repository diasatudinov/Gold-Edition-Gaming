//
//  MoneyBgGE.swift
//  Gold Edition Gaming
//
//  Created by Dias Atudinov on 11.04.2025.
//

import SwiftUI

struct MoneyBgGE: View {
    @StateObject var user = DCUser.shared
    var body: some View {
        ZStack {
            Image(.moneyBgGE)
                .resizable()
                .scaledToFit()
            
            Text("\(user.money)")
                .font(.system(size: GEDeviceManager.shared.deviceType == .pad ? 40:20, weight: .black))
                .foregroundStyle(.white)
                .textCase(.uppercase)
            
            
            
        }.frame(height: GEDeviceManager.shared.deviceType == .pad ? 126:63)
        
    }
}

#Preview {
    MoneyBgGE()
}
