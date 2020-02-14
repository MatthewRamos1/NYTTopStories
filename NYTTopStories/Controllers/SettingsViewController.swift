//
//  SettingsViewController.swift
//  NYTTopStories
//
//  Created by Matthew Ramos on 2/6/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    private let settingsView = SettingsView()
    
    private let sections = ["Arts", "Automobiles", "Books", "Business", "Fashion", "Food", "Health", "Insider", "Magazine", "Movies", "NYRegion", "Obituaries", "Opinion", "Politics", "RealeEstate", "Science", "Sports", "SundayReview", "Technology", "Theater", "T-Magazine", "Travel", "Upshot", "US", "World"].sorted()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsView.pickerView.dataSource = self
        settingsView.pickerView.delegate = self
        
    }
    
    override func loadView() {
        view = settingsView
    }
 
}

extension SettingsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        sections.count
    }
    
    
}

extension SettingsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sections[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let sectionName = sections[row]
        UserDefaults.standard.set(sectionName, forKey: UserKey.sectionName)
    }
}
