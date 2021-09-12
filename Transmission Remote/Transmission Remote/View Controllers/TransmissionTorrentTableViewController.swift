//
//  TransmissionTorrentTableViewController.swift
//  Transmission Remote
//
//  Created by 👽 on 9/20/20.
//  Copyright © 2020 chead. All rights reserved.
//

import UIKit

class TransmissionTorrentTableViewController: UITableViewController, TransmissionTorrentPriorityPickerDelegate, TransmissionTorrentLimitsPickerDelegate {

    var transmissionSession: TransmissionSession!
    var transmissionTorrent: TransmissionTorrent!

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var downloadRateLabel: UILabel!
    @IBOutlet var uploadRateLabel: UILabel!
    @IBOutlet var playBarButtonItem: UIBarButtonItem!
    @IBOutlet var pauseBarButtonItem: UIBarButtonItem!

    var refreshTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setFields()
        self.setStartStopButtons(started: self.transmissionTorrent.status != .stopped)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.refreshTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
            self.transmissionTorrent.update {
                DispatchQueue.main.async {
                    self.setFields()
                }
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.refreshTimer?.invalidate()
    }

    func setFields() {
        self.nameLabel.text = self.transmissionTorrent.name
        self.progressLabel.text = String(format: "%.02f", arguments: [(self.transmissionTorrent.progress * 100)])

        switch self.transmissionTorrent.status {
        case .stopped:
            self.statusLabel.text = "Stopped"

        case .checkingQueued:
            self.statusLabel.text = "Checking Queued"

        case .checking:
            self.statusLabel.text = "Checking"

        case .downloadingQueued:
            self.statusLabel.text = "Downloading Queued"

        case .downloading:
            self.statusLabel.text = "Downloading"

        case .seedingQueued:
            self.statusLabel.text = "Seeding Queued"

        case .seeding:
            self.statusLabel.text = "Seeding"
        }

        self.downloadRateLabel.text = String(format: "%.02f", arguments: [(Float(self.transmissionTorrent.downloadRate) / 1000)])
        self.uploadRateLabel.text = String(format: "%.02f", arguments: [(Float(self.transmissionTorrent.uploadRate) / 1000)])
    }

    func setStartStopButtons(started: Bool) {
        if(started == true) {
            self.navigationItem.rightBarButtonItem = self.pauseBarButtonItem
        } else {
            self.navigationItem.rightBarButtonItem = self.playBarButtonItem
        }
    }

    @IBAction func startButtonTapped(sender: UIBarButtonItem) {
        self.transmissionSession.startTorrent(id: self.transmissionTorrent.id) { started in
            DispatchQueue.main.async {
                self.setStartStopButtons(started: started)
            }
        }
    }

    @IBAction func pauseButtonTapped(sender: UIBarButtonItem) {
        self.transmissionSession.stopTorrent(id: self.transmissionTorrent.id) { stopped in
            DispatchQueue.main.async {
                self.setStartStopButtons(started: !stopped)
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            break

        case 1:
            switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: "showTransmissionTorrentPriorityPickerTableViewController", sender: self)

            case 1:
                self.performSegue(withIdentifier: "showTransmissionTorrentLimitsPickerTableViewController", sender: self)

            case 3:
                self.performSegue(withIdentifier: "showTransmissionFilesTableViewController", sender: self)

                break

            default: break
            }

        default: break
        }
    }

    func limitsPickerDidChangeUploadLimited(limited: Bool) {
        self.transmissionTorrent.uploadLimited(limited: limited) { result in }
    }

    func limitsPickerDidChangeDownloadLimited(limited: Bool) {
        self.transmissionTorrent.downloadLimited(limited: limited) { result in }
    }

    func limitsPickerDidChangeUploadLimit(limit: Int) {
        self.transmissionTorrent.uploadLimit(limit: limit) { result in }
    }

    func limitsPickerDidChangeDownloadLimit(limit: Int) {
        self.transmissionTorrent.downloadLimit(limit: limit) { Result in }
    }

    func priorityPickerDidChangePriority(priority: Priority) {}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(segue.identifier) {
        case "showTransmissionTorrentPriorityPickerTableViewController":
            let transmissionTorrentPriorityPickerTableViewController = segue.destination as! TransmissionTorrentPriorityPickerTableViewController

            transmissionTorrentPriorityPickerTableViewController.delegate = self

        case "showTransmissionTorrentLimitsPickerTableViewController":
            let transmissionTorrentLimitsPickerTableViewController = segue.destination as! TransmissionTorrentLimitsPickerTableViewController

            transmissionTorrentLimitsPickerTableViewController.delegate = self
            transmissionTorrentLimitsPickerTableViewController.uploadLimited = self.transmissionTorrent.uploadLimited
            transmissionTorrentLimitsPickerTableViewController.downloadLimited = self.transmissionTorrent.downloadLimited
            transmissionTorrentLimitsPickerTableViewController.uploadLimit = self.transmissionTorrent.uploadLimit
            transmissionTorrentLimitsPickerTableViewController.downloadLimit = self.transmissionTorrent.downloadLimit

        case "showTransmissionFilesTableViewController":
            let transmissionFilesTableViewController = segue.destination as! TransmissionFilesTableViewController

            transmissionFilesTableViewController.transmissionFiles = self.transmissionTorrent.files

        default:
            break
        }
    }
}
