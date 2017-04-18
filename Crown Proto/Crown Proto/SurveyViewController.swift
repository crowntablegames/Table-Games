//
//  SurveyViewController.swift
//  Crown Proto
//
//  Created by Campbell Brobbel on 13/4/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import UIKit

class SurveyViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let positiveFbackArray : [String] = ["They paid me a lot of money", "They were friendly", "Game pace was excellent", "Great business understanding", "Other"]

    let negativeFbackArray : [String] = ["They took my money", "They were unfriendly", "Game pace was too fast/slow", "Lacking business knowledge", "Other"]
    
    @IBOutlet weak var textField: UITextField!

    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet weak var slider: TouchSlider!
    @IBAction func sliderChange(_ sender: Any) {
        let slider = sender as! TouchSlider
        
        let rounded : Int = Int(slider.value)
        slider.value = Float(rounded)
        pickerView.reloadAllComponents()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerView()
        // Do any additional setup after loading the view.
       textField.delegate = self
        
    }
    
    func setupPickerView() {
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.layer.cornerRadius = 10
        
    }
    func updatePickerView() {
        
    }
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    @IBAction func submit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
        print("Dismiss")
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
  
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    // returns the # of rows in each component..
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var numberOfRows : Int
        if slider.value < 3 {
            numberOfRows = negativeFbackArray.count
        }
        else {
            numberOfRows = positiveFbackArray.count
        }
        return numberOfRows
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title : String
        
        if slider.value < 3 {
            title = negativeFbackArray[row]
        }
        else {
            title = positiveFbackArray[row]
        }
        return title
    }

}

class TouchSlider : UISlider {
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        print(touch)
        return true
    }
}
