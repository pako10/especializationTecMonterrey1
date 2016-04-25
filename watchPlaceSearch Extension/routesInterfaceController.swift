//
//  routesInterfaceController.swift
//  proyectoFinalTec
//
//  Created by Francisco Humberto Andrade Gonzalez on 23/04/16.
//  Copyright © 2016 Francisco Humberto Andrade Gonzalez. All rights reserved.
//

import WatchKit
import Foundation



class routesInterfaceController: WKInterfaceController {

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    @IBAction func btnShowMap() {
        pushControllerWithName("idMap", context: nil)
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
