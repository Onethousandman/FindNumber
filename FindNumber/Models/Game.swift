//
//  Game.swift
//  FindNumber
//
//  Created by Никита Тыщенко on 18.07.2024.
//

import Foundation

enum StatusGame {
    case start
    case win
    case lose
}

final class Game {
    
    static let shared = Game(countItems: 16)
    
    var items: [Item] = []
    var nextItem: Item?
    var isNewRecord = false
    var updateHandler: ((Int) -> Void)?
    
    var status: StatusGame = .start {
        didSet {
            if status != .start {
                saveRecord()
                stopGame()
            }
        }
    }
    
    var secondsGame: Int {
        didSet {
            if secondsGame == 0 {
                status = .lose
            }
        }
    }
    
    private let timeForGame: Int
    private let numbers = Array(1...99)
    private var countItems: Int
    private var timer: Timer?
    private let storage = StorageManager.shared
    
    init(countItems: Int) {
        self.countItems = countItems
        self.timeForGame = storage.load(
            key: KeysUserDefaults.timeValue.rawValue,
            type: Int.self
        ) ?? 0
        self.secondsGame = timeForGame
        setupGame()
    }
    
    func checkItem(index: Int) {
        guard status == .start else { return }
        if items[index].title == nextItem?.title {
            items[index].isFound.toggle()
            nextItem = items.shuffled().first(where: { !$0.isFound })
        } else {
            items[index].isError.toggle()
        }
        
        if nextItem == nil {
            status = .win
        }
    }
    
    func newGame() {
        status = .start
        secondsGame = timeForGame
        setupGame()
    }
    
    func stopGame() {
        timer?.invalidate()
        timer = nil
    }
    
    private func setupGame() {
        isNewRecord = false
        let timerState = storage.load(
            key: KeysUserDefaults.timerState.rawValue,
            type: Bool.self
        ) ?? true
        var digits = numbers.shuffled()
        items.removeAll()
        while items.count < countItems {
            let item = Item(title: String(digits.removeFirst()), isFound: false, isError: false)
            items.append(item)
        }
        nextItem = items.shuffled().first
        
        if timerState {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
                guard let self = self else { return }
                self.secondsGame -= 1
                self.updateHandler?(self.secondsGame)
            })
        }
    }
    
    private func saveRecord() {
        if status == .win {
            let newRecord = timeForGame - secondsGame
            let record = storage.load(
                key: KeysUserDefaults.recordGame.rawValue,
                type: Int.self
            ) ?? 0
            
            if record == 0 || newRecord < record {
                storage.save(key: KeysUserDefaults.recordGame.rawValue, value: newRecord)
                isNewRecord = true
            }
        }
    }
}

struct Item {
    let title: String
    var isFound: Bool
    var isError: Bool
}


