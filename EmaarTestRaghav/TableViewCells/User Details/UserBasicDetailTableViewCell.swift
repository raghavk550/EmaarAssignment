//
//  UserBasicDetailTableViewCell.swift
//  EmaarTestRaghav
//
//  Created by apple on 26/08/23.
//

import UIKit

class UserBasicDetailTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dateJoinedLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    
    // MARK: - Cell Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
