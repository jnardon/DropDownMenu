//
//  TopMenuVC.swift
//  DropDownMenu
//
//  Created by Juliano Krieger Nardon on 4/7/17.
//  Copyright © 2017 Juliano Krieger Nardon. All rights reserved.
//

import UIKit

class TopMenuVC : UIViewController {
    
    @IBOutlet weak var topMenuViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topMenuView: UIView!
    
    @IBOutlet weak var hidden3Label: UILabel!
    @IBOutlet weak var hidden2Label: UILabel!
    @IBOutlet weak var hidden1Label: UILabel!
    
    var viewsToHide = [UIView]()
    var menuIsDown = false
    
    // MARK: Constants

    let adjustDuration : TimeInterval = 0.2
    let dropDuration : TimeInterval = 1.0
    let downHeight : CGFloat = 500
    let upHeight : CGFloat = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topMenuViewHeightConstraint.constant = self.upHeight
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanFrom(recognizer:)))
        self.view.addGestureRecognizer(panGestureRecognizer)
        
        self.populateViewsToHide()
    }
    
    func populateViewsToHide() {
        self.viewsToHide.append(self.hidden1Label)
        self.viewsToHide.append(self.hidden2Label)
        self.viewsToHide.append(self.hidden3Label)
        
        for viewToHide in viewsToHide {
            viewToHide.alpha = 0
        }
    }
    
  
    @IBAction func topMenuAction(_ sender: Any) {
        if self.menuIsDown {
            self.dropUpMenu(duration: self.dropDuration)
        } else {
            self.dropDownMenu(duration: self.dropDuration)
        }
    }
    
    func dropDownMenu(duration: TimeInterval) {
        self.view.layoutIfNeeded()
        
        
        UIView.animate(withDuration: duration, animations: {self.topMenuViewHeightConstraint.constant = 500
            self.view.layoutIfNeeded()}) { (true) in
                if self.viewsToHide.count > 0 {
                    for viewToHide in self.viewsToHide {
                        UIView.animate(withDuration: 0.2, animations: {viewToHide.alpha = 1})
                    }
                }

        }
        
        self.menuIsDown = true
    }
    
    func dropUpMenu(duration: TimeInterval) {
        self.view.layoutIfNeeded()
        
        if self.viewsToHide.count > 0 {
            for viewToHide in self.viewsToHide {
                UIView.animate(withDuration: 0.2, animations: {viewToHide.alpha = 0})
            }
        }

        UIView.animate(withDuration: duration, animations: {
            self.topMenuViewHeightConstraint.constant = 200
            self.view.layoutIfNeeded()})         
        self.menuIsDown = false
    }
    
    func handlePanFrom(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            let touchLocation = recognizer.location(in: recognizer.view)
            
            print("pan began \(touchLocation)")
        } else if recognizer.state == .changed {
            var translation = recognizer.translation(in: recognizer.view!)
            translation = CGPoint(x: translation.x, y: -translation.y)
            
            var currentHeight : CGFloat = 0.0
            
            if self.menuIsDown {
                currentHeight = self.downHeight
            } else {
                currentHeight = self.upHeight
            }
            
            let yPositionToGo = currentHeight - translation.y
            
            if yPositionToGo < self.downHeight && yPositionToGo > self.upHeight {
                self.topMenuViewHeightConstraint.constant = yPositionToGo
                
                if self.viewsToHide.count > 0 {
                    for viewToHide in self.viewsToHide {
                        self.calculateAlphaPercentage(viewToBeCalculated: viewToHide)
                    }
                }
            }
            
            print("pan changed \(translation)")
        } else if recognizer.state == .ended {
            let currentHeight = self.topMenuViewHeightConstraint.constant
            
            if currentHeight.distance(to: self.downHeight) < -currentHeight.distance(to: self.upHeight) {
                self.dropDownMenu(duration: self.adjustDuration)
            } else {
                self.dropUpMenu(duration: self.adjustDuration)
            }
        }
    }
    
    func calculateAlphaPercentage(viewToBeCalculated: UIView) {
        let viewY = viewToBeCalculated.frame.origin.y + viewToBeCalculated.frame.height
        let currentY = self.topMenuViewHeightConstraint.constant
        
        if currentY > viewY {
            viewToBeCalculated.alpha = viewY.distance(to: currentY) / 50
        } else {
            viewToBeCalculated.alpha = viewY.distance(to: currentY) / 50
        }
    }
}
