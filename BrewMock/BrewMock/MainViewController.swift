//
//  MainViewController.swift
//  BrewMock
//
//  Created by Adrià Abella on 22/10/2019.
//  Copyright © 2019 AdriaAbella. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var toggleSwitch: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func onToggleSwitchValueChanged(_ sender: Any) {
        updateBeersList()
    }
    
    var dataModel: DataModel?
    
    // MARK: UIViewController
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        tableView?.delegate = self
        tableView?.dataSource = self
        dataModel = (UIApplication.shared.delegate as! AppDelegate).dataModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        tableView?.delegate = self
        tableView?.dataSource = self
        dataModel = (UIApplication.shared.delegate as! AppDelegate).dataModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let search = textField.text {
            searchBeersForFood(search, toggleSwitch.isOn)
        } else {
            print("Invalid search string")
        }
        self.view.endEditing(true)
        return false
    }
    
    // MARK: UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel?.currentData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prototypecell") as! BeerTableViewCell
        cell.nameLabel.text = dataModel?.currentData[indexPath.item].name
        cell.taglineLabel.text = dataModel?.currentData[indexPath.item].tagline
        cell.abvLabel.text = NSString(format: "ABV: %.2f%%", (dataModel?.currentData[indexPath.item].abv)!) as String
        cell.descriptionLabel.text = dataModel?.currentData[indexPath.item].description
        do {
            if let url = dataModel?.currentData[indexPath.item].image_url {
                try cell.thumbnailImage.image = UIImage.init(data: Data.init(contentsOf: URL.init(string: url)!))
            }
        } catch { }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170;
    }
    
    // MARK: ViewModel
    
    func searchBeersForFood(_ searchString: String, _ ascendingABV: Bool) {
        // TODO: Improve input filtering
        print("searchBeersForFood "+searchString+" "+String(ascendingABV))
        if searchString == "" { return }
        dataModel?.searchBeersForFood(searchString, completionHandler: updateBeersList)
    }
    
    func updateBeersList() {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                print("Reload table")
                // TODO: More efficient sort
                // TODO: Pre-sort the current list (?)
                self.dataModel?.currentData = (self.dataModel?.currentData.sorted(by: self.beerSort))!
                self.tableView.reloadData()
                if self.tableView.numberOfRows(inSection: 0) > 0 {
                    let indexPath = IndexPath.init(row: 0, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
                }
            }
        }
    }
    
    private func beerSort(beer1: Beer, beer2: Beer) -> Bool {
        if toggleSwitch.isOn {
            return (beer1.abv! < beer2.abv!)
        } else {
            return (beer1.abv! > beer2.abv!)
        }
    }
}

