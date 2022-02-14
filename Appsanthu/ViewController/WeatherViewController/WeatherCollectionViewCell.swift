//
//  WeatherCollectionViewCell.swift
//  Appsanthu
//
//  Created by ĐINH HUY PHU on 30/07/2021.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var lblTempurature: UILabel!
    @IBOutlet weak var lblT: UILabel!
    @IBOutlet weak var lblU: UILabel!
    @IBOutlet weak var lblE: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
