//
//  UserDetailViewController.swift
//  EmaarTestRaghav
//
//  Created by apple on 26/08/23.
//

import UIKit
import SDWebImage

@objc class UserDetailViewController: UIViewController {
    
    // MARK: - Variables
    
    @objc var usersInfo = UsersInformation()
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Set Title
        self.title = self.usersInfo.fullName
    }
}

extension UserDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserImageDetailTableViewCell", for: indexPath) as! UserImageDetailTableViewCell
            cell.userImageView.sd_setImage(with: URL(string: self.usersInfo.pictureLarge), placeholderImage: UIImage(systemName: "person"))
            cell.ageView.addDiamondMask()
            cell.ageLabel.text = self.usersInfo.dobAge
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserBasicDetailTableViewCell", for: indexPath) as! UserBasicDetailTableViewCell
            cell.emailLabel.text = "Email: " + self.usersInfo.email
            cell.dateJoinedLabel.text = "Date Joined: " + self.usersInfo.registeredDate
            cell.dobLabel.text = "DOB: " + self.usersInfo.dobDate
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserLocationDetailTableViewCell", for: indexPath) as! UserLocationDetailTableViewCell
            cell.cityLabel.text = "City: " + self.usersInfo.city
            cell.stateLabel.text = "State: " + self.usersInfo.state
            cell.countryLabel.text = "Country: " + self.usersInfo.country
            cell.postcodeLabel.text = "Postcode: " + self.usersInfo.postCode
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension UserDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 2 ? 60 : CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailSectionCell")
            cell?.textLabel?.text = "Location"
            return cell
        default:
            return nil
        }
    }
}
