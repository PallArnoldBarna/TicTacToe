//
//  GameState.swift
//  TicTacToe
//
//  Created by Páll Arnold-Barna on 24.04.2024.
//

import Foundation

class GameState: ObservableObject {
    @Published var board = [[Cell]]()
    @Published var turn = Tile.Cross
    @Published var noughtsScore = 0
    @Published var crossesScore = 0
    @Published var showAlert = false
    @Published var alertMessage = "Draw"
    
    init() {
        resetBoard(size: 3)
    }
    
    func turnText() -> String {
        return turn == Tile.Cross ? "Turn: X" : "Turn: O"
    }
    
    func placeTile(_ row: Int, _ column: Int) {
        if board[row][column].tile != Tile.Empty {
            return
        }
        board[row][column].tile = turn == Tile.Cross ? Tile.Cross : Tile.Nought
        
        if checkForVictory() {
            if turn == Tile.Cross {
                crossesScore += 1
            } else {
                noughtsScore += 1
            }
            let winner = turn == Tile.Cross ? "Crosses" : "Noughts"
            alertMessage = winner + " win!"
            showAlert = true
        } else {
            turn = turn == Tile.Cross ? Tile.Nought : Tile.Cross
        }
        
        if checkForDraw() {
            alertMessage = "Draw"
            showAlert = true
        }
    }
    
    func checkForDraw() -> Bool {
        for row in board {
            for cell in row {
                if cell.tile == Tile.Empty {
                    return false
                }
            }
        }
        return true
    }
    
    func checkForVictory() -> Bool {
        let matchingCount: Int
        
        switch board.count {
        case 3:
            matchingCount = 3
        case 4:
            matchingCount = 3
        case 5:
            matchingCount = 4
        case 6:
            matchingCount = 5
        default:
            fatalError("Unsupported board size")
        }
        
        // Check rows
        for row in board {
            if hasMatchingTiles(row, matchingCount: matchingCount) {
                return true
            }
        }
        
        // Check columns
        for columnIndex in 0..<board.count {
            let column = board.map { $0[columnIndex] }
            if hasMatchingTiles(column, matchingCount: matchingCount) {
                return true
            }
        }
        
        // Check diagonals
        let diagonal1 = (0..<board.count).map { board[$0][$0] }
        if hasMatchingTiles(diagonal1, matchingCount: matchingCount) {
            return true
        }
        
        let diagonal2 = (0..<board.count).map { board[$0][board.count - $0 - 1] }
        if hasMatchingTiles(diagonal2, matchingCount: matchingCount) {
            return true
        }
        
        let diagonal3 = (0..<board.count - 1).map { board[$0][$0 + 1] }
        if hasMatchingTiles(diagonal3, matchingCount: matchingCount) {
            return true
        }
        
        let diagonal4 = (0..<board.count - 1).map { board[$0][board.count - $0 - 2] }
        if hasMatchingTiles(diagonal4, matchingCount: matchingCount) {
            return true
        }
        
        let diagonal5 = (0..<board.count - 1).map { board[$0 + 1][$0] }
        if hasMatchingTiles(diagonal5, matchingCount: matchingCount) {
            return true
        }
        
        let diagonal6: [Cell] = (0..<board.count - 1).map { index in
            let row = index + 1
            let column = board.count - index - 1
            return board[row][column]
        }
        if hasMatchingTiles(diagonal6, matchingCount: matchingCount) {
            return true
        }
        
        return false
    }
    
    private func hasMatchingTiles(_ tiles: [Cell], matchingCount: Int) -> Bool {
        var count = 0
        for tile in tiles {
            if tile.tile == turn {
                count += 1
                if count == matchingCount {
                    return true
                }
            } else {
                count = 0
            }
        }
        return false
    }
    
    func resetBoard(size: Int) {
        var newBoard = [[Cell]]()
        
        for _ in 0...size-1 {
            var row = [Cell]()
            for _ in 0...size-1 {
                row.append(Cell(tile: Tile.Empty))
            }
            newBoard.append(row)
        }
        board = newBoard
    }
}
