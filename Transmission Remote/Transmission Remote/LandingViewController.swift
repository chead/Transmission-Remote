//
//  LandingViewController.swift
//  Transmission Remote
//
//  Created by 👽 on 6/11/20.
//  Copyright © 2020 chead. All rights reserved.
//

import UIKit
import CoreData

class LandingViewController: UIViewController {

    var managedObjectContext: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.performSegue(withIdentifier: "showTransmissionServicesTableViewController", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(segue.identifier) {
        case "showTransmissionServicesTableViewController":
            let transmissionServicesTableViewController = segue.destination as! TransmissionServicesTableViewController

            transmissionServicesTableViewController.managedObjectContext = self.managedObjectContext
        default:
            break
        }
    }

}
