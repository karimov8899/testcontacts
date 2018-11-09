//
//  AddingViewController.swift
//  TestContacts
//
//  Created by Dave on 11/9/18.
//  Copyright © 2018 DaKar. All rights reserved.
//

import UIKit
import CoreData

class AddingViewController: UIViewController , UINavigationControllerDelegate{

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var gender: UISegmentedControl!
    
    var item : Entity? = nil
    
    var pc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: Selector("endEditing:")))
        
        if item == nil {
            
            self.navigationItem.title = "Записать"
        }
        else {
            
            self.navigationItem.title = item?.name
            name.text = item?.name
            city.text = item?.city
            phone.text = item?.telephone
            if  item?.gender == "Мужчина" {
                gender.selectedSegmentIndex = 0
            }
            else {
                gender.selectedSegmentIndex = 1
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    
    
    @IBAction func save(_ sender: Any) {
        if name.text != "" {
            if item == nil {
                let entityDescription = NSEntityDescription.entity(forEntityName: "Entity", in: pc)
                
                let item = Entity(entity: entityDescription!, insertInto: pc)
                item.name = name.text
                item.city = city.text
                item.telephone = phone.text
                if gender.selectedSegmentIndex == 0 {
                    item.gender = "Мужчина"
                }
                else {
                    item.gender = "Женщина"
                }
            }
            else {
                item?.name = name.text
                item?.city = city.text
                item?.telephone = phone.text
                if gender.selectedSegmentIndex == 0 {
                    item?.gender = "Мужчина"
                }
                else {
                    item?.gender = "Женщина"
                }
            }
            
            do {
                try pc.save()
            }
            catch {
                print(error)
                return
            }
            navigationController!.popViewController(animated: true)
        }
        else {
            let alert = UIAlertController(title: title, message: "Добавьте запись", preferredStyle: .alert)
            let alertaction =  UIAlertAction(title: "Добавить!", style: .destructive, handler: nil)
            alert.addAction(alertaction)
            present(alert, animated: true)
            
        }
        
    }
    
    @IBAction func dissmiss(_ sender: Any) {
        self.resignFirstResponder()
    }
    
 

}
