//
//  SettingTableViewCell.swift
//  MCBackup
//
//  Created by Apple on 3/25/18.
//  Copyright © 2018 Tien. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbNameSetting: UILabel!
    @IBOutlet weak var switchPasscode: UISwitch!
    var defaults = UserDefaults.standard
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if defaults.integer(forKey: "switch") == 1 {
            switchPasscode.isOn = true
        } else {
            switchPasscode.isOn = false
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btSwitch(_ sender: UISwitch) {
       
    }
    
    
}
