//
//  MainViewController.swift
//  BrewMock
//
//  Created by Adrià Abella on 22/10/2019.
//  Copyright © 2019 AdriaAbella. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var toggleSwitch: UISwitch!
    
    var dataModel: DataModel?
    
    // -- UIViewController
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        dataModel = (UIApplication.shared.delegate as! AppDelegate).dataModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // -- UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let search = textField.text {
            searchBeersForFood(search, toggleSwitch.isOn)
        } else {
            print("Invalid search string")
        }
        self.view.endEditing(true)
        return false
    }
    
    // -- ViewModel
    
    func searchBeersForFood(_ searchString: String, _ ascendingABV: Bool) {
        // TODO
        print("searchBeersForFood "+searchString+" "+String(ascendingABV))
    }
    
}

