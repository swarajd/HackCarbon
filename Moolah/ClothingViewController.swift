//
//  ClothingViewController.swift
//  Moolah
//
//  Created by Varun Pitta on 6/7/17.
//  Copyright © 2017 Sun, Jessica. All rights reserved.
//

import UIKit
import GooglePlaces

class ClothingViewController: UIViewController {
    
    var placesClient: GMSPlacesClient!
    var lat = 0.0
    var long = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        placesClient = GMSPlacesClient.shared()
        currentPlace()
        // Do any additional setup after loading the view.
    }

    func currentPlace()
    {
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
//                    self.nameLabel.text = place.name
//                    self.addressLabel.text = place.formattedAddress?.components(separatedBy: ", ")
//                        .joined(separator: "\n")
                    //print(place.coordinate)
                    self.lat = place.coordinate.latitude
                    self.long = place.coordinate.longitude
                    print("Latitude: \(self.lat)")
                    print("Longitude: \(self.long)")
                    //self.semaphore.signal()
                    self.search()
                }
            }
        })
    }
    
    func search()
    {
        let todoEndpoint: String = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(long)&radius=500&&&type=clothing_store&maxprice=2&key=AIzaSyD4cb_s4PA8VThsRwH6jhT-rPPZCs-Pssc"
        guard let url = URL(string: todoEndpoint) else {
            print("THIS IS AN ERROR")
            return
        }
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else { return }
            do {
            guard let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    return
            }
            print("data \(jsonResponse)")
            guard let addr = jsonResponse["formatted_address"] as? Int else {
                print("addr err")
                return
            }
                
            guard let phn = jsonResponse["formatted_phone_number"] as? Int else {
                print("phn err")
                return
            }
                
            guard let name = jsonResponse["name"] as? Int else {
                print("name err")
                return
            }
                
            guard let rating = jsonResponse["rating"] as? Int else {
                print("rating err")
                return
            }
            
            guard let website = jsonResponse["website"] as? Int else {
                print("website err")
                return
            }
                
            } catch {
                return
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
