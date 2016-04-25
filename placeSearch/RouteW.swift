//
//  RouteW.swift
//  proyectoFinalTec
//
//  Created by Francisco Humberto Andrade Gonzalez on 22/04/16.
//  Copyright © 2016 Francisco Humberto Andrade Gonzalez. All rights reserved.
//

import WatchKit

class RouteW: NSObject {
    var name : String
    var favoritePoints : String
    var points : [MKMapItem]
    var image : UIImage?
    init(name : String, description : String, points : [MKMapItem], image : UIImage? ){
        self.name = name
        self.favoritePoints = description
        self.points = points
        if (image != nil){
            self.image = image!
        }
    }
}
