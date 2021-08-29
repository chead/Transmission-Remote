//
//  AddTransmissionServiceViewController.swift
//  Transmission Remote
//
//  Created by 👽 on 8/27/20.
//  Copyright © 2020 chead. All rights reserved.
//

import UIKit
import CoreData
import TransmissionKit

class AddTransmissionServiceTableViewController: UITableViewController {
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var hostTextField: UITextField!
    @IBOutlet var portTextField: UITextField!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var cancelBarButtonItem: UIBarButtonItem!
    @IBOutlet var doneBarButtonItem: UIBarButtonItem!

    var managedObjectContext: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.doneBarButtonItem.isEnabled = false
    }

    @IBAction func addBarButtonItemPressed(sender: UIBarButtonItem) {
        guard
            let serviceName = self.nameTextField.text,
            let serviceHost = self.hostTextField.text,
            let servicePort = self.portTextField.text
        else {
            return
        }

        guard
            let transmissionService = NSEntityDescription.insertNewObject(forEntityName: "TransmissionService", into: self.managedObjectContext) as? TransmissionService
        else {
            fatalError("Failed to initialize NSEntityDescription: TransmissionService")
        }

        transmissionService.name = serviceName.isEmpty ? "Transmission" : serviceName
        transmissionService.host = serviceHost
        transmissionService.port = servicePort.isEmpty ? "9091" : servicePort
        transmissionService.created = Date()
        transmissionService.uuid = UUID()

        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Failed to save NSManagedObjectContext: \(error.localizedDescription)")
        }

        if
            let username = self.usernameTextField.text,
            let password = self.passwordTextField.text,
            username.isEmpty == false,
            password.isEmpty == false
        {
            transmissionService.addCredentials(username: username, password: password)
        }

        self.dismiss(animated: true) {}
    }

    @IBAction func didFinishEditingTextfield(sender: UITextField!) {
        self.doneBarButtonItem.isEnabled = self.hostTextField.text?.isEmpty == false
    }
}
