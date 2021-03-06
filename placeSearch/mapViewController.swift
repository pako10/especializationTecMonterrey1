//
//  mapViewController.swift
//  proyectoFinalTec
//
//  Created by Francisco Humberto Andrade Gonzalezon 20/04/16.
//  Copyright © 2016 Francisco Humberto Andrade Gonzalez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class mapViewController: UIViewController,  MKMapViewDelegate, CLLocationManagerDelegate  {
    
    @IBOutlet weak var mapRoute: MKMapView!
 
    var pointsTemp : [MKMapItem] = []
    
    var locationLatitude:Double?
    var locationLongitude:Double?

    var route : Route? = nil
    

    var fistFocus : Bool = true

    private let myManager = CLLocationManager()
    
    
    
    private var origen: MKMapItem!
    private var destino: MKMapItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Map"
        mapRoute.delegate = self
        myManager.delegate = self
        myManager.desiredAccuracy = kCLLocationAccuracyBest
        myManager.requestWhenInUseAuthorization()
        myManager.startUpdatingLocation()
            }
    
    func showRoute(route : Route){
        dispatch_async(dispatch_get_main_queue()) {
            //load my position
         
            let puntoCoor = CLLocationCoordinate2DMake(self.locationLatitude!, self.locationLongitude!)
            let puntoLugar = MKPlacemark(coordinate: puntoCoor, addressDictionary: nil)
            var firstPoint = MKMapItem(placemark: puntoLugar)
            for point in route.points {
                self.addPoint(point)
                self.getNewRoute(firstPoint, destino: point)
                firstPoint = point
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //verifica la autorizacion para ver la localizacion del usuario
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse{
            myManager.startUpdatingLocation()
            mapRoute.showsUserLocation = true
        }
        else{
            myManager.stopUpdatingLocation()
            mapRoute.showsUserLocation = false
        }
    }
    //Actualizacion de la localizacion
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        self.locationLatitude = location.coordinate.latitude
        self.locationLongitude = location.coordinate.longitude
        if fistFocus == true {
            fistFocus = false
            self.btnMyLocation()
            if (self.route != nil){
                print("mostrar ruta")
                showRoute(self.route!)
            }

        }
    }
    
    @IBAction func btnMyLocation() {
        let pointLocation = CLLocationCoordinate2DMake(self.locationLatitude!, self.locationLongitude! )
        let puntoLugar = MKPlacemark(coordinate: pointLocation, addressDictionary: nil)
        focusPointInMap(MKMapItem(placemark: puntoLugar))
    }
    
    
    

    
    @IBAction func btnNewPoint(sender: AnyObject) {
        //Create the alert controller.
        let alert = UIAlertController(title: "New favorite point in route", message: "Add New Point:", preferredStyle: .Alert)
        
        // Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "Name of Point"
        })
        
        //Grab the value from the text field, and print it when the user clicks Add Point.
        alert.addAction(UIAlertAction(title: "Add Point", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            if(textField.text != ""){
                self.myManager.stopUpdatingLocation()
                let puntoCoor = CLLocationCoordinate2DMake(self.locationLatitude!, self.locationLongitude!)
                let puntoLugar = MKPlacemark(coordinate: puntoCoor, addressDictionary: nil)
                let origen =  MKMapItem(placemark: puntoLugar)
                origen.name = "\(textField.text!)"
                //Agrega un punto
                
                self.addPoint(origen)
                self.myManager.startUpdatingLocation()
            }
            else{
                let alert = UIAlertController(title: "Invalid Request", message: "You have not filled fields", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        }))

        alert.addAction(UIAlertAction(title: "Finish Route", style: .Default, handler: { (action) -> Void in
            if(self.pointsTemp.count >= 2){
                self.finshRouteAction()
            }
            else{
                let alert = UIAlertController(title: "Invalid Request", message: "You need more favorite points", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))

        //Presenta la alerta
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func finshRouteAction() {
        dispatch_async(dispatch_get_main_queue()) {
            //perform code
            let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("detailViewController") as? detailViewController
            nextViewController!.favoritePoints = self.pointsTemp
            self.navigationController?.pushViewController(nextViewController!, animated: true)
        }
    }
    
    
    
    //Con este metodo se crean las rutas
    
    func getNewRoute(origen: MKMapItem, destino: MKMapItem){
        let newRequest = MKDirectionsRequest()
        newRequest.source = origen
        newRequest.destination = destino
        newRequest.transportType = .Walking
        let indicaciones = MKDirections(request: newRequest)
        indicaciones.calculateDirectionsWithCompletionHandler({
            (respuesta: MKDirectionsResponse?, error: NSError?) in
            if error != nil{
                let alert = UIAlertController(title: "Fail Request", message: "You don't get have not filled fields", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            else{
                self.ShowNewRoute(respuesta!)
            }
        })
    }
    
    func focusPointInMap(point : MKMapItem){
        let centro = point.placemark.coordinate
        let region = MKCoordinateRegionMakeWithDistance(centro, 1000, 1000)
        mapRoute.setRegion(region, animated: true)
    }
    
    func ShowNewRoute(respuesta: MKDirectionsResponse){
        for ruta in respuesta.routes{
            mapRoute.addOverlay(ruta.polyline, level: MKOverlayLevel.AboveRoads)
            for paso in ruta.steps{
                print(paso.instructions)
            }
        }
        //let centro = origen.placemark.coordinate
        //let region = MKCoordinateRegionMakeWithDistance(centro, 3000, 3000)
        //mapRoute.setRegion(region, animated: true)
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 3.0
        return renderer
    }
    
    func addPoint( punto: MKMapItem){
        pointsTemp.append(punto)
        let anota = MKPointAnnotation()
        anota.coordinate = punto.placemark.coordinate
        anota.title = punto.name
        mapRoute.addAnnotation(anota)
    }
    
}
