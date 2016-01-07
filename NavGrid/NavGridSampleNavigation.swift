//
//  NavGridSampleUse.swift
//  NavGrid
//
//  Created by Patrick Bradshaw on 1/6/16.
//  Copyright © 2016 Patrick Bradshaw. All rights reserved.
//

import Foundation
import UIKit

class NavGridSampleNavigation : NGNavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Implement your own behavior for adding view controllers here
        let colorArray = [[UIColor.blackColor(), UIColor.greenColor(), UIColor.yellowColor()], [UIColor.grayColor(), UIColor.purpleColor(), UIColor.orangeColor()], [UIColor.blueColor(), UIColor.brownColor(), UIColor.darkGrayColor()]]
        
        
        for i in 0...2 {
            for j in 0...2 {
                do {
                    // Ideally, each new controller added should be inside it's own do-try-catch clause in order to prevent an early error from preventing later controllers being added
                    let colorView = NavGridSampleViewController()
                    colorView.view.backgroundColor = colorArray[i][j]
                    colorView.mNGTitle = String(i, j)
                    
                    // Set up our two named controllers for reference purposes
                    if i == 0 && j == 0 {
                        let label = UILabel(frame: colorView.view.frame)
                        label.frame.size.height -= ngncGetNavBarHeightWithStatusBar()
                        label.backgroundColor = UIColor.clearColor()
                        label.textColor = UIColor.whiteColor()
                        label.text = "Profile"
                        label.textAlignment = .Center
                        label.font = UIFont.systemFontOfSize(56)
                        label.adjustsFontSizeToFitWidth = true
                        colorView.view.addSubview(label)
                    } else if i == 1 && j == 1 {
                        let label = UILabel(frame: colorView.view.frame)
                        label.frame.size.height -= ngncGetNavBarHeightWithStatusBar()
                        label.backgroundColor = UIColor.clearColor()
                        label.textColor = UIColor.whiteColor()
                        label.text = "Search"
                        label.textAlignment = .Center
                        label.font = UIFont.systemFontOfSize(56)
                        label.adjustsFontSizeToFitWidth = true
                        colorView.view.addSubview(label)
                    }
                    
                    // Actually append the view controller (we do this last so that we can use the original frame anchored at 0,0 in our label creation rather than the newly assigned frame uppon appending to the grid)
                    try ngncAppendNGViewControllerToLocation(i, y: j, vc: colorView)
                } catch NGGridError.ViewControllerAlreadyExists {
                    // This will occur if a view controller already exists at this location
                } catch {
                    // Should never occur
                }
            }
        }
        
        // Enable swipe transitions
        ngncEnableSwipeNavigation()
        
        // Navigate to starting page
        do {
            try ngncNavigateToLocation(0, y: 0)
        } catch NGGridError.GridMoveAttemptPastBounds {
            // We are already at the right edge
        } catch {
            // Should never occur
            fatalError()
        }
    }
    
    override func ngncLeftButtonTouchUpInside() {
        do {
            try ngncNavigateToLocation(0, y: 0)
        } catch NGGridError.GridMoveAttemptPastBounds {
            // We are already at the right edge
        } catch {
            // Should never occur
            fatalError()
        }
    }
    
    override func ngncRightButtonTouchUpInside() {
        do {
            try ngncNavigateToLocation(1, y: 1)
        } catch NGGridError.GridMoveAttemptPastBounds {
            // We are already at the bottom edge
        } catch {
            // Should never occur
            fatalError()
        }
    }
}