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

class AddTransmissionServiceViewController: UIViewController {
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

    @IBAction func doneBarButtonItemPressed(sender: UIBarButtonItem) {
        guard
            let transmissionService = NSEntityDescription.insertNewObject(forEntityName: "TransmissionService", into: self.managedObjectContext) as? TransmissionService
        else {
            fatalError("Failed to initialize NSEntityDescription: TransmissionService")
        }

        guard
            let serviceName = self.nameTextField.text,
            let serviceHost = self.hostTextField.text,
            let servicePort = self.portTextField.text
        else {
            return
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
            let credentials = Credentials(username: username, password: password)

            do {
                let credentialsData = try JSONEncoder().encode(credentials)

                _ = Keychain.save(key: transmissionService.uuid.uuidString, data: credentialsData)
            } catch {
                fatalError("Failed to encode credentials: \(error.localizedDescription)")
            }
        }

        self.dismiss(animated: true) {}
    }

    @IBAction func didFinishEditingTextfield(sender: UITextField!) {
        self.doneBarButtonItem.isEnabled = self.hostTextField.text?.isEmpty == false
    }
}
