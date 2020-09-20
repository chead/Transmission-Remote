//
//  TransmissionTorrentsTableViewCell.swift
//  Transmission Remote
//
//  Created by 👽 on 9/4/20.
//  Copyright © 2020 chead. All rights reserved.
//

import UIKit

class TransmissionTorrentsTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var progressView: UIProgressView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
