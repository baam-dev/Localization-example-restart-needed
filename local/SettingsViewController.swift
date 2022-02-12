//
//  SettingsViewController.swift
//  local
//
//  Created by Amir Bakhshi on 2021-10-07.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private let supportedLanguages = ["Swedish".localized(), "English".localized()]
    private let currentLang = Locale.current.languageCode!
    private var selectedIndexes = [[IndexPath.init(row: 0, section: 0)]]
    private let sectionHeaders = ["Language".localized(), "Others".localized()]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        makeCurrentLangSelected()
    }
    
    var availableLanguages: [String] {
        var availableLanguages = Bundle.main.localizations
        if let indexOfBase = availableLanguages.firstIndex(of: "Base") {
            availableLanguages.remove(at: indexOfBase)
        }
        return availableLanguages
    }
    
    private func changeLanguage(langCode: String) {
        UserDefaults.standard.set([langCode], forKey: "AppleLanguages")
    }
    
    private func makeCurrentLangSelected() {
        if currentLang == "en" {
            selectedIndexes = [[IndexPath.init(row: 1, section: 0)]]
        } else if currentLang == "sv" {
            selectedIndexes = [[IndexPath.init(row: 0, section: 0)]]
        }
    }
    
}

//MARK: - TableView methods
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return supportedLanguages.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = supportedLanguages[indexPath.row]
        cell.selectionStyle = .none
        let selectedIndex = self.selectedIndexes[indexPath.section]
        if selectedIndex.contains(indexPath) {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let infoLabel = UILabel(frame: CGRect(x: 10, y: 0, width: view.frame.size.width - 20, height: 50))
        infoLabel.textColor = .secondaryLabel
        infoLabel.numberOfLines = 0
        infoLabel.font = UIFont(name: "Helvetica", size: 14)
        infoLabel.text = "Changing language requires the app to be restarted.".localized()
        footerView.addSubview(infoLabel as UIView)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        // If current cell is not present in selectedIndexes
        if !self.selectedIndexes[indexPath.section].contains(indexPath) {
            // mark it checked
            cell?.accessoryType = .checkmark
            // Remove any previous selected indexpath
            self.selectedIndexes[indexPath.section].removeAll()
            // add currently selected indexpath
            self.selectedIndexes[indexPath.section].append(indexPath)
            let cellTitle = cell?.textLabel?.text!
            
            if cellTitle == "Swedish" {
                changeLanguage(langCode: "sv")
            } else {
                changeLanguage(langCode: "en")
            }
            tableView.reloadData()
        }
    }
}
