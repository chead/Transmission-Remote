//
//  TransmissionTorrentPriorityPickerTableViewController.swift
//  Transmission Remote
//
//  Created by 👽 on 8/24/21.
//  Copyright © 2021 chead. All rights reserved.
//

import UIKit

enum Priority {
    case high
    case normal
    case low
}

protocol TransmissionTorrentPriorityPickerDelegate {
    func priorityPickerDidChangePriority(priority: Priority)
}

class TransmissionTorrentPriorityPickerTableViewController: UITableViewController {
    var delegate: TransmissionTorrentPriorityPickerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
