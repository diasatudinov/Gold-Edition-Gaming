import SwiftUI
import AVFoundation

class TwoPlayersGameViewModel: ObservableObject {
    @Published var board: [[Piece]] = Array(
        repeating: Array(repeating: Piece(type: .none), count: 11),
        count: 11
    )
    @Published var selectedCell: (row: Int, col: Int)? = nil
    @Published var gameOver: Bool = false
    @Published var gameResult: String = ""
    @Published var currentPlayer: Player = .attacker
    @Published var isDefenderWin = false
    
    private var moveHistory: [([[Piece]], Player)] = []
    
    var audioPlayer: AVAudioPlayer?
    
    let settingsVM = SettingsViewModelGE()
    init() {
        setupBoard()
    }
    
    func resetGame() {
        gameOver = false
        isDefenderWin = false
        gameResult = ""
        selectedCell = nil
        currentPlayer = .attacker
        moveHistory.removeAll()
        setupBoard()
    }
    
    func playTapSound() {
                if settingsVM.soundEnabled {
                    guard let url = Bundle.main.url(forResource: "stepSoundGE", withExtension: "mp3") else { return }
                    do {
                        audioPlayer = try AVAudioPlayer(contentsOf: url)
                        audioPlayer?.play()
                    } catch {
                        print("Ошибка воспроизведения звука: \(error)")
                    }
                }
    }
    
    func isCorner(row: Int, col: Int) -> Bool {
        return (row == 0 && col == 0) ||
        (row == 0 && col == 10) ||
        (row == 10 && col == 0) ||
        (row == 10 && col == 10)
    }
    
    func setupBoard() {
        board = Array(
            repeating: Array(repeating: Piece(type: .none), count: 11),
            count: 11
        )
        let center = 5
        board[center][center] = Piece(type: .king)
        
        let defenders: [(Int, Int)] = [
            (center - 1, center), (center + 1, center),
            (center, center - 1), (center, center + 1),
            (center - 1, center - 1), (center - 1, center + 1),
            (center + 1, center - 1), (center + 1, center + 1),
            (center - 2, center), (center + 2, center),
            (center, center - 2), (center, center + 2)
        ]
        for pos in defenders {
            if isCorner(row: pos.0, col: pos.1) { continue }
            board[pos.0][pos.1] = Piece(type: .defender)
        }
        
        let attackersPositions: [(Int, Int)] = [
            (0, 3), (0, 4), (0, 5), (0, 6), (0, 7),
            (10, 3), (10, 4), (10, 5), (10, 6), (10, 7),
            (3, 0), (4, 0), (5, 0), (6, 0), (7, 0),
            (3, 10), (4, 10), (5, 10), (6, 10), (7, 10),
            
            (1, 5),
            (5, 1),
            (9, 5),
            (5, 9)
        ]
        
        for pos in attackersPositions {
            if isCorner(row: pos.0, col: pos.1) { continue }
            let side: AttackerSide
            if pos.0 == 0 || pos.0 == 1 {
                side = .triangleFigureSL
            } else if pos.0 == 10 || pos.0 == 9 {
                side = .squareFigureSL
            } else if pos.1 == 0 || pos.1 == 1 {
                side = .CirecleFigureSL
            } else if pos.1 == 10 || pos.1 == 9 {
                side = .umbrellaFigureSL
            } else {
                side = .triangleFigureSL
            }
            board[pos.0][pos.1] = Piece(type: .attacker, attackerSide: side)
        }
    }
    
    
    func isPieceBelongsToCurrentPlayer(_ piece: Piece) -> Bool {
        switch currentPlayer {
        case .attacker:
            return piece.type == .attacker
        case .defender:
            return piece.type == .defender || piece.type == .king
        }
    }
    
