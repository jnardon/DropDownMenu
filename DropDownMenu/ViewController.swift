//
//  ViewController.swift
//  DropDownMenu
//
//  Created by Juliano Krieger Nardon on 4/7/17.
//  Copyright © 2017 Juliano Krieger Nardon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.addTopMenu()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func addTopMenu() {

        let controller: TopMenuVC = self.storyboard!.instantiateViewController(withIdentifier: "TopMenuVC") as! TopMenuVC
        controller.view.frame = self.view.bounds;
        controller.willMove(toParentViewController: self)
        self.view.addSubview(controller.view)
        self.addChildViewController(controller)
        controller.didMove(toParentViewController: self)
    }

}

