//
//  TransmissionTorrentFilesTableViewController.swift
//  Transmission Remote
//
//  Created by 👽 on 9/11/21.
//  Copyright © 2021 chead. All rights reserved.
//

import UIKit

class TransmissionFilesTableViewController: UITableViewController, TransmissionFilesTableViewCellDelegate {

    var transmissionFiles: Set<TransmissionFile>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transmissionFiles.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    
//    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transmissionFileTableViewCell", for: indexPath) as! TransmissionFilesTableViewCell

        cell.delegate = self

        let transmissionFile = self.transmissionFile(for: indexPath)

        cell.nameLabel.text = transmissionFile.name
        cell.progressView.progress = transmissionFile.progress

        return cell
    }

    func transmissionFile(for indexPath: IndexPath) -> TransmissionFile {
        return self.transmissionFiles.sorted { $0.name.lowercased() < $1.name.lowercased() }[indexPath.row]
    }

    func activeSwitchValueChanged(sender: UISwitch!, in cell: TransmissionFilesTableViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)

        let transmissionFile = transmissionFile(for: indexPath!)


    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}
