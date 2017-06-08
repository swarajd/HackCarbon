//
//  ShopEntertainmentTableViewController.swift
//  Moolah
//
//  Created by Varun Pitta on 6/8/17.
//  Copyright © 2017 Sun, Jessica. All rights reserved.
//

import UIKit
import GooglePlaces

class ShopEntertainmentTableViewController: UITableViewController {

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
        let todoEndpoint: String = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(long)&radius=500&&&type=bar&maxprice=2&key=AIzaSyD4cb_s4PA8VThsRwH6jhT-rPPZCs-Pssc"
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
