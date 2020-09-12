//
//  EditTransmissionServiceViewController.swift
//  Transmission Remote
//
//  Created by 👽 on 9/9/20.
//  Copyright © 2020 chead. All rights reserved.
//

import UIKit
import CoreData

class EditTransmissionServiceViewController: UIViewController {
    var managedObjectContext: NSManagedObjectContext!
    var transmissionService: TransmissionService!

    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var cancelBarButtonItem: UIBarButtonItem!
    @IBOutlet var doneBarButtonItem: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tappedDeleteButton(sender: UIButton) {
        let alert = UIAlertController(title: "Delete?", message: "Delete this Transmission Service?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            self.managedObjectContext.delete(self.transmissionService)

            do {
                try self.managedObjectContext.save()
            } catch {
                fatalError("Failed to save NSManagedObjectContext: \(error.localizedDescription)")
            }

            self.performSegue(withIdentifier: "unwindToTransmissionServicesTableViewController", sender: self)
        }))

        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
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
