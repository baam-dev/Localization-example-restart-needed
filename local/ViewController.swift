//
//  ViewController.swift
//  local
//
//  Created by Amir Bakhshi on 2021-10-07.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
extension String {
    func localized() -> String {
        // Self referes to string that is being localized
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
