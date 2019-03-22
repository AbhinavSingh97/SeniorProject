//
//  MapSessionViewController.swift
//  StudyBuddy
//
//  Created by Local Account 436-25 on 3/11/18.
//  Copyright © 2018 Local Account 436-25. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import GoogleMaps
class MapSessionViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    var ref : DatabaseReference!
    let geocodekey = "AIzaSyDlfWhE301zGdWtMQCp7MdIniKCaKM3JQo"
    let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
    var locationManager = CLLocationManager()
    var sessionList = [Session]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self as CLLocationManagerDelegate
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        fetchSessions()
    }
    override func loadView() {
        navigationItem.title = "Sessions Map"
        super.loadView()
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print(marker.snippet ?? "")
        createAlert(title: "Join Session?", message: "Are you sure you want to join this session?", sessionName : marker.title!)
    }
    func registerUserForSession(ssnsName: String){
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        ref.child("sessions").observe(.childAdded) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if(ssnsName == value!["name"] as! String){
                ref.child("users").child(uid!).child("sessions").childByAutoId().setValue(value)
            }
        }
    }
    func createAlert(title : String, message : String, sessionName : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            self.registerUserForSession(ssnsName : sessionName)
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        var markerLocations = [Array<Float>]()
        var counter = 0;
        let userLocation = locations[0]
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: (userLocation.coordinate.longitude))

        let camera = GMSCameraPosition.camera(withLatitude: userLocation.coordinate.latitude, longitude: (userLocation.coordinate.longitude), zoom: 15 )
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        let marker = GMSMarker(position: center)
        marker.icon = GMSMarker.markerImage(with: .blue)
        marker.position = camera.target
        marker.title = "User Location"
        mapView.delegate = self
        marker.map = mapView
        marker.appearAnimation = GMSMarkerAnimation.pop
        markerLocations = getMarkers()
        
        for loc in markerLocations{
            let newCenter = CLLocationCoordinate2D(latitude: CLLocationDegrees(loc[0]), longitude: CLLocationDegrees(loc[1]))
            let newMarker = GMSMarker(position: newCenter)
            newMarker.title = sessionList[counter].name
            newMarker.snippet = sessionList[counter].date! + "\n" + sessionList[counter].classSection!
            newMarker.map = mapView
            counter += 1
        }
        view = mapView
    }
    func getMarkers() -> Array<Array<Float>>{
        var markerLocations = [Array<Float>]()
        for session in sessionList{
            let workingLocation = session.location
            let zipcode = parseLocation(loc: workingLocation!)
            let coords = getLatLngForZip(zipCode: zipcode)
            markerLocations.append(coords)
        }
        return markerLocations
    }
    func parseLocation(loc: String) -> String{
        var zip = ""
        let locationDetails = loc.components(separatedBy: " ")
        zip = locationDetails[locationDetails.count-2]
        return String(zip.prefix(5))
    }
    func fetchSessions(){
        print("Getting Session Data")
        sessionList.removeAll()
        ref = Database.database().reference()
        ref.child("sessions").observeSingleEvent(of: .value, with: { (snapshot) in
            if let sessionDict = snapshot.value as? [String:AnyObject] {
                for (_,sessionElement) in sessionDict {
                    //                    print(todoElement);
                    let session = Session()
                    session.name = sessionElement["name"] as? String
                    session.date = sessionElement["date"] as? String
                    session.location = sessionElement["location"] as? String
                    session.classSection = sessionElement["classSection"] as? String
                    self.sessionList.append(session)
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        print("Got the session data")
    }
    func getLatLngForZip(zipCode: String) -> Array<Float>
    {
        var coords = [Float]()
        let url = NSURL(string: "\(baseUrl)address=\(zipCode)&key=\(geocodekey)")
        let data = NSData(contentsOf: url! as URL)
        
        let json = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
        
        if let result = json["results"] as? NSArray{
            if let jsonObject = result[0] as? NSDictionary{
                if let geometry = jsonObject["geometry"] as? NSDictionary{
                    if let location = geometry["location"] as? NSDictionary{
                        let latitude = (location["lat"] as? NSNumber)!.floatValue
                        let longitude = (location["lng"] as? NSNumber)!.floatValue
                        coords.append(latitude)
                        coords.append(longitude)
                    }
                }
            }
        }
        print("I've made it")
        return coords
    }
    @IBAction func unwindToMapGoogle(segue: UIStoryboardSegue){
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
