//
//  RecordsCell.swift
//  MemoTest
//
//  Created by Andrew on 11/29/17.
//  Copyright © 2017 Andrew Gerbovtsan. All rights reserved.
//

import UIKit

class RecordsCell: UITableViewCell {

    @IBOutlet weak var soundView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var playSoundButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        soundView.layer.cornerRadius = 10
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func playSoundButtonTouchUp(_ sender: Any) {
        
    }
    @IBAction func deleteSoundButtonTouchUp(_ sender: Any) {
    }
    
}
