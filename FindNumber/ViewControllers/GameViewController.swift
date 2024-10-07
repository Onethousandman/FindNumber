//
//  ViewController.swift
//  FindNumber
//
//  Created by Никита Тыщенко on 18.07.2024.
//

import UIKit


final class GameViewController: UIViewController {
    @IBOutlet private var circleImage: UIImageView!
    @IBOutlet private var statusGameLabel: UILabel!
    @IBOutlet private var startGameLabel: UILabel!
    @IBOutlet private var nextDigitLabel: UILabel!
    @IBOutlet private var timerLabel: UILabel!
    @IBOutlet private var newGameButton: UIButton!
    @IBOutlet private var buttons: [UIButton]!
    
    private var game = Game(countItems: 16)
    private let storage = StorageManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        setupScreen()
    }

    @IBAction func pressButton(_ sender: Any) {
        guard let buttonIndex = buttons.firstIndex(of: sender as! UIButton) else { return }
        game.checkItem(index: buttonIndex)
        updateUI()
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        
        sender.isHidden = true
        setupScreen()
    }
    
    @IBAction func mainAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    private func setupScreen() {
        updateInfoGame(with: game.status)
        
        for index in game.items.indices {
            buttons[index].setTitle(game.items[index].title, for: .normal)
            toggleButtons(index)
        }
        
        nextDigitLabel.text = game.nextItem?.title
        timerLabel.text = game.secondsGame.secondsToString()
        
        game.updateHandler = { [weak self] counter in
            guard let self = self else { return }
            self.timerLabel.text = counter.secondsToString()
            self.updateInfoGame(with: game.status)
        }
    }
    
    private func updateUI() {
        for index in game.items.indices {
            toggleButtons(index)
            
            if game.items[index].isError {
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.buttons[index].backgroundColor = .red
                } completion: { [weak self] _ in
                    self?.buttons[index].backgroundColor = .clear
                    self?.game.items[index].isError.toggle()
                }

            }
        }
        nextDigitLabel.text = game.nextItem?.title
        updateInfoGame(with: game.status)
    }
    
    private func updateInfoGame(with status: StatusGame) {
        switch status {
        case .start:
            startGameLabel.isHidden = false
            statusGameLabel.isHidden = true
            newGameButton.isHidden = true
            timerLabel.isHidden = false
            nextDigitLabel.isHidden = false
            circleImage.isHidden = false
        case .win:
            startGameLabel.isHidden = true
            statusGameLabel.isHidden = false
            statusGameLabel.text = "YOU WIN!"
            statusGameLabel.textColor = .green
            newGameButton.isHidden = false
            nextDigitLabel.isHidden = true
            timerLabel.isHidden = true
            circleImage.isHidden = true
            if game.isNewRecord {
                showAlert()
            }
        case .lose:
            startGameLabel.isHidden = true
            statusGameLabel.isHidden = false
            statusGameLabel.text = "YOU LOSE!"
            statusGameLabel.textColor = .red
            newGameButton.isHidden = false
            nextDigitLabel.isHidden = true
            timerLabel.isHidden = true
            circleImage.isHidden = true
            for index in game.items.indices {
                buttons[index].alpha = 0
                buttons[index].isEnabled = false
            }
        }
    }
    
    private func toggleButtons(_ index: Int) {
        buttons[index].alpha = game.items[index].isFound ? 0 : 1
        buttons[index].isEnabled = !game.items[index].isFound
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Поздравляем!",
            message: "Вы установили новый рекорд",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(
            title: "ОК",
            style: .default,
            handler: nil
        )
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}

extension Int {
    func secondsToString() -> String {
        let minutes = self / 60
        let seconds = self % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

