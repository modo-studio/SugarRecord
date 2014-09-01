//
//  ViewController.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 03/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Initializing stack
        SugarRecord.setupCoreDataStack(automigrating: true, databaseName: "testDB")
        println(SugarRecord.currentStack())
        
//        // Creating a person
        SugarRecord.save(inBackground: true, savingBlock: { (context) -> () in
            let pedro: Person = Person.create(inContext: context) as Person
            pedro.name = "Pedro"
            pedro.age = "22"
            }) { (success, error) -> () in
                println("The user was saved successfuly")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

