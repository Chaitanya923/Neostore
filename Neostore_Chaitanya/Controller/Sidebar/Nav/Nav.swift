//
//  Nav.swift
//  Neostore_Chaitanya
//
//  Created by Neosoft on 06/01/22.
//

import UIKit

class Nav: UITableViewCell {

    @IBOutlet weak var navimg: UIImageView!
    @IBOutlet weak var Navlabel: UILabel!
    @IBOutlet weak var badgeview: UIView!
    @IBOutlet weak var badgelabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
