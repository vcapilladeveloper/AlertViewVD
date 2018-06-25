//
//  TableViewCustomCell.swift
//  AlertViewVD
//
//  Created by Victor Capilla Borrego on 24/6/18.
//  Copyright © 2018 Victor Capilla Borrego. All rights reserved.
//

import UIKit

class TableViewCustomCell: UITableViewCell {

    @IBOutlet weak var firstText: UILabel!
    @IBOutlet weak var secondText: UILabel!
    @IBOutlet weak var thirdText: UILabel!
    
    func setUp(_ element: TableViewElement) {
        firstText.text = element.first
        secondText.text = element.second
        thirdText.text = element.third
    }
    
    
}
