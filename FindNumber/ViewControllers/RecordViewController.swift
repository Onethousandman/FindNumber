//
//  RecordViewController.swift
//  FindNumber
//
//  Created by Никита Тыщенко on 06.10.2024.
//

import UIKit

final class RecordViewController: UIViewController {
    @IBOutlet private var recordLabel: UILabel!
    
    private let storage = StorageManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showRecord()
    }
    
    func showRecord() {
        let record = storage.load(
            key: KeysUserDefaults.recordGame.rawValue,
            type: Int.self
        )
        
        if record != 0 {
            recordLabel.text = "Ваш рекорд - \(record ?? 0)"
        } else {
            recordLabel.text = "Рекорд не установлен"
        }
    }
}
