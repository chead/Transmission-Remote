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

class TransmissionServiceTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    var transmissionService: TransmissionService!

    let searchController = UISearchController(searchResultsController: nil)

    private var filteredTransmissionTorrents: [TransmissionTorrent] = []
    private var selectedTransmissionTorrent: TransmissionTorrent!

    private var isFiltering: Bool { return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true) }

    lazy var fetchedResultsController: NSFetchedResultsController<TransmissionTorrent> = {
        let transmissionTorrentsFetchRequest: NSFetchRequest<TransmissionTorrent> = NSFetchRequest(entityName: "TransmissionTorrent")

        transmissionTorrentsFetchRequest.predicate = NSPredicate(format: "service == %@", self.transmissionService)
        transmissionTorrentsFetchRequest.sortDescriptors = [NSSortDescriptor(key: "added", ascending: false)]

        var fetchedResultsController = NSFetchedResultsController(fetchRequest: transmissionTorrentsFetchRequest,
                                                                  managedObjectContext: self.transmissionService.managedObjectContext!,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)

        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }

        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.definesPresentationContext = true

        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search Titles"

        self.navigationItem.searchController = searchController

        self.refreshControl?.addTarget(self, action: #selector(pulledToRefresh), for: UIControl.Event.valueChanged)

        self.activityIndicator.center = self.view.center

        self.view.addSubview(activityIndicator)

        self.refreshTorrents()
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if(isFiltering) {
            return 1
        } else {
            return self.fetchedResultsController.sections!.count
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isFiltering) {
            return self.filteredTransmissionTorrents.count
        } else {
            return self.fetchedResultsController.sections![section].numberOfObjects
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transmissionTorrentTableViewCell", for: indexPath) as! TransmissionTorrentsTableViewCell

        let transmissionTorrent = self.transmissionTorrent(for: indexPath)

        cell.titleLabel.text = transmissionTorrent.name
        cell.progressView.progress = transmissionTorrent.progress

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedTransmissionTorrent = self.transmissionTorrent(for: indexPath)

        self.performSegue(withIdentifier: "showTransmissionTorrentTableViewController", sender: self)
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        @unknown default:
            fatalError()
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        @unknown default:
            fatalError()
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(segue.identifier) {
        case "showTransmissionTorrentTableViewController":
            let transmissionTorrentTableViewController = segue.destination as! TransmissionTorrentTableViewController

            transmissionTorrentTableViewController.transmissionTorrent = self.selectedTransmissionTorrent

            break
//            let addTransmissionServiceNavigationController = segue.destination as! UINavigationController
//            let addTransmissionServiceViewController = addTransmissionServiceNavigationController.viewControllers.first as! AddTransmissionServiceViewController
//
//            addTransmissionServiceViewController.managedObjectContext = self.fetchedResultsController.managedObjectContext

        default:
            break
        }
    }

    func filterTorrentsByTitle(title: String) {
        guard let fetchedObjects = self.fetchedResultsController.fetchedObjects else { return }

        self.filteredTransmissionTorrents = fetchedObjects.filter({ (transmissionTorrent) -> Bool in
            return transmissionTorrent.name.lowercased().contains(title.lowercased())
        })

        self.tableView.reloadData()
    }

    func refreshTorrents() {
        self.transmissionService.refreshTorrents() {
            DispatchQueue.main.async{
                self.activityIndicator.stopAnimating()
            }
        }
    }

    func transmissionTorrent(for indexPath: IndexPath) -> TransmissionTorrent {
        let transmissionTorrent: TransmissionTorrent

        if(self.isFiltering == true) {
            transmissionTorrent = self.filteredTransmissionTorrents[indexPath.row]
        } else {
            transmissionTorrent = self.fetchedResultsController.object(at: indexPath)
        }

        return transmissionTorrent
    }

    @objc func pulledToRefresh(refreshControl: UIRefreshControl) {
        guard self.isFiltering == false else { return }

        self.refreshTorrents()

        refreshControl.endRefreshing()
    }

    @IBAction func addTorrentBarButtonItemPressed(sender: UIBarButtonItem) {
        let documentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)

        documentPickerViewController.delegate = self
        documentPickerViewController.modalPresentationStyle = .fullScreen

        self.present(documentPickerViewController, animated: true, completion: nil)
    }
}

extension TransmissionServiceTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = self.searchController.searchBar

        self.filterTorrentsByTitle(title: searchBar.text!)
    }
}

extension TransmissionServiceTableViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let torrentURL = urls.first else { return }

        self.transmissionService.addTorrent(url: torrentURL) { (added) in
            if(added == true) {
                self.refreshTorrents()
            }
        }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {}
}
