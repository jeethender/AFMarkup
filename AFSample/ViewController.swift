//
//  ViewController.swift
//  AFSample
//
//  Created by maisapride8 on 29/08/16.
//  Copyright © 2016 maisapride8. All rights reserved.
//

import UIKit
import Alamofire
import MarkupKit

class ViewController: UITableViewController
{
   @IBOutlet var firstNameTextField: UITextField!
   @IBOutlet var lastNameTextField: UITextField!
    
    @IBOutlet var streetTextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    
    @IBOutlet var stateTextField: UITextField!
    @IBOutlet var statePickerView: LMPickerView!
    @IBOutlet var zipCodeTextField: UITextField!
    
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var emailAddressTextField: UITextField!
    
    @IBOutlet var dateOfBirthDatePicker: UIDatePicker!
    
    static let GenderSectionName = "gender"
    
    override func loadView() {
        view = LMViewBuilder.viewWithName("ViewController", owner: self, root: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainBundle = NSBundle.mainBundle()
        
        //set title
        title = mainBundle.localizedStringForKey("title", value: nil, table: nil)
        
        //Create "submit" button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: mainBundle.localizedStringForKey("submit", value: nil, table: nil), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ViewController.submitForm))
        
        
        //Load states data.
        let statesData = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("states", ofType: "json")!)
        let states = (try! NSJSONSerialization.JSONObjectWithData(statesData!, options: NSJSONReadingOptions())) as! [[String : AnyObject]]
        
        for state in states {
            statePickerView.insertRow(statePickerView.numberOfRowsInComponent(0), inComponent: 0, withTitle: state["name"] as! String, value: state["code"])
        }
        
    }
    
    
    
    func submitForm(){
        
        //Get selected state code.
        let state = (stateTextField.text!.isEmpty) ? "" : statePickerView.valueForRow(statePickerView.selectedRowInComponent(0), forComponent: 0)!
        
        //Format date of Birth.
        let dateFormatter = NSDateFormatter()
        
         dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .NoStyle
        
        let dateOfBirth = dateFormatter.stringFromDate(dateOfBirthDatePicker.date)
        
        //get Gender selection
        let genderSection = tableView.sectionWithName(ViewController.GenderSectionName)
        let selectedGenderRow = tableView.rowForCheckedCellInSection(genderSection)
        
        let gender = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: selectedGenderRow, inSection: genderSection))!.value!
        
        //Simulate submission form.
        
        let form = [
            "firstName":firstNameTextField.text!,
            "lastName":lastNameTextField.text!,
            "street":streetTextField.text!,
            "city": cityTextField.text!,
            "state": state,
            "ZipCode": zipCodeTextField.text!,
            "phoneNumber": phoneNumberTextField.text!,
            "emailID": emailAddressTextField.text!,
            "dateOfBirth": dateOfBirth,
            "Gender": gender
        ]
        
        let data = try! NSJSONSerialization.dataWithJSONObject(form, options: NSJSONWritingOptions.PrettyPrinted)
        print(String(data: data, encoding: NSUTF8StringEncoding)!)
        print("Hello")
        
        
        //Display the form submitted alert message.
        let alertController = UIAlertController(title: "Status", message: "Form Submitted", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
    
    func cancelStateEdit(){
        //Hide keyboard.
        stateTextField.resignFirstResponder()
    }
    
    func updateStateText(){
        //update statetextfield
        stateTextField.text = statePickerView.titleForRow(statePickerView.selectedRowInComponent(0), forComponent: 0)!
        stateTextField.resignFirstResponder()
    }

    
    
}
































