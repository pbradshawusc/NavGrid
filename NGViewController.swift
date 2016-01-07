//
//  NGViewController.swift
//  NavGrid
//
//  Created by Patrick Bradshaw on 1/6/16.
//  Copyright © 2016 Patrick Bradshaw. All rights reserved.
//

import Foundation
import UIKit

class NGViewController : UIViewController {
    // MARK: Labelling
    var mNGTitle = "Title"
    
    func requestTitle() -> String {
        return mNGTitle
    }
    
    // MARK: Transitions
    func viewWillBecomeActive() {
        fatalError("Must Override viewWillBecomeActive")
    }
    
    func viewDidBecomeActive() {
        fatalError("Must Override viewDidBecomeActive")
    }
    
    func viewWillResignActive() {
        fatalError("Must Override viewWillResignActive")
    }
    
    func viewDidResignActive() {
        fatalError("Must Override viewDidResignActive")
    }
}