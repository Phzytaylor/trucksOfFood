//
//  truckMainMenuTableViewCell.swift
//  
//
//  Created by Taylor Simpson on 6/27/17.
//
//

import UIKit

class truckMainMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var mainMenuLabel: UILabel!
    @IBOutlet weak var mainMenuImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}



class MenuItemsCell: UITableViewCell {

    @IBOutlet weak var foodItem: UILabel!

    @IBOutlet weak var price: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }




}
