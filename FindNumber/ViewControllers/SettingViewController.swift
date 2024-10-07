//
//  SettingViewController.swift
//  FindNumber
//
//  Created by Никита Тыщенко on 06.08.2024.
//

import UIKit

final class SettingViewController: UITableViewController {
    @IBOutlet private var timeStateSwitch: UISwitch!
    @IBOutlet private var timePickerView: UIPickerView!
    
    private let timeForGame = [20,30,40,50,60]
    private let storage = StorageManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePickerView.dataSource = self
        timePickerView.delegate = self
        loadSettings()
    }

    @IBAction func timeStateAction() {
        storage.save(
            key: KeysUserDefaults.timerState.rawValue,
            value: timeStateSwitch.isOn
        )
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeStateSwitch.isOn ? 2 : 1
    }
    
    func loadSettings() {
        let timeValueLoad = storage.load(
            key: KeysUserDefaults.timeValue.rawValue,
            type: Int.self
        ) ?? 0
        
        timePickerView.selectRow(
            timeForGame.firstIndex(of: timeValueLoad) ?? 0,
            inComponent: 0,
            animated: true
        )
        
        timeStateSwitch.isOn = storage.load(
            key: KeysUserDefaults.timerState.rawValue,
            type: Bool.self
        ) ?? true
    }
    
}

extension SettingViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        timeForGame.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       String(timeForGame[row])

    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        storage.save(key: KeysUserDefaults.timeValue.rawValue, value: timeForGame[row])
    }
}
