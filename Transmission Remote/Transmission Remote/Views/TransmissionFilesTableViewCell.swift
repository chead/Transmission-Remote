//
//  TransmissionFilesTableViewCell.swift
//  Transmission Remote
//
//  Created by 👽 on 9/11/21.
//  Copyright © 2021 chead. All rights reserved.
//

import UIKit

protocol TransmissionFilesTableViewCellDelegate {
    func activeSwitchValueChanged(sender: UISwitch!, in cell: TransmissionFilesTableViewCell)
}

class TransmissionFilesTableViewCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var activeSwitch: UISwitch!

    var delegate: TransmissionFilesTableViewCellDelegate?

    @IBAction func activeSwitchValueChanged(sender: UISwitch!) {
        self.delegate?.activeSwitchValueChanged(sender: sender, in: self)
    }
}
