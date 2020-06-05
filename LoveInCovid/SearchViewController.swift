//
//  SearchViewController.swift
//  LoveInCovid
//
//  Created by Parrot on 2020-06-02.
//  Copyright © 2020 Parrot. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var defaults:UserDefaults!
    var genders:[String] = ["male", "female", "either"]
     var selectedDay =  "male"
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.defaults = UserDefaults.standard
    }
    
    // ----------
    // MARK: PickerView Functions
    // ----------
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return genders.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return genders[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDay = genders[row]
        
        self.defaults.set(selectedDay, forKey:"gender")
        
    }
    
    // ----------
    // MARK: PickerView Functions
    // ----------
    @IBAction func searchButtonPressed(_ sender: Any) {
        
        print("Search button pressed")
        
        print("You have choose  \(selectedDay)")
        
        performSegue(withIdentifier: "RandomPersonViewController", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