    func movePiece(from: (Int, Int), to: (Int, Int)) {
        if board[to.0][to.1].type != .none { return }
        if isCorner(row: to.0, col: to.1) {
            if board[from.0][from.1].type != .king { return }
        }
        if from.0 != to.0 && from.1 != to.1 { return }
        if !isPathClear(from: from, to: to) { return }
        
        let movingPiece = board[from.0][from.1]
        if !isPieceBelongsToCurrentPlayer(movingPiece) { return }
        
        moveHistory.append((board, currentPlayer))
        
        board[from.0][from.1] = Piece(type: .none)
        board[to.0][to.1] = movingPiece
        
        playTapSound()
        
        if movingPiece.type == .king && isCorner(row: to.0, col: to.1) {
            gameOver = true
            isDefenderWin = true
            GEUser.shared.updateUserMoney(for: 200)
            gameResult = "Defenders win! The king has escaped."
            return
        }
        
        checkCaptures(around: to, movingPiece: movingPiece)
        checkKingCapture()
        
        if !gameOver {
            switchTurn()
        }
    }
    
    func undoLastMove() {
        guard let last = moveHistory.popLast() else { return }
        self.board = last.0
        self.currentPlayer = last.1
        self.selectedCell = nil
        self.gameOver = false
        self.gameResult = ""
        self.isDefenderWin = false
    }
    
    func switchTurn() {
        currentPlayer = currentPlayer == .attacker ? .defender : .attacker
    }
    
    func isPathClear(from: (Int, Int), to: (Int, Int)) -> Bool {
        if from.0 == to.0 {
            let range = from.1 < to.1 ? (from.1 + 1)..<to.1 : (to.1 + 1)..<from.1
            for col in range {
                if board[from.0][col].type != .none { return false }
            }
        } else if from.1 == to.1 {
            let range = from.0 < to.0 ? (from.0 + 1)..<to.0 : (to.0 + 1)..<from.0
            for row in range {
                if board[row][from.1].type != .none { return false }
            }
        }
        return true
    }
    
    func checkCaptures(around pos: (Int, Int), movingPiece: Piece) {
        let directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]
        for direction in directions {
            let enemyRow = pos.0 + direction.0
            let enemyCol = pos.1 + direction.1
            let allyRow = enemyRow + direction.0
            let allyCol = enemyCol + direction.1
            
            if isValid(row: enemyRow, col: enemyCol) && isValid(row: allyRow, col: allyCol) {
                let enemyPiece = board[enemyRow][enemyCol]
                
                if enemyPiece.type != .none &&
                    enemyPiece.type != movingPiece.type &&
                    enemyPiece.type != .king {
                    let allyPiece = board[allyRow][allyCol]
                    
                    if allyPiece.type == movingPiece.type || allyPiece.type == .king || isCorner(row: allyRow, col: allyCol) {
                        board[enemyRow][enemyCol] = Piece(type: .none)
                    }
                }
            }
        }
    }
    
    func checkKingCapture() {
        for row in 0..<11 {
            for col in 0..<11 {
                if board[row][col].type == .king {
                    let directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]
                    var surroundCount = 0
                    for direction in directions {
                        let adjRow = row + direction.0
                        let adjCol = col + direction.1
                        if !isValid(row: adjRow, col: adjCol) {
                            surroundCount += 1
                        }
                        else if board[adjRow][adjCol].type == .attacker || isCorner(row: adjRow, col: adjCol) {
                            surroundCount += 1
                        }
                    }
                    let required = isOnEdge(row: row, col: col) ? 3 : 4
                    if surroundCount >= required {
                        gameOver = true
                        isDefenderWin = false
                        gameResult = "Attackers win! King captured."
                    }
                    return
                }
            }
        }
    }
    
    func isOnEdge(row: Int, col: Int) -> Bool {
        return row == 0 || row == 10 || col == 0 || col == 10
    }
    
    func isValid(row: Int, col: Int) -> Bool {
        return row >= 0 && row < 11 && col >= 0 && col < 11
    }
}
