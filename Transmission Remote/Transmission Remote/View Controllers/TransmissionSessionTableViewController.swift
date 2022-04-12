//
//  TransmissionServiceTableViewController.swift
//  Transmission Remote
//
//  Created by 👽 on 4/22/20.
//  Copyright © 2020 chead. All rights reserved.
//

import UIKit
import CoreData
import TransmissionKit

class TransmissionSessionTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    enum TransmissionTorrentFilter {
        case all
        case downloading
    }

    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    var transmissionSession: TransmissionSession!

    let searchController = UISearchController(searchResultsController: nil)

    private var transmissionTorrents: [TransmissionTorrent] = []

    private var searchedTransmissionTorrents: [TransmissionTorrent] = []

    private var selectedTransmissionTorrent: TransmissionTorrent!

    private var currentFilter: TransmissionTorrentFilter = .all

    private var isSearching: Bool { return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true) }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.definesPresentationContext = true

        self.navigationController?.setToolbarHidden(false, animated: false)

        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search Torrents"

        self.navigationItem.searchController = searchController

        self.refreshControl?.addTarget(self, action: #selector(pulledToRefresh), for: UIControl.Event.valueChanged)

        self.activityIndicator.center = self.view.center

        self.view.addSubview(activityIndicator)

        self.refreshTorrents {}
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.searchController.isActive = false
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isSearching ?
            self.searchedTransmissionTorrents.count :
            self.transmissionTorrents.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transmissionTorrentTableViewCell", for: indexPath) as! TransmissionTorrentsTableViewCell

        let transmissionTorrent = self.isSearching ?
            self.searchedTransmissionTorrents[indexPath.row] :
            self.transmissionTorrents[indexPath.row]

        cell.titleLabel.text = transmissionTorrent.name
        cell.progressView.progress = transmissionTorrent.progress

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedTransmissionTorrent = self.isSearching ?
            self.searchedTransmissionTorrents[indexPath.row] :
            self.transmissionTorrents[indexPath.row]

        self.performSegue(withIdentifier: "showTransmissionTorrentTableViewController", sender: self)
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(segue.identifier) {
        case "showTransmissionTorrentTableViewController":
            let transmissionTorrentTableViewController = segue.destination as! TransmissionTorrentTableViewController

            transmissionTorrentTableViewController.transmissionSession = self.transmissionSession
            transmissionTorrentTableViewController.transmissionTorrent = self.selectedTransmissionTorrent

        default:
            break
        }
    }

    func transmissionTorrent(indexPath: IndexPath) -> TransmissionTorrent {
        if(self.isSearching) {
            return self.searchedTransmissionTorrents[indexPath.row]
        }
        else {
            return self.searchedTransmissionTorrents[indexPath.row]
        }
    }

    func searchTorrentsByTitle(title: String) {
        self.searchedTransmissionTorrents = self.transmissionTorrents.filter({ (transmissionTorrent) -> Bool in
            return transmissionTorrent.name.lowercased().contains(title.lowercased())
        })

        self.tableView.reloadData()
    }

    func refreshTorrents(completion: @escaping () -> Void) {
        self.transmissionSession.getTorrents { result in
            switch result {
            case .success(let torrents):
                self.transmissionTorrents = torrents.sorted { $0.added < $1.added }

            case .failure(let error):
                break
            }

            DispatchQueue.main.async{
                self.activityIndicator.stopAnimating()

                self.tableView.reloadData()

                completion()
            }
        }
    }

    @objc func pulledToRefresh(refreshControl: UIRefreshControl) {
        guard self.isSearching == false else { return }

        self.refreshTorrents {
            refreshControl.endRefreshing()
        }
    }

    @IBAction func addTorrentBarButtonItemPressed(sender: UIBarButtonItem) {
//        let documentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)
//
//        documentPickerViewController.delegate = self
//        documentPickerViewController.modalPresentationStyle = .fullScreen
//
//        self.present(documentPickerViewController, animated: true, completion: nil)
    }

    @IBAction func filterBarButtonItemPressed(sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        actionSheet.addAction(cancelAction)

        let allAction = UIAlertAction(title: "All", style: .default) { action in
            self.currentFilter = .all
        }

        actionSheet.addAction(allAction)

        let downloadingAction = UIAlertAction(title: "Downloading", style: .default) { action in
            self.currentFilter = .downloading
        }

        actionSheet.addAction(downloadingAction)

        self.present(actionSheet, animated: true, completion: nil)
    }

    @IBAction func sortBarButtonItemPressed(sender: UIBarButtonItem) {

    }
}

extension TransmissionSessionTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = self.searchController.searchBar

        self.searchTorrentsByTitle(title: searchBar.text!)
    }
}

extension TransmissionSessionTableViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//        guard let torrentURL = urls.first else { return }
//
//        self.transmissionService.addTorrent(url: torrentURL) { (added) in
//            if(added == true) {
//                self.refreshTorrents()
//            }
//        }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {}
}
