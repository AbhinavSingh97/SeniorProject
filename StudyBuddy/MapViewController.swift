//
//  MapViewController.swift
//  StudyBuddy
//
//  Created by Local Account 436-25 on 3/7/18.
//  Copyright © 2018 Local Account 436-25. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import GeoFire

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var MapView: MKMapView!
    
    var ref : DatabaseReference!
    var geoFire : GeoFire?
    var regionQuery : GFRegionQuery?
    let locationManager = CLLocationManager()
    let cscBuilding = CLLocationCoordinate2D(latitude: 35.300066, longitude: -120.662065)
    let SCHOOLS = "https://code.org/schools.json"
    var school : School?
    var currentSchool : School?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager()
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let request = URLRequest(url: URL(string: SCHOOLS)!)
        
        let task : URLSessionDataTask = session.dataTask(with: request)
        { (receivedData, response, error) -> Void in
            
            //Get Data and store it in the firebase database
            if let data = receivedData{
                do{
                    //print("Trying to Decode information")
                    let decoder = JSONDecoder()
                    let schoolInformation = try decoder.decode(SchoolService.self, from: data)
                    let localSchools = schoolInformation.schools.filter{$0.zip != nil && $0.zip.hasPrefix("93")}
                    let jsonLocalSchools = localSchools.map{self.schoolsToDict(school: $0)}
                    
                    self.ref = Database.database().reference();
                    self.ref?.child("schools").setValue(jsonLocalSchools)
                    //print(localSchools.count)
                    self.geoFire = GeoFire(firebaseRef: Database.database().reference().child("schools"))
                    
                    //Sets the initial location
                    let span = MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
                    let newRegion = MKCoordinateRegion(center: self.cscBuilding, span: span)
                    self.MapView.setRegion(newRegion, animated: true)
                }catch{
                    print(error)
                }}
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureLocationManager() {
        CLLocationManager.locationServicesEnabled()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = 1.0
        locationManager.distanceFilter = 100.0
        locationManager.startUpdatingLocation()
    }
    func schoolsToDict(school: School)->[String: Any]{
        var dict = [String: Any]()
        dict["name"] = school.name
        dict["city"] = school.city
        dict["state"] = school.state
        dict["zip"] = school.zip
        dict["contact_email"] = school.contact_email
        dict["latitude"] = school.latitude
        dict["longitude"] = school.longitude
        
        return dict
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)
        
        updateRegionQuery()
    }
    
    func updateRegionQuery() {
        if let oldQuery = regionQuery {
            oldQuery.removeAllObservers()
        }
        
        regionQuery = geoFire?.query(with: MapView.region)
        
        regionQuery?.observe(.keyEntered, with: { (key, location) in
            self.ref?.queryOrderedByKey().queryEqual(toValue: key).observe(.value, with: { snapshot in
                
                let newStand = School(key:key,snapshot:snapshot)
                self.addStand(newStand)
            })
        })
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        mapView.setRegion(MKCoordinateRegionMake((mapView.userLocation.location?.coordinate)!, MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: true)
        
    }
    
    func addStand(_ stand : School) {
        DispatchQueue.main.async {
            self.MapView.addAnnotation(stand)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is School {
            let annotationView = MKPinAnnotationView()
            annotationView.pinTintColor = .red
            annotationView.annotation = annotation
            annotationView.canShowCallout = true
            annotationView.animatesDrop = true
            
            return annotationView
        }
        
        return nil
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
