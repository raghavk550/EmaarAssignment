//
//  UserLocationDetailTableViewCell.swift
//  EmaarTestRaghav
//
//  Created by apple on 26/08/23.
//

import UIKit

class UserLocationDetailTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var postcodeLabel: UILabel!
    
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
