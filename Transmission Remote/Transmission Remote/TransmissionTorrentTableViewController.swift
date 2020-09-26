//
//  TransmissionTorrentTableViewController.swift
//  Transmission Remote
//
//  Created by 👽 on 9/20/20.
//  Copyright © 2020 chead. All rights reserved.
//

import UIKit

class TransmissionTorrentTableViewController: UITableViewController {
    var transmissionTorrent: TransmissionTorrent!

//    case stopped = 0
//    case checkingQueued
//    case checking
//    case downloadingQueued
//    case downloading
//    case seedingQueued
//    case seeding

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var stoppedStatusLabel: UILabel!
    @IBOutlet var checkingQueuedStatusLabel: UILabel!
    @IBOutlet var checkingStatusLabel: UILabel!
    @IBOutlet var downloadingQueuedStatusLabel: UILabel!
    @IBOutlet var downloadingStatusLabel: UILabel!
    @IBOutlet var seedingQueuedStatusLabel: UILabel!
    @IBOutlet var seedingStatusLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var stopButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameLabel.text = self.transmissionTorrent.name

        self.setFields()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

        self.setStartStopButtons(started: self.transmissionTorrent.status != .stopped)

        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
            self.update()
        }

    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func update() {
        self.transmissionTorrent.update {
            DispatchQueue.main.async {
                self.setFields()
            }
        }
    }

    func setFields() {
        self.progressView.progress = self.transmissionTorrent.progress
        self.progressLabel.text = "\(self.transmissionTorrent.progress * 100)%"
        self.setStatusLabel(status: self.transmissionTorrent.status)
    }

    func setStatusLabel(status: TransmissionTorrent.Status) {
        self.stoppedStatusLabel.isHidden = true
        self.checkingQueuedStatusLabel.isHidden = true
        self.checkingStatusLabel.isHidden = true
        self.downloadingQueuedStatusLabel.isHidden = true
        self.downloadingStatusLabel.isHidden = true
        self.checkingQueuedStatusLabel.isHidden = true
        self.checkingStatusLabel.isHidden = true

        switch status {
        case .stopped:
            self.stoppedStatusLabel.isHidden = false
        case .checkingQueued:
            self.checkingQueuedStatusLabel.isHidden = false
        case .checking:
            self.checkingStatusLabel.isHidden = false
        case .downloadingQueued:
            self.downloadingQueuedStatusLabel.isHidden = false
        case .downloading:
            self.downloadingStatusLabel.isHidden = false
        case .seedingQueued:
            self.seedingQueuedStatusLabel.isHidden = false
        case .seeding:
            self.seedingStatusLabel.isHidden = false
        }
    }

    func setStartStopButtons(started: Bool) {
        self.startButton.isHidden = started
        self.stopButton.isHidden = !started
    }

    @IBAction func startButtonTouched(sender: UIButton) {
        self.transmissionTorrent.start { (started) in
            DispatchQueue.main.async {
                self.setStartStopButtons(started: started)
            }
        }
    }

    @IBAction func stopButtonTouched(sender: UIButton) {
        self.transmissionTorrent.stop { (stopped) in
            DispatchQueue.main.async {
                self.setStartStopButtons(started: !stopped)
            }
        }
    }
}
