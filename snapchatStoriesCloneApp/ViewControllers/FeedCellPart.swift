//
//  FeedCellPart.swift
//  snapchatStoriesCloneApp
//
//  Created by Berkay on 25.10.2022.
//

import UIKit

class FeedCellPart: UITableViewCell {
    
    @IBOutlet weak var feedUserNameLabel: UILabel!
    @IBOutlet weak var feedImageView: UIImageView!
    

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
