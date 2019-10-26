//
//  BeerTableViewCell.swift
//  BrewMock
//
//  Created by Adrià Abella on 25/10/2019.
//  Copyright © 2019 AdriaAbella. All rights reserved.
//

import Foundation
import UIKit

class BeerTableViewCell: UITableViewCell {
    @IBOutlet public weak var nameLabel: UILabel!
    @IBOutlet public weak var taglineLabel: UILabel!
    @IBOutlet public weak var abvLabel: UILabel!
    @IBOutlet public weak var descriptionLabel: UILabel!
    @IBOutlet public weak var thumbnailImage: UIImageView!
}
