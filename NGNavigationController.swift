//
//  NGNavigationController.swift
//  NavGrid
//
//  Created by Patrick Bradshaw on 1/6/16.
//  Copyright © 2016 Patrick Bradshaw. All rights reserved.
//

import Foundation
import UIKit

enum NGGridError: ErrorType {
    case ViewControllerAlreadyExists
    case ViewControllerDoesNotExist
    case GridMoveAttemptPastBounds
}

class NGNavigationController : UIViewController {
    // MARK: Initialization
    var mNGInitialized = false
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        ngncInitializationImplementation()
    }
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        ngncInitializationImplementation()
    }
    
    func ngncInitializationImplementation() {
        if !mNGInitialized {
            mNGInitialized = true
            
            
        }
    }
    
    override func viewDidLoad() {
        ngncResetNavigationHeaderToDefaults()
    }
    
    // MARK: Top Navigation Bar
    let mNGNavBarHeight = CGFloat(44)
    var mNGNavigationHeader : UIView?
    var mNGStatusBarBackground : UIView?
    var mNGLightStatusBar = true
    var mNGLeftButton : UIButton?
    var mNGRightButton : UIButton?
    var mNGCenterLabel : UILabel?
    
    func ngncResetNavigationHeaderToDefaults() {
        // Clear the old header if one exists
        mNGNavigationHeader?.removeFromSuperview()
        
        // Create the new header
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        mNGNavigationHeader = UIView(frame: CGRectMake(0, 0, view.frame.width, statusBarHeight + mNGNavBarHeight))
        mNGNavigationHeader?.backgroundColor = UIColor.redColor()
        view.addSubview(mNGNavigationHeader!)
        
        mNGStatusBarBackground = UIView(frame: CGRectMake(0, 0, view.frame.width, statusBarHeight))
        mNGStatusBarBackground?.backgroundColor = UIColor.blackColor()
        mNGNavigationHeader?.addSubview(mNGStatusBarBackground!)
        
        mNGLeftButton = UIButton(type: .System)
        mNGLeftButton?.frame = CGRectMake(5.0, statusBarHeight + 4.0, mNGNavBarHeight - 8.0, mNGNavBarHeight - 8.0)
        mNGLeftButton?.backgroundColor = UIColor.clearColor()
        mNGLeftButton?.setImage(UIImage(named: "NGProfile"), forState: .Normal)
        mNGLeftButton?.imageEdgeInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
        mNGLeftButton?.tintColor = UIColor.whiteColor()
        mNGLeftButton?.addTarget(self, action: "ngncLeftButtonTouchUpInside", forControlEvents: .TouchUpInside)
        mNGLeftButton?.addTarget(self, action: "ngncLeftButtonTouchUpOutside", forControlEvents: .TouchUpOutside)
        mNGLeftButton?.addTarget(self, action: "ngncLeftButtonTouchDown", forControlEvents: .TouchDown)
        mNGNavigationHeader?.addSubview(mNGLeftButton!)
        
        mNGRightButton = UIButton(type: .System)
        mNGRightButton?.frame = CGRectMake(view.frame.width - (mNGNavBarHeight - 8.0) - 5.0, statusBarHeight + 4.0, mNGNavBarHeight - 8.0, mNGNavBarHeight - 8.0)
        mNGRightButton?.backgroundColor = UIColor.clearColor()
        mNGRightButton?.setImage(UIImage(named: "NGSearch"), forState: .Normal)
        mNGRightButton?.imageEdgeInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
        mNGRightButton?.tintColor = UIColor.whiteColor()
        mNGRightButton?.addTarget(self, action: "ngncRightButtonTouchUpInside", forControlEvents: .TouchUpInside)
        mNGRightButton?.addTarget(self, action: "ngncRightButtonTouchUpOutside", forControlEvents: .TouchUpOutside)
        mNGRightButton?.addTarget(self, action: "ngncRightButtonTouchDown", forControlEvents: .TouchDown)
        mNGNavigationHeader?.addSubview(mNGRightButton!)
        
        mNGCenterLabel = UILabel(frame: CGRectMake(mNGLeftButton!.frame.origin.x + mNGLeftButton!.frame.size.width + 5.0, statusBarHeight + 4.0, view.frame.width - (mNGLeftButton!.frame.origin.x + mNGLeftButton!.frame.size.width + 5.0) - (view.frame.width - (mNGRightButton!.frame.origin.x)) - 5.0, mNGNavBarHeight - 8.0))
        mNGCenterLabel?.backgroundColor = UIColor.clearColor()
        mNGCenterLabel?.textAlignment = .Center
        mNGCenterLabel?.textColor = UIColor.whiteColor()
        mNGCenterLabel?.text = "Title"
        mNGCenterLabel?.adjustsFontSizeToFitWidth = true
        mNGCenterLabel?.font = UIFont.systemFontOfSize(48)
        mNGNavigationHeader?.addSubview(mNGCenterLabel!)
    }
    
    func ngncGetStatusBarHeight() -> CGFloat {
        return UIApplication.sharedApplication().statusBarFrame.size.height
    }
    
    func ngncGetNavBarHeight() -> CGFloat {
        return mNGNavBarHeight
    }
    
    func ngncGetNavBarHeightWithStatusBar() -> CGFloat {
        return mNGNavBarHeight + UIApplication.sharedApplication().statusBarFrame.size.height
    }
    
    func ngncSetNavigationHeaderBackgroundColor(color: UIColor) {
        mNGNavigationHeader?.backgroundColor = color
    }
    
    func ngncSetNavigationHeaderStatusBarColor(color: UIColor) {
        mNGStatusBarBackground?.backgroundColor = color
    }
    
    func ngncLeftButtonTouchDown() {
        // STUB
    }
    
    func ngncLeftButtonTouchUpOutside() {
        // STUB
    }
    
    func ngncLeftButtonTouchUpInside() {
        // STUB
    }
    
    func ngncRightButtonTouchDown() {
        // STUB
    }
    
    func ngncRightButtonTouchUpOutside() {
        // STUB
    }
    
    func ngncRightButtonTouchUpInside() {
        // STUB
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        if mNGLightStatusBar {
        return UIStatusBarStyle.LightContent
        } else {
            return UIStatusBarStyle.Default
        }
    }
    
    // MARK: Grid Setup
    var mNGViewControllerGrid = Array<Array<NGViewController?>>()
    var mNGTopViewController = (0, 0)
    
    func ngncAppendNGViewControllerToLocation(x: Int, y: Int, vc: NGViewController) throws {
        // First check if a NGViewController already exists in this location, if so, throw an error
        if mNGViewControllerGrid.count > x {
            if mNGViewControllerGrid[x].count > y {
                if mNGViewControllerGrid[x][y] != nil {
                    throw NGGridError.ViewControllerAlreadyExists
                }
            }
        }
        
        // Set the desired location and create a new View Controller
        var defaultFrame = view.frame
        defaultFrame.origin.x = CGFloat(x) * view.frame.width - (CGFloat(mNGTopViewController.0) * view.frame.width)
        defaultFrame.origin.y = ngncGetNavBarHeightWithStatusBar() + CGFloat(y) * (view.frame.height - ngncGetNavBarHeightWithStatusBar()) - (CGFloat(mNGTopViewController.1) * (view.frame.height - ngncGetNavBarHeightWithStatusBar()))
        defaultFrame.size.height -= ngncGetNavBarHeightWithStatusBar()
        vc.view.frame = defaultFrame
        
        // Prime the arrays to the proper lengths for the new View Controller
        if mNGViewControllerGrid.count <= x {
            for _ in mNGViewControllerGrid.count - 1 ... x {
                mNGViewControllerGrid.append(Array<NGViewController?>())
            }
        }
        if mNGViewControllerGrid[x].count <= y {
            for _ in mNGViewControllerGrid[x].count - 1 ... y {
                mNGViewControllerGrid[x].append(nil)
            }
        }
        
        // Assign the View Controller and return it
        mNGViewControllerGrid[x][y] = vc
        addChildViewController(vc)
        view.addSubview(vc.view)
        view.bringSubviewToFront(mNGNavigationHeader!)
        if mNGSwipeView != nil {
            view.bringSubviewToFront(mNGSwipeView!)
        }
    }
    
    func ngncGetNGViewControllerForLocation(x: Int, y: Int) throws -> NGViewController {
        if mNGViewControllerGrid.count < x {
            throw NGGridError.ViewControllerDoesNotExist
        } else if mNGViewControllerGrid[x].count < y {
            throw NGGridError.ViewControllerDoesNotExist
        } else if mNGViewControllerGrid[x][y] == nil {
            throw NGGridError.ViewControllerDoesNotExist
        } else {
            return mNGViewControllerGrid[x][y]!
        }
    }
    
    func ngncGetTopViewController() throws -> NGViewController {
        return try ngncGetNGViewControllerForLocation(mNGTopViewController.0, y: mNGTopViewController.1)
    }
    
    // MARK: Grid Navigation
    func ngncCycleLeft() throws {
        if mNGTopViewController.1 == 0 {
            // Attempt to move left when already at absolute left edge
            throw NGGridError.GridMoveAttemptPastBounds
        } else if mNGViewControllerGrid[mNGTopViewController.0][mNGTopViewController.1 - 1] == nil {
            // Attempt to move left when already at local left edge
            throw NGGridError.GridMoveAttemptPastBounds
        }
        
        // Notify the view controllers that will appear and disappear
        mNGViewControllerGrid[mNGTopViewController.0][mNGTopViewController.1]?.viewWillResignActive()
        mNGViewControllerGrid[mNGTopViewController.0][mNGTopViewController.1 - 1]?.viewWillBecomeActive()
        
        // Cycle over all view controllers and shift them to the left by subframe width
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            for i in 0...self.mNGViewControllerGrid.count - 1 {
                if self.mNGViewControllerGrid[i].count > 0 {
                    for j in 0...self.mNGViewControllerGrid[i].count - 1 {
                        if self.mNGViewControllerGrid[i].count > j && self.mNGViewControllerGrid[i][j] != nil {
                            self.mNGViewControllerGrid[i][j]!.view.frame.origin.x += self.view.frame.width
                        }
                    }
                }
            }
            self.mNGCenterLabel?.alpha = 0.0
            }) { (completed) -> Void in
                // Notify the view controllers that they did appear and disappear
                self.mNGViewControllerGrid[self.mNGTopViewController.0][self.mNGTopViewController.1]?.viewDidResignActive()
                self.mNGViewControllerGrid[self.mNGTopViewController.0][self.mNGTopViewController.1 - 1]?.viewDidBecomeActive()
                self.mNGTopViewController.1 -= 1
                self.mNGCenterLabel?.text = self.mNGViewControllerGrid[self.mNGTopViewController.0][self.mNGTopViewController.1]!.requestTitle()
                UIView.animateWithDuration(0.15, animations: { () -> Void in
                    self.mNGCenterLabel?.alpha = 1.0
                })
        }
    }
    
    func ngncCycleRight() throws {
        if mNGTopViewController.1 == mNGViewControllerGrid[mNGTopViewController.0].count - 1 {
            // Attempt to move right when already at absolute right edge
            throw NGGridError.GridMoveAttemptPastBounds
        } else if mNGViewControllerGrid[mNGTopViewController.0][mNGTopViewController.1 + 1] == nil {
            // Attempt to move right when already at local right edge
            throw NGGridError.GridMoveAttemptPastBounds
        }
        
        // Notify the view controllers that will appear and disappear
        mNGViewControllerGrid[mNGTopViewController.0][mNGTopViewController.1]?.viewWillResignActive()
        mNGViewControllerGrid[mNGTopViewController.0][mNGTopViewController.1 + 1]?.viewWillBecomeActive()
        
        // Cycle over all view controllers and shift them to the right by subframe width
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            for i in 0...self.mNGViewControllerGrid.count - 1 {
                if self.mNGViewControllerGrid[i].count > 0 {
                    for j in 0...self.mNGViewControllerGrid[i].count - 1 {
                        if self.mNGViewControllerGrid[i].count > j && self.mNGViewControllerGrid[i][j] != nil {
                            self.mNGViewControllerGrid[i][j]!.view.frame.origin.x -= self.view.frame.width
                        }
                    }
                }
            }
            self.mNGCenterLabel?.alpha = 0.0
            }) { (completed) -> Void in
                // Notify the view controllers that they did appear and disappear
                self.mNGViewControllerGrid[self.mNGTopViewController.0][self.mNGTopViewController.1]?.viewDidResignActive()
                self.mNGViewControllerGrid[self.mNGTopViewController.0][self.mNGTopViewController.1 + 1]?.viewDidBecomeActive()
                self.mNGTopViewController.1 += 1
                self.mNGCenterLabel?.text = self.mNGViewControllerGrid[self.mNGTopViewController.0][self.mNGTopViewController.1]!.requestTitle()
                UIView.animateWithDuration(0.15, animations: { () -> Void in
                    self.mNGCenterLabel?.alpha = 1.0
                })
        }
    }
    
    func ngncCycleUp() throws {
        if mNGTopViewController.0 == 0 {
            // Attempt to move up when already at absolute top edge
            throw NGGridError.GridMoveAttemptPastBounds
        } else if (mNGViewControllerGrid[mNGTopViewController.0 - 1].count - 1 >= mNGTopViewController.1) && (mNGViewControllerGrid[mNGTopViewController.0 - 1][mNGTopViewController.1] == nil) {
            // Attempt to move up when already at local top edge
            throw NGGridError.GridMoveAttemptPastBounds
        } else if mNGViewControllerGrid[mNGTopViewController.0 - 1].count < mNGTopViewController.1 {
            // Attempt to move up when already at local top edge
            throw NGGridError.GridMoveAttemptPastBounds
        }
        
        // Notify the view controllers that will appear and disappear
        mNGViewControllerGrid[mNGTopViewController.0][mNGTopViewController.1]?.viewWillResignActive()
        mNGViewControllerGrid[mNGTopViewController.0 - 1][mNGTopViewController.1]?.viewWillBecomeActive()
        
        // Cycle over all view controllers and shift them down by subframe height
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            for i in 0...self.mNGViewControllerGrid.count - 1 {
                if self.mNGViewControllerGrid[i].count > 0 {
                    for j in 0...self.mNGViewControllerGrid[i].count - 1 {
                        if self.mNGViewControllerGrid[i].count > j && self.mNGViewControllerGrid[i][j] != nil {
                            self.mNGViewControllerGrid[i][j]!.view.frame.origin.y += (self.view.frame.height - self.ngncGetNavBarHeightWithStatusBar())
                        }
                    }
                }
            }
            self.mNGCenterLabel?.alpha = 0.0
            }) { (completed) -> Void in
                // Notify the view controllers that they did appear and disappear
                self.mNGViewControllerGrid[self.mNGTopViewController.0][self.mNGTopViewController.1]?.viewDidResignActive()
                self.mNGViewControllerGrid[self.mNGTopViewController.0 - 1][self.mNGTopViewController.1]?.viewDidBecomeActive()
                self.mNGTopViewController.0 -= 1
                self.mNGCenterLabel?.text = self.mNGViewControllerGrid[self.mNGTopViewController.0][self.mNGTopViewController.1]!.requestTitle()
                UIView.animateWithDuration(0.15, animations: { () -> Void in
                    self.mNGCenterLabel?.alpha = 1.0
                })
        }
    }
    
    func ngncCycleDown() throws {
        if mNGTopViewController.0 == mNGViewControllerGrid.count - 1 {
            // Attempt to move down when already at absolute bottom edge
            throw NGGridError.GridMoveAttemptPastBounds
        } else if (mNGViewControllerGrid[mNGTopViewController.0 + 1].count - 1 >= mNGTopViewController.1) && (mNGViewControllerGrid[mNGTopViewController.0 + 1][mNGTopViewController.1] == nil) {
            // Attempt to move down when already at local bottom edge
            throw NGGridError.GridMoveAttemptPastBounds
        } else if mNGViewControllerGrid[mNGTopViewController.0 + 1].count - 1 < mNGTopViewController.1 {
            // Attempt to move down when already at local bottom edge
            throw NGGridError.GridMoveAttemptPastBounds
        }
        
        // Notify the view controllers that will appear and disappear
        mNGViewControllerGrid[mNGTopViewController.0][mNGTopViewController.1]?.viewWillResignActive()
        mNGViewControllerGrid[mNGTopViewController.0 + 1][mNGTopViewController.1]?.viewWillBecomeActive()
        
        // Cycle over all view controllers and shift them up by subframe height
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            for i in 0...self.mNGViewControllerGrid.count - 1 {
                if self.mNGViewControllerGrid[i].count > 0 {
                    for j in 0...self.mNGViewControllerGrid[i].count - 1 {
                        if self.mNGViewControllerGrid[i].count > j && self.mNGViewControllerGrid[i][j] != nil {
                            self.mNGViewControllerGrid[i][j]!.view.frame.origin.y -= (self.view.frame.height - self.ngncGetNavBarHeightWithStatusBar())
                        }
                    }
                }
            }
            self.mNGCenterLabel?.alpha = 0.0
            }) { (completed) -> Void in
                // Notify the view controllers that they did appear and disappear
                self.mNGViewControllerGrid[self.mNGTopViewController.0][self.mNGTopViewController.1]?.viewDidResignActive()
                self.mNGViewControllerGrid[self.mNGTopViewController.0 + 1][self.mNGTopViewController.1]?.viewDidBecomeActive()
                self.mNGTopViewController.0 += 1
                self.mNGCenterLabel?.text = self.mNGViewControllerGrid[self.mNGTopViewController.0][self.mNGTopViewController.1]!.requestTitle()
                UIView.animateWithDuration(0.15, animations: { () -> Void in
                    self.mNGCenterLabel?.alpha = 1.0
                })
        }
    }
    
    func ngncNavigateToLocation(x: Int, y: Int) throws {
        if mNGViewControllerGrid.count - 1 < x {
            throw NGGridError.GridMoveAttemptPastBounds
        } else if mNGViewControllerGrid[x].count - 1 < y {
            throw NGGridError.GridMoveAttemptPastBounds
        }
        
        // Notify the view controllers that will appear and disappear
        mNGViewControllerGrid[mNGTopViewController.0][mNGTopViewController.1]?.viewWillResignActive()
        mNGViewControllerGrid[x][y]?.viewWillBecomeActive()
        
        // Cycle over all view controllers and shift them by subframe height and width accordingly
        let xDist = mNGViewControllerGrid[x][y]!.view.frame.origin.x
        let yDist = mNGViewControllerGrid[x][y]!.view.frame.origin.y - ngncGetNavBarHeightWithStatusBar()
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            for i in 0...self.mNGViewControllerGrid.count - 1 {
                if self.mNGViewControllerGrid[i].count > 0 {
                    for j in 0...self.mNGViewControllerGrid[i].count - 1 {
                        if self.mNGViewControllerGrid[i].count > j && self.mNGViewControllerGrid[i][j] != nil {
                            self.mNGViewControllerGrid[i][j]!.view.frame.origin.x -= xDist
                            self.mNGViewControllerGrid[i][j]!.view.frame.origin.y -= yDist
                        }
                    }
                }
            }
            self.mNGCenterLabel?.alpha = 0.0
            }) { (completed) -> Void in
                // Notify the view controllers that they did appear and disappear
                self.mNGViewControllerGrid[self.mNGTopViewController.0][self.mNGTopViewController.1]?.viewDidResignActive()
                self.mNGViewControllerGrid[x][y]?.viewDidBecomeActive()
                self.mNGTopViewController = (x, y)
                self.mNGCenterLabel?.text = self.mNGViewControllerGrid[self.mNGTopViewController.0][self.mNGTopViewController.1]!.requestTitle()
                UIView.animateWithDuration(0.15, animations: { () -> Void in
                    self.mNGCenterLabel?.alpha = 1.0
                })
        }
    }
    
    // MARK: Swipe Navigation
    var mNGSwipeView : UIView?
    
    func ngncEnableSwipeNavigation() {
        // Create the swipe view
        mNGSwipeView = UIView(frame: CGRectMake(0, ngncGetNavBarHeightWithStatusBar(), view.frame.width, view.frame.height - ngncGetNavBarHeightWithStatusBar()))
        mNGSwipeView?.backgroundColor = UIColor.clearColor()
        mNGSwipeView?.userInteractionEnabled = true
        
        let leftSwipeRec = UISwipeGestureRecognizer()
        leftSwipeRec.direction = .Left
        leftSwipeRec.addTarget(self, action: "ngncSwipedLeft")
        mNGSwipeView?.addGestureRecognizer(leftSwipeRec)
        
        let rightSwipeRec = UISwipeGestureRecognizer()
        rightSwipeRec.direction = .Right
        rightSwipeRec.addTarget(self, action: "ngncSwipedRight")
        mNGSwipeView?.addGestureRecognizer(rightSwipeRec)
        
        let upSwipeRec = UISwipeGestureRecognizer()
        upSwipeRec.direction = .Up
        upSwipeRec.addTarget(self, action: "ngncSwipedUp")
        mNGSwipeView?.addGestureRecognizer(upSwipeRec)
        
        let downSwipeRec = UISwipeGestureRecognizer()
        downSwipeRec.direction = .Down
        downSwipeRec.addTarget(self, action: "ngncSwipedDown")
        mNGSwipeView?.addGestureRecognizer(downSwipeRec)
        
        view.addSubview(mNGSwipeView!)
    }
    
    func ngncDisableSwipeNavigation() {
        mNGSwipeView?.removeFromSuperview()
        mNGSwipeView = nil
    }
    
    func ngncSwipedLeft() {
        do {
            try ngncCycleRight()
        } catch NGGridError.GridMoveAttemptPastBounds {
            // Do Nothing
        } catch {
            // Should never occur
            fatalError()
        }
    }
    
    func ngncSwipedRight() {
        do {
            try ngncCycleLeft()
        } catch NGGridError.GridMoveAttemptPastBounds {
            // Do Nothing
        } catch {
            // Should never occur
            fatalError()
        }
    }
    
    func ngncSwipedUp() {
        do {
            try ngncCycleDown()
        } catch NGGridError.GridMoveAttemptPastBounds {
            // Do Nothing
        } catch {
            // Should never occur
            fatalError()
        }
    }
    
    func ngncSwipedDown() {
        do {
            try ngncCycleUp()
        } catch NGGridError.GridMoveAttemptPastBounds {
            // Do Nothing
        } catch {
            // Should never occur
            fatalError()
        }
    }
}
