//
//  AirportTableViewCell.swift
//  ForeFlightProject
//
//  Created by Andy Lindberg on 5/13/22.
//

import Foundation
import UIKit

class AirportTableViewCell: UITableViewCell {

    @IBOutlet weak var airportIdentifier: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
