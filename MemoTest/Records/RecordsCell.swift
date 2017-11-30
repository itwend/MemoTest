//
//  RecordsCell.swift
//  MemoTest
//
//  Created by Andrew on 11/29/17.
//  Copyright © 2017 Andrew Gerbovtsan. All rights reserved.
//

import UIKit

protocol RecordsCellDelegate {
    func playSound(sender: UIButton)
    func removeSound(sender: UIButton)
}

class RecordsCell: UITableViewCell {

    @IBOutlet weak var soundView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var playSoundButton: UIButton!
    
    var indexPath: IndexPath?
    var delegateCell: RecordsCellDelegate?

    var isPlaying: Bool = false {
        didSet {
            if !isPlaying {
                playSoundButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            } else {
                playSoundButton.setImage(#imageLiteral(resourceName: "stop"), for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        soundView.layer.cornerRadius = 10
    }
    
    @IBAction func playSoundButtonTouchUp(_ sender: UIButton) {
        delegateCell?.playSound(sender: sender)
    }
    
    @IBAction func deleteSoundButtonTouchUp(_ sender: UIButton) {
        delegateCell?.removeSound(sender: sender)
    }
    
}
