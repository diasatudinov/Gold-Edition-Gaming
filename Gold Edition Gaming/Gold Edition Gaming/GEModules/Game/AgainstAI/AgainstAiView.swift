import SwiftUI

struct AgainstAiView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel = AgainstAiGameViewModel()
    @ObservedObject var shopVM: ShopViewModelGE
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                HStack(spacing:GEDeviceManager.shared.deviceType == .pad ? 25:50) {
                    
                    VStack(spacing: 5) {
                        HStack(alignment: .top) {
                            Button {
                                presentationMode.wrappedValue.dismiss()
                                
                            } label: {
                                Image(.backIconGE)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: GEDeviceManager.shared.deviceType == .pad ? 150:75)
                            }
                            VStack {
                                Text("P1")
                                    .font(.system(size: 30, weight: .black))
                                    .foregroundStyle(.white)
                                    .background(Color.black.opacity(0.2))
                                    .cornerRadius(10)
                                Image(viewModel.currentPlayer == .defender ? .goIconGE: .waitIconGE)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: GEDeviceManager.shared.deviceType == .pad ? 200:100, height: GEDeviceManager.shared.deviceType == .pad ? 160:80)
                            }
                        }
                        Spacer()
                        
                        HStack {
                            Button {
                                viewModel.undoLastMove()
                            } label: {
                                Image(.stepBackIconGE)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: GEDeviceManager.shared.deviceType == .pad ? 240:120)
                            }
                            
                        }
                        
                    }
                    
                    ZStack {
                        Color.black
                        VStack(spacing: 0) {
                            ForEach(0..<11, id: \.self) { row in
                                HStack(spacing: 0) {
                                    ForEach(0..<11, id: \.self) { col in
                                        CellView(
                                            row: row,
                                            col: col,
                                            piece: viewModel.board[row][col],
                                            isSelected: viewModel.selectedCell?.row == row && viewModel.selectedCell?.col == col
                                        )
                                        .onTapGesture {
                                            cellTapped(row: row, col: col)
                                        }
                                    }
                                }
                            }
                        }
                        
                    }.frame(width: GEDeviceManager.shared.deviceType == .pad ? 660:330, height: GEDeviceManager.shared.deviceType == .pad ? 660:330)
                        .padding(6)
                        .overlay {
                            Rectangle()
                                .stroke(borderColor(), lineWidth: GEDeviceManager.shared.deviceType == .pad ? 24:12)
                        }
                    
                    VStack {
                        Text("P2")
                            .font(.system(size: 30, weight: .black))
                            .foregroundStyle(.white)
                            .background(Color.black.opacity(0.2))
                            .cornerRadius(10)
                        Image(viewModel.currentPlayer == .attacker ? .goIconGE: .waitIconGE)
                            .resizable()
                            .scaledToFit()
                            .frame(width: GEDeviceManager.shared.deviceType == .pad ? 200:100, height: GEDeviceManager.shared.deviceType == .pad ? 160:80)
                        
                        Spacer()
                        
                        Button{
                            viewModel.gameOver = true
                            viewModel.gameResult = "Surrendered. \(viewModel.currentPlayer == .attacker ? "Defenders" : "Attackers") win."
                        } label: {
                            
                            Image(.giveUpIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: GEDeviceManager.shared.deviceType == .pad ? 300:150)
                        }
                        
                    }
                }
                
            }
            
            if viewModel.gameOver {
                
                ZStack {
                    Image(.gameOverBgGE)
                        .resizable()
                        .ignoresSafeArea()
                        .scaledToFill()
                        .scaleEffect(x: viewModel.isDefenderWin ? 1 : -1, y: 1)
                    
                    HStack {
                        Spacer()
                        VStack {
                            if !viewModel.isDefenderWin {
                                Image(.loseBgGE)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: GEDeviceManager.shared.deviceType == .pad ? 400:250)
                                
                            } else {
                                Image(.winBgGE)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: GEDeviceManager.shared.deviceType == .pad ? 400:250)
                                
                            }
                        }
                        //Spacer()
                        VStack {
                            Spacer()
                            Button {
                                viewModel.resetGame()
                            } label: {
                                Image(.restartBtnGE)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: GEDeviceManager.shared.deviceType == .pad ? 200:100)
                            }
                            
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image(.homeBtnGE)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: GEDeviceManager.shared.deviceType == .pad ? 200:100)
                            }
                        }
                        //Spacer()
                        VStack {
                            if viewModel.isDefenderWin {
                                Image(.loseBgGE)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: GEDeviceManager.shared.deviceType == .pad ? 400:250)
                                
                            } else {
                                Image(.winBgGE)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: GEDeviceManager.shared.deviceType == .pad ? 400:250)
                                
                            }
                        }
                        Spacer()
                    }
                    
                }
            }
        }.background(
            ZStack {
                if let bgImage = shopVM.currentBgItem {
                    Image("\(bgImage.image)")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                        .scaledToFill()
                }
                
            }
            
        )
    }
    
    func cellTapped(row: Int, col: Int) {
        if viewModel.gameOver { return }
        
        if let selected = viewModel.selectedCell {
            viewModel.movePiece(from: selected, to: (row, col))
            viewModel.selectedCell = nil
        } else {
            if viewModel.board[row][col].type != .none &&
                viewModel.isPieceBelongsToCurrentPlayer(viewModel.board[row][col]) {
                viewModel.selectedCell = (row, col)
            }
        }
    }
    
    func borderColor() -> Color {
        guard let currentPerson = shopVM.currentPersonItem else { return .clear }
        switch currentPerson.name {
        case "person1":
            return Color.appYellow
        case "person2":
            return Color.appOrange
        case "person3":
            return Color.appBlueBorder
        case "person4":
            return Color.appGreen
        default:
            return Color.appYellow
        }
        
    }
}

#Preview {
    AgainstAiView(shopVM: ShopViewModelGE())
}
