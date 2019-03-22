//
//  School.swift
//  lab7
//
//  Created by Local Account 436-25 on 2/25/18.
//  Copyright © 2018 Local Account 436-25. All rights reserved.
//

import Foundation
import FirebaseDatabase
import MapKit

class School : NSObject, MKAnnotation, Codable{
    
    var name: String
    var city: String!
    var state: String!
    var zip: String!
    var contact_email: String!
    var latitude: Double!
    var longitude: Double!
    let ref: DatabaseReference? //a reference to the firebase database
    
    // the init for Taco Stands created in-app
//    var coordinate: CLLocationCoordinate2D{
//        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//    }

    var coordinate: CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    var title: String?{
        return name
    }
    var subtitle: String?{
        return city
    }
    init(name: String, city: String, state: String, zip: String, contact_email: String, latitude: Double,
         longitude: Double) {
        self.name = name
        self.city = city
        self.state = state
        self.zip = zip
        self.contact_email = contact_email
        self.latitude = latitude
        self.longitude = longitude
        ref = nil
        
        super.init()
    }
    init(key: String, snapshot: DataSnapshot){
        name = key
        let snapTemp = snapshot.value as! [String: AnyObject]
        let snapValues = snapTemp[key] as! [String: AnyObject]

        city = snapValues["city"] as? String ?? "N/A"
        state = snapValues["state"] as? String ?? "N/A"
        zip = snapValues["zip"] as! String
        contact_email = snapValues["contac_email"] as? String ?? "N/A"
        latitude = snapValues["latitude"] as? Double ?? 0.0
        longitude = snapValues["longitude"] as? Double ?? 0.0
        ref = snapshot.ref

        super.init()
    }

    func toAnyObject() -> Any{
        return [
            "name" : name,
            "city" : city,
            "state" : state,
            "zip" : zip,
            "contact_email" : contact_email,
            "latitude" : latitude,
            "longitude" : longitude
        ]
    }
    // the init for Taco Stands that are being synced from Firebase. A new entry in Firebase causes a TacoStand to be created with a DataSnapshot that contains al the fields needed for making a Taco Stand
//    init(snapshot: DataSnapshot) {
//        name = snapshot.key
//        let snapvalues = snapshot.value as! [String : AnyObject]
//        print("snapvalues: \(snapvalues)")
//        city = snapvalues["city"] as! String
//        specialty = snapvalues["specialty"] as! String //?? "N/A"
//        let newLocation = CLLocationCoordinate2D(latitude: snapvalues["latitude"] as! Double, longitude: snapvalues["longitude"] as! Double)
//        location = newLocation
//        ref = snapshot.ref
//    }
//
//    func toAnyObject() -> Any {
//        return [
//            "name" : name,
//            "city" : city,
//            "specialty" : specialty
//        ]
//    }
}
