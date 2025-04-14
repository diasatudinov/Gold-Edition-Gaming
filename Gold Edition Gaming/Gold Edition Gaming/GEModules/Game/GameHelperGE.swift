import SwiftUI

enum PieceType {
    case none
    case king
    case defender
    case attacker
}

enum AttackerSide: String {
    case squareFigureSL, triangleFigureSL, umbrellaFigureSL, CirecleFigureSL
}

enum Player: String {
    case attacker = "Атакующие"
    case defender = "Защитники"
}

struct Piece {
    var type: PieceType
    var attackerSide: AttackerSide? = nil
}

// Представление отдельной клетки
struct CellView: View {
    @StateObject var shopVM = ShopViewModelGE()
    
    var row: Int
    var col: Int
    var piece: Piece
    var isSelected: Bool = false
    var isCorner: Bool {
        return (row == 0 && col == 0) ||
        (row == 0 && col == 10) ||
        (row == 10 && col == 0) ||
        (row == 10 && col == 10)
    }
    var body: some View {
        ZStack {
            Rectangle()
                .fill((isSelected ? Color.green.opacity(0.3) : chessboardColor(row: row, col: col)))
                .frame(width: GEDeviceManager.shared.deviceType == .pad ? 60:30, height: GEDeviceManager.shared.deviceType == .pad ? 60:30)
                .border(Color.black.opacity(0.2), width: GEDeviceManager.shared.deviceType == .pad ? 2:1)
                .opacity(isCorner ? 0.5:1)
            if let currentPerson = shopVM.currentPersonItem {
                if piece.type == .attacker {
                    Image(currentPerson.attackerIcon)
                        .resizable()
                        .frame(width: GEDeviceManager.shared.deviceType == .pad ? 60:30, height: GEDeviceManager.shared.deviceType == .pad ? 60:30)
                } else if piece.type == .defender {
                    Image(currentPerson.defenderIcon)
                        .resizable()
                        .frame(width: GEDeviceManager.shared.deviceType == .pad ? 60:30, height: GEDeviceManager.shared.deviceType == .pad ? 60:30)
                } else if piece.type == .king {
                    Image(currentPerson.kingIcon)
                        .resizable()
                        .frame(width: GEDeviceManager.shared.deviceType == .pad ? 60:30, height: GEDeviceManager.shared.deviceType == .pad ? 60:30)
                } else if piece.type != .none {
                    Circle()
                        .fill(colorForPiece(piece.type))
                        .frame(width: GEDeviceManager.shared.deviceType == .pad ? 60:30, height: GEDeviceManager.shared.deviceType == .pad ? 60:30)
                }
            }
        }
    }
    
    func colorForPiece(_ type: PieceType) -> Color {
        switch type {
        case .king:
            return .yellow
        case .defender:
            return .blue
        case .attacker:
            return .red
        default:
            return .clear
        }
    }
    
    func chessboardColor(row: Int, col: Int) -> Color {
        guard let currentPerson = shopVM.currentPersonItem else { return .clear }
        switch currentPerson.name {
        case "person1":
            return (row + col).isMultiple(of: 2) ? Color.appMint : Color.appBrown
        case "person2":
            return (row + col).isMultiple(of: 2) ? Color.appPink : Color.appYellow
        case "person3":
            return (row + col).isMultiple(of: 2) ? Color.appBlue : Color.appYellow
        case "person4":
            return (row + col).isMultiple(of: 2) ? Color.appRed : Color.appYellow
        default:
            return (row + col).isMultiple(of: 2) ? Color.appMint : Color.appBrown
        }
       
    }
}
