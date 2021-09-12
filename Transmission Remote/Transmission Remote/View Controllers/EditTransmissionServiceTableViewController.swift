//
//  EditTransmissionServiceViewController.swift
//  Transmission Remote
//
//  Created by 👽 on 9/9/20.
//  Copyright © 2020 chead. All rights reserved.
//

import UIKit
import CoreData
import TransmissionKit

class EditTransmissionServiceTableViewController: UITableViewController {
    var transmissionService: TransmissionService!

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var hostTextField: UITextField!
    @IBOutlet var portTextField: UITextField!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var cancelBarButtonItem: UIBarButtonItem!
    @IBOutlet var doneBarButtonItem: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameTextField.text = self.transmissionService.name
        self.hostTextField.text = self.transmissionService.host
        self.portTextField.text = self.transmissionService.port

        var credentials: Credentials?

        if let keychainData = Keychain.load(key: self.transmissionService.uuid.uuidString) {
            do {
                credentials = try JSONDecoder().decode(Credentials.self, from: keychainData)
            } catch {}
        }
        
        self.usernameTextField.text = credentials?.username
    }
    
    @IBAction func doneBarButtonItemPressed(sender: UIBarButtonItem) {
        guard
            let serviceName = self.nameTextField.text,
            let serviceHost = self.hostTextField.text,
            let servicePort = self.portTextField.text
        else {
            return
        }

        self.transmissionService.name = serviceName.isEmpty ? "Transmission" : serviceName
        self.transmissionService.host = serviceHost
        self.transmissionService.port = servicePort.isEmpty ? "9091" : servicePort

        do {
            try self.transmissionService.managedObjectContext?.save()
        } catch {
            fatalError("Failed to save NSManagedObjectContext: \(error.localizedDescription)")
        }

        if
            let username = self.usernameTextField.text,
            let password = self.passwordTextField.text,
            username.isEmpty == false,
            password.isEmpty == false
        {
            let credentials = TransmissionCredentials(username: username, password: password)

            let _ = TransmissionCredentials.updateCredentials(credentials: credentials, uuid: transmissionService.uuid)
        }

        self.dismiss(animated: true) {}
    }

    @IBAction func didFinishEditingTextfield(sender: UITextField!) {
        self.doneBarButtonItem.isEnabled = self.hostTextField.text?.isEmpty == false
    }

    @IBAction func tappedDeleteButton(sender: UIButton) {
        let alert = UIAlertController(title: "Delete?", message: "Delete this Transmission Service?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            let managedObjectContext = self.transmissionService.managedObjectContext

            managedObjectContext?.delete(self.transmissionService)

            do {
                try managedObjectContext?.save()
            } catch {
                fatalError("Failed to save NSManagedObjectContext: \(error.localizedDescription)")
            }

            self.performSegue(withIdentifier: "unwindToTransmissionServicesTableViewController", sender: self)
        }))

        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }

}
