//
//  ContentView.swift
//  TicTacToe
//
//  Created by Páll Arnold-Barna on 24.04.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var gameState = GameState()
    @State var showPicker = false
    @State var selection = 0
    @State var boardSize = 3
    @State var gameFinished = false
    let borderSize = CGFloat(5)
    let sizeOptions = [3, 4, 5, 6]
    
    var body: some View {
        Text(gameState.turnText())
            .font(.title)
            .bold()
            .padding()
        HStack {
            Text(String(format: "Crosses: %d", gameState.crossesScore))
                .font(.title)
                .bold()
            .padding()
            Text(String(format: "Noughts: %d", gameState.noughtsScore))
                .font(.title)
                .bold()
                .padding()
        }
        Spacer()
        VStack(spacing: borderSize) {
            ForEach(0...boardSize-1, id: \.self) { row in
                HStack(spacing: borderSize) {
                    ForEach(0...boardSize-1, id: \.self) { column in
                        let cell = gameState.board[row][column]
                        Text(cell.displayTile())
                            .font(.system(size: CGFloat(180/boardSize)))
                            .foregroundColor(cell.tileColor())
                            .bold()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .aspectRatio(1, contentMode: .fit)
                            .background(Color.white)
                            .onTapGesture {
                                if !gameFinished {
                                    gameState.placeTile(row, column)
                                }
                            }
                    }
                }
            }
        }
        .background(Color.black)
        .padding()
        .alert(isPresented: $gameState.showAlert) {
            Alert(
                title: Text(gameState.alertMessage),
                dismissButton: .default(Text("Ok")) {
                    gameFinished = true
                }
            )
        }
        VStack {
            Button(action: {
                gameFinished = false
                gameState.resetBoard(size: boardSize)
            }, label: {
                Text("Reset")
            })
            .buttonStyle(BorderedProminentButtonStyle())
            .tint(.cyan)
            Button(action: {
                self.showPicker = true
            }, label: {
                Text("Select board size")
            })
            .buttonStyle(BorderedProminentButtonStyle())
            .tint(.indigo)
            .sheet(isPresented: $showPicker, content: {
                VStack {
                    Text("Select board size")
                        .padding(.bottom, 20)
                        .font(.headline)
                    Picker(selection: $selection, label: Text("Select board size")) {
                        ForEach(0..<sizeOptions.count) { index in
                            Text(String(self.sizeOptions[index])).tag(index)
                        }
                    }
                    .onChange(of: selection, perform: { value in
                        gameFinished = false
                        boardSize = sizeOptions[value]
                        gameState.resetBoard(size: boardSize)
                    })
                }
                .pickerStyle(.palette)
                .presentationDetents([.height(180)])
            })
        }
        Spacer()
    }
}

#Preview {
    ContentView()
}
