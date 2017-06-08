//
//  GroceriesTableViewController.swift
//  Moolah
//
//  Created by Varun Pitta on 6/8/17.
//  Copyright © 2017 Sun, Jessica. All rights reserved.
//

import UIKit
import GooglePlaces


class GroceriesTableViewController: UITableViewController {

    //let serialQueue = DispatchQueue(label: "queuename")
    
    var foodMaster = [[String:Any]]()
    var foodTitlesArray = [String]()
    var foodDiscountArray = [String]()
    var foodExpDateArray = [Int]()
    
    var placesClient: GMSPlacesClient!
    var lat = 0.0
    var long = 0.0
    
    let MINT_CREAM = UIColor(red:245.0/255.0, green: 255.0/255.0, blue:250.0/255.0, alpha: 1.0)
    
    let OLD_LACE = UIColor(red: 253.0/255.0, green: 245.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator()
        
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        placesClient = GMSPlacesClient.shared()
        currentPlace()
        
        
        // Do any additional setup after loading the view.
        //self.tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.tableView.reloadData()
        super.viewWillAppear(animated)
//        DispatchQueue.main.async {
//            self.currentPlace()
//            self.tableView.dataSource = self
//        }
    }
    
    func activityIndicator() {
        let rect = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator = UIActivityIndicatorView(frame: rect)
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    func currentPlace()
    {
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.white
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
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    func search()
    {
        let todoEndpoint: String = "https://hackcarbonserver.herokuapp.com/get_deals?lat=\(lat)&long=\(long)&category=groceries"
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
                //print("data \(jsonResponse)")
                //guard let
                guard let food = jsonResponse["deals"] as? [[String: Any]] else {
                    print("groceries err")
                    return
                }
                
                self.foodMaster = food
                //print(self.foodMaster)
                
                for obj in food {
                    if let title = obj["announcementTitle"] as? String {
                        print(title)
                        
                        self.foodTitlesArray.append(title)
                        
                        //print(self.foodTitlesArray)
                    }
                    if let disc = obj["discountAmt"] as? String {
                        print(disc)
                        
                        self.foodDiscountArray.append(disc)
                    }
                    //if let disp = obj["discountPercent"] as? String {
                        //print(disp)
                    //}
                    if let expA = obj["expiresAt"] as? Int {
                        print(expA)
                        self.foodExpDateArray.append(expA)
                    }
                }
                //if let title = food["announcementTitle"] as? String {
                //    print(title)
               // }
            
                
                //print(food)
                
                self.tableView.reloadData()
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
                
                
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
        
        return 1
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        print(foodMaster.count)
        return foodTitlesArray.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rowNumber:Int = (indexPath as NSIndexPath).row
        
        let cell : GroceriesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "GroceriesCell", for: indexPath) as! GroceriesTableViewCell

        //print("hello")
        print(self.foodTitlesArray)
        
        myCondition: if (foodTitlesArray.count > 0 && foodDiscountArray.count > 0 && foodExpDateArray.count > 0) {
            if (rowNumber > 10) {
                break myCondition
            }
            cell.groceriesCouponLabel.text = self.foodTitlesArray[rowNumber]
            
            cell.groceriesCouponAmountLabel.text = self.foodDiscountArray[rowNumber]
            
            cell.groceriesCouponExpDateLabel.text = String("\(self.foodExpDateArray[rowNumber]) days")
        }
 

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).row % 2 == 0 {
            cell.backgroundColor = MINT_CREAM
        } else {
            cell.backgroundColor = OLD_LACE
        }
    }
    

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
