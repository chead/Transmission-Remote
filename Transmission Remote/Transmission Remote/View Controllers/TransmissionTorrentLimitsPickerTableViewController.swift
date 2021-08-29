//
//  TransmissionTorrentLimitsPickerTableViewController.swift
//  Transmission Remote
//
//  Created by 👽 on 8/24/21.
//  Copyright © 2021 chead. All rights reserved.
//

import UIKit

protocol TransmissionTorrentLimitsPickerDelegate {
    func limitsPickerDidChangeUploadLimited(limited: Bool)
    func limitsPickerDidChangeUploadLimit(limit: Int)
    func limitsPickerDidChangeDownloadLimited(limited: Bool)
    func limitsPickerDidChangeDownloadLimit(limit: Int)
}

class TransmissionTorrentLimitsPickerTableViewController: UITableViewController {
    var delegate: TransmissionTorrentLimitsPickerDelegate?

    var uploadLimited: Bool = false
    var downloadLimited: Bool = false
    var uploadLimit: Int = 0
    var downloadLimit: Int = 0

    @IBOutlet var uploadLimitedSwitch: UISwitch!
    @IBOutlet var downloadLimitedSwitch: UISwitch!
    @IBOutlet var uploadLimitTextField: UITextField!
    @IBOutlet var downloadLimitTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.uploadLimitedSwitch.isOn = self.uploadLimited
        self.downloadLimitedSwitch.isOn = self.downloadLimited
        self.uploadLimitTextField.text = "\(self.uploadLimit)"
        self.downloadLimitTextField.text = "\(self.downloadLimit)"
    }

    @IBAction func limitSwitchValueChanged(sender: UISwitch) {
        switch sender {
        case uploadLimitedSwitch:
            self.delegate?.limitsPickerDidChangeUploadLimited(limited: sender.isOn)
            break
        case downloadLimitedSwitch:
            self.delegate?.limitsPickerDidChangeDownloadLimited(limited: sender.isOn)
            break
        default:
            break
        }
    }

    @IBAction func limitTextFieldDidEndEditing(sender: UITextField) {
        guard let limitText = sender.text else { return }

        let limit = Int(limitText) ?? 0

        switch sender {
        case uploadLimitTextField:
            self.delegate?.limitsPickerDidChangeUploadLimit(limit: limit)
            break
        case downloadLimitTextField:
            self.delegate?.limitsPickerDidChangeDownloadLimit(limit: limit)
            break
        default:
            break
        }
    }
}
