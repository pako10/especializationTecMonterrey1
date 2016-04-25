//
//  Route.swift
//  proyectoFinalTec
//
//  Created by Francisco Humberto Andrade Gonzalez on 20/04/16.
//  Copyright © 2016 Francisco Humberto Andrade Gonzalez. All rights reserved.
//

import Foundation
import UIKit
import MapKit

struct Route {
    var name : String
    var description : String
    var points : [MKMapItem]
    var image : UIImage?
    init(name : String, description : String, points : [MKMapItem], image : UIImage? ){
        self.name = name
        self.description = description
        self.points = points
        if (image != nil){
            self.image = image!
        }
    }
}