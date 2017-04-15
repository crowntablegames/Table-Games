//
//  SurveyViewController.swift
//  Crown Proto
//
//  Created by Campbell Brobbel on 13/4/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import UIKit

class SurveyViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!

    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet weak var slider: TouchSlider!
    @IBAction func sliderChange(_ sender: Any) {
        let slider = sender as! TouchSlider
        
        let rounded : Int = Int(slider.value)
        slider.value = Float(rounded)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       textField.delegate = self
        
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


}

class TouchSlider : UISlider {
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        print(touch)
        return true
    }
}
