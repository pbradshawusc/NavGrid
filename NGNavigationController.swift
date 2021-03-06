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

protocol NGNavigationButtonDelegate {
    func ngdLeftButtonTouchDown()
    func ngdLeftButtonTouchUpOutside()
    func ngdLeftButtonTouchUpInside()
    func ngdRightButtonTouchDown()
    func ngdRightButtonTouchUpOutside()
    func ngdRightButtonTouchUpInside()
}

class NGNavigationController : UIViewController {
    // MARK: Initialization
    private var mNGInitialized = false
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        ngncInitializationImplementation()
    }
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        ngncInitializationImplementation()
    }
    
    private func ngncInitializationImplementation() {
        if !mNGInitialized {
            mNGInitialized = true
            
            
        }
    }
    
    override func viewDidLoad() {
        ngncResetNavigationHeaderToDefaults()
    }
    
    // MARK: Top Navigation Bar
    private let mNGNavBarHeight = CGFloat(44)
    private var mNGNavigationHeader : UIView?
    private var mNGStatusBarBackground : UIView?
    private var mNGLightStatusBar = true
    private var mNGLeftButton : UIButton?
    private var mNGRightButton : UIButton?
    private var mNGCenterLabel : UILabel?
    private var mNGButtonDelegate : NGNavigationButtonDelegate?
    
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
    
    func ngncSetNavigationHeaderStatusBarColor(color: UIColor, lightBackground: Bool = true) {
        mNGStatusBarBackground?.backgroundColor = color
        mNGLightStatusBar = !lightBackground
    }
    
    func ngncSetDelegate(delegate: NGNavigationButtonDelegate) {
        mNGButtonDelegate = delegate
        mNGLeftButton?.removeTarget(self, action: Selector(), forControlEvents: UIControlEvents.AllEvents)
        mNGLeftButton?.addTarget(self, action: "ngncPrivateLeftButtonTouchUpInside", forControlEvents: .TouchUpInside)
        mNGLeftButton?.addTarget(self, action: "ngncPrivateLeftButtonTouchUpOutside", forControlEvents: .TouchUpOutside)
        mNGLeftButton?.addTarget(self, action: "ngncPrivateLeftButtonTouchDown", forControlEvents: .TouchDown)
        mNGRightButton?.removeTarget(self, action: Selector(), forControlEvents: UIControlEvents.AllEvents)
        mNGRightButton?.addTarget(self, action: "ngncPrivateRightButtonTouchUpInside", forControlEvents: .TouchUpInside)
        mNGRightButton?.addTarget(self, action: "ngncPrivateRightButtonTouchUpOutside", forControlEvents: .TouchUpOutside)
        mNGRightButton?.addTarget(self, action: "ngncPrivateRightButtonTouchDown", forControlEvents: .TouchDown)
    }
    
    func ngncShowLeftButton(show: Bool, animated: Bool) {
        if show == mNGLeftButton!.hidden {
            if animated {
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.mNGLeftButton?.hidden = !show
                })
            } else {
                mNGLeftButton?.hidden = !show
            }
        }
    }
    
    func ngncEnableLeftButton(enable: Bool, animated: Bool) {
        if enable != mNGLeftButton!.enabled {
            if animated {
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.mNGLeftButton?.enabled = enable
                })
            } else {
                mNGLeftButton?.enabled = !enable
            }
        }
    }
    
    func ngncSetLeftButton(image: UIImage? = nil, title: String? = nil, state: UIControlState = .Normal, backgroundColor: UIColor? = nil, rounded: Bool = false) {
        if image != nil {
            mNGLeftButton?.frame = CGRectMake(5.0, ngncGetStatusBarHeight() + 4.0, mNGNavBarHeight - 8.0, mNGNavBarHeight - 8.0)
            mNGLeftButton?.setImage(image, forState: state)
        } else if title != nil {
            mNGLeftButton?.frame = CGRectMake(5.0, ngncGetStatusBarHeight() + 4.0, 2 * (mNGNavBarHeight - 8.0), mNGNavBarHeight - 8.0)
            if mNGLeftButton?.imageForState(state) != nil {
                mNGLeftButton?.setImage(nil, forState: state)
            }
            mNGLeftButton?.setTitle(title, forState: state)
        }
        
        if backgroundColor != nil {
            mNGLeftButton?.backgroundColor = backgroundColor!
        }
        
        if rounded {
            mNGLeftButton?.layer.masksToBounds = true
            mNGLeftButton?.layer.cornerRadius = min(mNGLeftButton!.frame.size.height, mNGLeftButton!.frame.size.width) / 4.0
        } else {
            mNGLeftButton?.layer.cornerRadius = 0
        }
    }
    
    func ngncGetLeftButton() -> UIButton? {
        // This is used for any advanced button customization beyond what is offered via the set function
        return mNGLeftButton
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
    
    @objc private func ngncPrivateLeftButtonTouchDown() {
        mNGButtonDelegate?.ngdLeftButtonTouchDown()
    }
    
    @objc private func ngncPrivateLeftButtonTouchUpOutside() {
        mNGButtonDelegate?.ngdLeftButtonTouchUpOutside()
    }
    
    @objc private func ngncPrivateLeftButtonTouchUpInside() {
        mNGButtonDelegate?.ngdLeftButtonTouchUpInside()
    }
    
    func ngncShowRightButton(show: Bool, animated: Bool) {
        if show == mNGRightButton!.hidden {
            if animated {
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.mNGRightButton?.hidden = !show
                })
            } else {
                mNGRightButton?.hidden = !show
            }
        }
    }
    
    func ngncEnableRightButton(enable: Bool, animated: Bool) {
        if enable != mNGRightButton!.enabled {
            if animated {
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.mNGRightButton?.enabled = enable
                })
            } else {
                mNGRightButton?.enabled = !enable
            }
        }
    }
    
    func ngncSetRightButton(image: UIImage? = nil, title: String? = nil, state: UIControlState = .Normal, backgroundColor: UIColor? = nil, rounded: Bool = false) {
        if image != nil {
            mNGRightButton?.frame = CGRectMake(view.frame.width - (mNGNavBarHeight - 8.0) - 5.0, ngncGetStatusBarHeight() + 4.0, (mNGNavBarHeight - 8.0), mNGNavBarHeight - 8.0)
            mNGRightButton?.setImage(image, forState: state)
        } else if title != nil {
            mNGRightButton?.frame = CGRectMake(view.frame.width - 2 * (mNGNavBarHeight - 8.0) - 5.0, ngncGetStatusBarHeight() + 4.0, 2 * (mNGNavBarHeight - 8.0), mNGNavBarHeight - 8.0)
            if mNGRightButton?.imageForState(state) != nil {
                mNGRightButton?.setImage(nil, forState: state)
            }
            mNGRightButton?.setTitle(title, forState: state)
        }
        
        if backgroundColor != nil {
            mNGRightButton?.backgroundColor = backgroundColor!
        }
        
        if rounded {
            mNGRightButton?.layer.masksToBounds = true
            mNGRightButton?.layer.cornerRadius = min(mNGRightButton!.frame.size.height, mNGRightButton!.frame.size.width) / 4.0
        } else {
            mNGRightButton?.layer.cornerRadius = 0
        }
    }
    
    func ngncGetRightButton() -> UIButton? {
        // This is used for any advanced button customization beyond what is offered via the set function
        return mNGRightButton
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
    
    @objc private func ngncPrivateRightButtonTouchDown() {
        mNGButtonDelegate?.ngdRightButtonTouchDown()
    }
    
    @objc private func ngncPrivateRightButtonTouchUpOutside() {
        mNGButtonDelegate?.ngdRightButtonTouchUpOutside()
    }
    
    @objc private func ngncPrivateRightButtonTouchUpInside() {
        mNGButtonDelegate?.ngdRightButtonTouchUpInside()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        if mNGLightStatusBar {
        return UIStatusBarStyle.LightContent
        } else {
            return UIStatusBarStyle.Default
        }
    }
    
    // MARK: Grid Setup
    private var mNGViewControllerGrid = Array<Array<NGViewController?>>()
    private var mNGTopViewController = (0, 0)
    private var mNGTopVCForRow = Array<Int>()
    private var mNGTopVCForColumn = Array<Int>()
    
    func ngncAppendNGViewControllerToLocation(x: Int, y: Int, vc: NGViewController) throws {
        // First check if a NGViewController already exists in this location, if so, throw an error
        if mNGViewControllerGrid.count > y {
            if mNGViewControllerGrid[y].count > x {
                if mNGViewControllerGrid[y][x] != nil {
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
        while mNGViewControllerGrid.count - 1 < y {
            mNGViewControllerGrid.append(Array<NGViewController?>())
            if !mNGRowsDisaligned {
                mNGTopVCForRow.append(mNGTopViewController.1)
            } else {
                mNGTopVCForRow.append(0)
            }
        }
        while mNGViewControllerGrid[y].count - 1 < x {
            mNGViewControllerGrid[y].append(nil)
            if mNGTopVCForColumn.count - 1 < x {
                mNGTopVCForColumn.append(0)
            }
        }
        
        // Assign the View Controller and return it
        mNGViewControllerGrid[y][x] = vc
        addChildViewController(vc)
        view.addSubview(vc.view)
        view.bringSubviewToFront(mNGNavigationHeader!)
        if mNGSwipeView != nil {
            view.bringSubviewToFront(mNGSwipeView!)
        }
    }
    
    func ngncGetNGViewControllerForLocation(x: Int, y: Int) throws -> NGViewController {
        if mNGViewControllerGrid.count - 1 < y {
            throw NGGridError.ViewControllerDoesNotExist
        } else if mNGViewControllerGrid[y].count - 1 < x {
            throw NGGridError.ViewControllerDoesNotExist
        } else if mNGViewControllerGrid[y][x] == nil {
            throw NGGridError.ViewControllerDoesNotExist
        } else {
            return mNGViewControllerGrid[y][x]!
        }
    }
    
    func ngncGetTopViewController() throws -> NGViewController {
        return try ngncGetNGViewControllerForLocation(mNGTopViewController.0, y: mNGTopViewController.1)
    }
    
    // MARK: Grid Navigation
    private var mNGRowsDisaligned = false
    var rowsAligned : Bool {
        get {
            return !mNGRowsDisaligned
        }
        set(alignment) {
            ngncSetRowsAligned(alignment, animated: false)
        }
    }
    private var mNGColumnsDisaligned = false
    var columnsAligned : Bool {
        get {
            return !mNGColumnsDisaligned
        }
        set(alignment) {
            ngncSetColumnsAligned(alignment, animated: false)
        }
    }
    
    func ngncSetRowsAligned(aligned: Bool, animated: Bool) {
        if !mNGRowsDisaligned == aligned {
            return
        } else if !mNGColumnsDisaligned && !aligned {
            ngncSetColumnsAligned(true, animated: false)
        }
        
        mNGRowsDisaligned = !aligned
        if !mNGRowsDisaligned {
            // Set the locations of all view controllers in the grid relative to the current top view controller
            if animated {
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    for i in 0...self.mNGViewControllerGrid.count - 1 {
                        for j in 0...self.mNGViewControllerGrid[i].count - 1 {
                            if self.mNGViewControllerGrid[i][j] != nil && !(i == self.mNGTopViewController.1 && j == self.mNGTopViewController.0) {
                                // This is a valid view controller, set its new location
                                let xDist = CGFloat(j - self.mNGTopViewController.0)
                                // Negative xDist corresponds to a controller to the right of the top controller
                                self.mNGViewControllerGrid[i][j]!.view.frame.origin.x = (xDist * self.view.frame.width)
                            }
                        }
                    }
                    }, completion: { (completed) -> Void in
                        for i in 0...self.mNGTopVCForRow.count - 1 {
                            self.mNGTopVCForRow[i] = self.mNGTopViewController.0
                        }
                        
                        for i in 0...self.mNGTopVCForColumn.count - 1 {
                            self.mNGTopVCForColumn[i] = self.mNGTopViewController.1
                        }
                })
            } else {
                for i in 0...mNGViewControllerGrid.count - 1 {
                    for j in 0...mNGViewControllerGrid[i].count - 1 {
                        if mNGViewControllerGrid[i][j] != nil && !(i == mNGTopViewController.1 && j == mNGTopViewController.0) {
                            // This is a valid view controller, set its new location
                            let xDist = CGFloat(j - self.mNGTopViewController.0)
                            // Negative xDist corresponds to a controller to the right of the top controller
                            self.mNGViewControllerGrid[i][j]!.view.frame.origin.x = (xDist * self.view.frame.width)
                        }
                    }
                }
                
                // Now reset the top view controller for each row to the current top view controller's column
                for i in 0...mNGTopVCForRow.count - 1 {
                    mNGTopVCForRow[i] = mNGTopViewController.0
                }
                
                // Now reset the top view controller for each column to the current top view controller's row
                for i in 0...mNGTopVCForColumn.count - 1 {
                    mNGTopVCForColumn[i] = mNGTopViewController.1
                }
            }
        }
    }
    
    func ngncSetColumnsAligned(aligned: Bool, animated: Bool) {
        if !mNGColumnsDisaligned == aligned {
            return
        } else if mNGRowsDisaligned && !aligned {
            ngncSetRowsAligned(true, animated: false)
        }
        
        mNGColumnsDisaligned = !aligned
        if !mNGColumnsDisaligned {
            // Set the locations of all view controllers in the grid relative to the current top view controller
            if animated {
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    for i in 0...self.mNGViewControllerGrid.count - 1 {
                        for j in 0...self.mNGViewControllerGrid[i].count - 1 {
                            if self.mNGViewControllerGrid[i][j] != nil && !(i == self.mNGTopViewController.1 && j == self.mNGTopViewController.0) {
                                // This is a valid view controller, set its new location
                                let yDist = CGFloat(i - self.mNGTopViewController.1)
                                // Negative xDist corresponds to a controller to the right of the top controller
                                self.mNGViewControllerGrid[i][j]!.view.frame.origin.y = self.ngncGetNavBarHeightWithStatusBar() + (yDist * (self.view.frame.height - self.ngncGetNavBarHeightWithStatusBar()))
                            }
                        }
                    }
                    }, completion: { (completed) -> Void in
                        for i in 0...self.mNGTopVCForRow.count - 1 {
                            self.mNGTopVCForRow[i] = self.mNGTopViewController.0
                        }
                        
                        for i in 0...self.mNGTopVCForColumn.count - 1 {
                            self.mNGTopVCForColumn[i] = self.mNGTopViewController.1
                        }
                })
            } else {
                for i in 0...mNGViewControllerGrid.count - 1 {
                    for j in 0...mNGViewControllerGrid[i].count - 1 {
                        if mNGViewControllerGrid[i][j] != nil && !(i == mNGTopViewController.1 && j == mNGTopViewController.0) {
                            // This is a valid view controller, set its new location
                            let xDist = CGFloat(j - self.mNGTopViewController.0)
                            // Negative xDist corresponds to a controller to the right of the top controller
                            self.mNGViewControllerGrid[i][j]!.view.frame.origin.x = (xDist * self.view.frame.width)
                        }
                    }
                }
                
                // Now reset the top view controller for each row to the current top view controller's column
                for i in 0...mNGTopVCForRow.count - 1 {
                    mNGTopVCForRow[i] = mNGTopViewController.0
                }
                
                // Now reset the top view controller for each column to the current top view controller's row
                for i in 0...mNGTopVCForColumn.count - 1 {
                    mNGTopVCForColumn[i] = mNGTopViewController.1
                }
            }
        }
    }
    
    func ngncCycleLeft() throws {
        if mNGTopViewController.0 == 0 {
            // Attempt to move left when already at absolute left edge
            throw NGGridError.GridMoveAttemptPastBounds
        } else if mNGViewControllerGrid[mNGTopViewController.1][mNGTopViewController.0 - 1] == nil {
            // Attempt to move left when already at local left edge
            throw NGGridError.GridMoveAttemptPastBounds
        }
        
        // Notify the view controllers that will appear and disappear
        mNGViewControllerGrid[mNGTopViewController.1][mNGTopViewController.0]?.viewWillResignActive()
        if mNGColumnsDisaligned {
            mNGViewControllerGrid[mNGTopVCForColumn[mNGTopViewController.0 - 1]][mNGTopViewController.0 - 1]?.viewWillBecomeActive()
        } else {
            mNGViewControllerGrid[mNGTopViewController.1][mNGTopViewController.0 - 1]?.viewWillBecomeActive()
        }
        
        // Cycle over all view controllers and shift them to the left by subframe width
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            if self.mNGRowsDisaligned {
                for i in 0...self.mNGViewControllerGrid[self.mNGTopViewController.1].count - 1 {
                    if self.mNGViewControllerGrid[self.mNGTopViewController.1][i] != nil {
                        self.mNGViewControllerGrid[self.mNGTopViewController.1][i]!.view.frame.origin.x += self.view.frame.width
                    }
                }
            } else {
                for i in 0...self.mNGViewControllerGrid.count - 1 {
                    if self.mNGViewControllerGrid[i].count > 0 {
                        for j in 0...self.mNGViewControllerGrid[i].count - 1 {
                            if self.mNGViewControllerGrid[i].count > j && self.mNGViewControllerGrid[i][j] != nil {
                                self.mNGViewControllerGrid[i][j]!.view.frame.origin.x += self.view.frame.width
                            }
                        }
                    }
                }
            }
            self.mNGCenterLabel?.alpha = 0.0
            }) { (completed) -> Void in
                // Notify the view controllers that they did appear and disappear
                self.mNGViewControllerGrid[self.mNGTopViewController.1][self.mNGTopViewController.0]?.viewDidResignActive()
                if self.mNGColumnsDisaligned {
                    self.mNGViewControllerGrid[self.mNGTopVCForColumn[self.mNGTopViewController.0 - 1]][self.mNGTopViewController.0 - 1]?.viewDidBecomeActive()
                    self.mNGTopViewController.1 = self.mNGTopVCForColumn[self.mNGTopViewController.0 - 1]
                } else {
                    self.mNGViewControllerGrid[self.mNGTopViewController.1][self.mNGTopViewController.0 - 1]?.viewDidBecomeActive()
                }
                self.mNGTopViewController.0 -= 1
                self.mNGCenterLabel?.text = self.mNGViewControllerGrid[self.mNGTopViewController.1][self.mNGTopViewController.0]!.requestTitle()
                self.mNGTopVCForRow[self.mNGTopViewController.1] = self.mNGTopViewController.0
                self.mNGTopVCForColumn[self.mNGTopViewController.0] = self.mNGTopViewController.1
                if !self.mNGRowsDisaligned && !self.mNGColumnsDisaligned {
                    for i in 0...self.mNGViewControllerGrid.count-1 {
                        self.mNGTopVCForRow[i] = self.mNGTopViewController.0
                    }
                }
                UIView.animateWithDuration(0.15, animations: { () -> Void in
                    self.mNGCenterLabel?.alpha = 1.0
                })
        }
    }
    
    func ngncCycleRight() throws {
        if mNGTopViewController.0 == mNGViewControllerGrid[mNGTopViewController.1].count - 1 {
            // Attempt to move right when already at absolute right edge
            throw NGGridError.GridMoveAttemptPastBounds
        } else if mNGViewControllerGrid[mNGTopViewController.1][mNGTopViewController.0 + 1] == nil {
            // Attempt to move right when already at local right edge
            throw NGGridError.GridMoveAttemptPastBounds
        }
        
        // Notify the view controllers that will appear and disappear
        mNGViewControllerGrid[mNGTopViewController.1][mNGTopViewController.0]?.viewWillResignActive()
        if mNGColumnsDisaligned {
            mNGViewControllerGrid[mNGTopVCForColumn[mNGTopViewController.0 + 1]][mNGTopViewController.0 + 1]?.viewWillBecomeActive()
        } else {
            mNGViewControllerGrid[mNGTopViewController.1][mNGTopViewController.0 + 1]?.viewWillBecomeActive()
        }
        
        // Cycle over all view controllers and shift them to the right by subframe width
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            if self.mNGRowsDisaligned {
                for i in 0...self.mNGViewControllerGrid[self.mNGTopViewController.1].count - 1 {
                    if self.mNGViewControllerGrid[self.mNGTopViewController.1][i] != nil {
                        self.mNGViewControllerGrid[self.mNGTopViewController.1][i]!.view.frame.origin.x -= self.view.frame.width
                    }
                }
            } else {
                for i in 0...self.mNGViewControllerGrid.count - 1 {
                    if self.mNGViewControllerGrid[i].count > 0 {
                        for j in 0...self.mNGViewControllerGrid[i].count - 1 {
                            if self.mNGViewControllerGrid[i].count > j && self.mNGViewControllerGrid[i][j] != nil {
                                self.mNGViewControllerGrid[i][j]!.view.frame.origin.x -= self.view.frame.width
                            }
                        }
                    }
                }
            }
            self.mNGCenterLabel?.alpha = 0.0
            }) { (completed) -> Void in
                // Notify the view controllers that they did appear and disappear
                self.mNGViewControllerGrid[self.mNGTopViewController.1][self.mNGTopViewController.0]?.viewDidResignActive()
                if self.mNGColumnsDisaligned {
                    self.mNGViewControllerGrid[self.mNGTopVCForColumn[self.mNGTopViewController.0 + 1]][self.mNGTopViewController.0 + 1]?.viewDidBecomeActive()
                    self.mNGTopViewController.1 = self.mNGTopVCForColumn[self.mNGTopViewController.0 + 1]
                } else {
                    self.mNGViewControllerGrid[self.mNGTopViewController.1][self.mNGTopViewController.0 + 1]?.viewDidBecomeActive()
                }
                self.mNGTopViewController.0 += 1
                self.mNGCenterLabel?.text = self.mNGViewControllerGrid[self.mNGTopViewController.1][self.mNGTopViewController.0]!.requestTitle()
                self.mNGTopVCForRow[self.mNGTopViewController.1] = self.mNGTopViewController.0
                self.mNGTopVCForColumn[self.mNGTopViewController.0] = self.mNGTopViewController.1
                if !self.mNGRowsDisaligned && !self.mNGColumnsDisaligned {
                    for i in 0...self.mNGViewControllerGrid.count-1 {
                        self.mNGTopVCForRow[i] = self.mNGTopViewController.0
                    }
                }
                UIView.animateWithDuration(0.15, animations: { () -> Void in
                    self.mNGCenterLabel?.alpha = 1.0
                })
        }
    }
    
    func ngncCycleUp() throws {
        if mNGTopViewController.1 == 0 {
            // Attempt to move up when already at absolute top edge
            throw NGGridError.GridMoveAttemptPastBounds
        } else if (mNGViewControllerGrid[mNGTopViewController.1 - 1].count - 1 >= mNGTopViewController.0) && (mNGViewControllerGrid[mNGTopViewController.1 - 1][mNGTopViewController.0] == nil) {
            // Attempt to move up when already at local top edge
            throw NGGridError.GridMoveAttemptPastBounds
        } else if mNGViewControllerGrid[mNGTopViewController.1 - 1].count < mNGTopViewController.0 {
            // Attempt to move up when already at local top edge
            throw NGGridError.GridMoveAttemptPastBounds
        }
        
        // Notify the view controllers that will appear and disappear
        mNGViewControllerGrid[mNGTopViewController.1][mNGTopViewController.0]?.viewWillResignActive()
        if mNGRowsDisaligned {
            mNGViewControllerGrid[mNGTopViewController.1 - 1][mNGTopVCForRow[mNGTopViewController.1 - 1]]?.viewWillBecomeActive()
            /*
             * This section is commented out, but if uncommented should allow for automatic movement to a valid view above the current row, which currently is nullified byt the checks for nil at the beginning of the function
            if mNGViewControllerGrid[mNGTopViewController.1 - 1][mNGTopVCForRow[mNGTopViewController.1 - 1]]!.view.frame.origin.x != 0 {
                let xDist = -mNGViewControllerGrid[mNGTopViewController.1 - 1][mNGTopVCForRow[mNGTopViewController.1 - 1]]!.view.frame.origin.x
                for i in 0...mNGViewControllerGrid[mNGTopViewController.1 - 1].count - 1 {
                    if mNGViewControllerGrid[mNGTopViewController.1 - 1][i] != nil {
                        mNGViewControllerGrid[mNGTopViewController.1 - 1][i]!.view.frame.origin.x -= xDist
                    }
                }
            }
             */
        } else {
            mNGViewControllerGrid[mNGTopViewController.1 - 1][mNGTopViewController.0]?.viewWillBecomeActive()
        }
        
        // Cycle over all view controllers and shift them down by subframe height
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            if self.mNGColumnsDisaligned {
                for i in 0...self.mNGViewControllerGrid.count - 1 {
                    if self.mNGViewControllerGrid[i].count - 1 >= self.mNGTopViewController.0 {
                        self.mNGViewControllerGrid[i][self.mNGTopViewController.0]!.view.frame.origin.y += self.view.frame.height - self.ngncGetNavBarHeightWithStatusBar()
                    }
                }
            } else {
                for i in 0...self.mNGViewControllerGrid.count - 1 {
                    if self.mNGViewControllerGrid[i].count > 0 {
                        for j in 0...self.mNGViewControllerGrid[i].count - 1 {
                            if self.mNGViewControllerGrid[i].count > j && self.mNGViewControllerGrid[i][j] != nil {
                                self.mNGViewControllerGrid[i][j]!.view.frame.origin.y += (self.view.frame.height - self.ngncGetNavBarHeightWithStatusBar())
                            }
                        }
                    }
                }
            }
            self.mNGCenterLabel?.alpha = 0.0
            }) { (completed) -> Void in
                // Notify the view controllers that they did appear and disappear
                self.mNGViewControllerGrid[self.mNGTopViewController.1][self.mNGTopViewController.0]?.viewDidResignActive()
                if self.mNGRowsDisaligned {
                    self.mNGViewControllerGrid[self.mNGTopViewController.1 - 1][self.mNGTopVCForRow[self.mNGTopViewController.1 - 1]]?.viewDidBecomeActive()
                    self.mNGTopViewController.0 = self.mNGTopVCForRow[self.mNGTopViewController.1 - 1]
                } else {
                    self.mNGViewControllerGrid[self.mNGTopViewController.1 - 1][self.mNGTopViewController.0]?.viewDidBecomeActive()
                }
                self.mNGTopViewController.1 -= 1
                self.mNGCenterLabel?.text = self.mNGViewControllerGrid[self.mNGTopViewController.1][self.mNGTopViewController.0]!.requestTitle()
                self.mNGTopVCForColumn[self.mNGTopViewController.0] = self.mNGTopViewController.1
                UIView.animateWithDuration(0.15, animations: { () -> Void in
                    self.mNGCenterLabel?.alpha = 1.0
                })
        }
    }
    
    func ngncCycleDown() throws {
        if mNGTopViewController.1 == mNGViewControllerGrid.count - 1 {
            // Attempt to move down when already at absolute bottom edge
            throw NGGridError.GridMoveAttemptPastBounds
        } else if (mNGViewControllerGrid[mNGTopViewController.1 + 1].count - 1 >= mNGTopViewController.0) && (mNGViewControllerGrid[mNGTopViewController.1 + 1][mNGTopViewController.0] == nil) {
            // Attempt to move down when already at local bottom edge
            throw NGGridError.GridMoveAttemptPastBounds
        } else if mNGViewControllerGrid[mNGTopViewController.1 + 1].count - 1 < mNGTopViewController.0 {
            // Attempt to move down when already at local bottom edge
            throw NGGridError.GridMoveAttemptPastBounds
        }
        
        // Notify the view controllers that will appear and disappear
        mNGViewControllerGrid[mNGTopViewController.1][mNGTopViewController.0]?.viewWillResignActive()
        if mNGRowsDisaligned {
            mNGViewControllerGrid[mNGTopViewController.1 + 1][mNGTopVCForRow[mNGTopViewController.1 + 1]]?.viewWillBecomeActive()
            /*
             * This section is commented out, but if uncommented should allow for automatic movement to a valid view below the current row, which currently is nullified byt the checks for nil at the beginning of the function
            if mNGViewControllerGrid[mNGTopViewController.1 + 1][mNGTopVCForRow[mNGTopViewController.1 + 1]]!.view.frame.origin.x != 0 {
                let xDist = -mNGViewControllerGrid[mNGTopViewController.1 + 1][mNGTopVCForRow[mNGTopViewController.1 + 1]]!.view.frame.origin.x
                for i in 0...mNGViewControllerGrid[mNGTopViewController.1 + 1].count - 1 {
                    if mNGViewControllerGrid[mNGTopViewController.1 + 1][i] != nil {
                        mNGViewControllerGrid[mNGTopViewController.1 + 1][i]!.view.frame.origin.x -= xDist
                    }
                }
            }
             */
        } else {
            mNGViewControllerGrid[mNGTopViewController.1 + 1][mNGTopViewController.0]?.viewWillBecomeActive()
        }
        
        // Cycle over all view controllers and shift them up by subframe height
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            if self.mNGColumnsDisaligned {
                for i in 0...self.mNGViewControllerGrid.count - 1 {
                    if self.mNGViewControllerGrid[i].count - 1 >= self.mNGTopViewController.0 {
                        self.mNGViewControllerGrid[i][self.mNGTopViewController.0]!.view.frame.origin.y -= self.view.frame.height - self.ngncGetNavBarHeightWithStatusBar()
                    }
                }
            } else {
                for i in 0...self.mNGViewControllerGrid.count - 1 {
                    if self.mNGViewControllerGrid[i].count > 0 {
                        for j in 0...self.mNGViewControllerGrid[i].count - 1 {
                            if self.mNGViewControllerGrid[i].count > j && self.mNGViewControllerGrid[i][j] != nil {
                                self.mNGViewControllerGrid[i][j]!.view.frame.origin.y -= (self.view.frame.height - self.ngncGetNavBarHeightWithStatusBar())
                            }
                        }
                    }
                }
            }
            self.mNGCenterLabel?.alpha = 0.0
            }) { (completed) -> Void in
                // Notify the view controllers that they did appear and disappear
                self.mNGViewControllerGrid[self.mNGTopViewController.1][self.mNGTopViewController.0]?.viewDidResignActive()
                if self.mNGRowsDisaligned {
                    self.mNGViewControllerGrid[self.mNGTopViewController.1 + 1][self.mNGTopVCForRow[self.mNGTopViewController.1 + 1]]?.viewDidBecomeActive()
                    self.mNGTopViewController.0 = self.mNGTopVCForRow[self.mNGTopViewController.1 + 1]
                } else {
                    self.mNGViewControllerGrid[self.mNGTopViewController.1 + 1][self.mNGTopViewController.0]?.viewDidBecomeActive()
                }
                self.mNGTopViewController.1 += 1
                self.mNGCenterLabel?.text = self.mNGViewControllerGrid[self.mNGTopViewController.1][self.mNGTopViewController.0]!.requestTitle()
                self.mNGTopVCForColumn[self.mNGTopViewController.0] = self.mNGTopViewController.1
                UIView.animateWithDuration(0.15, animations: { () -> Void in
                    self.mNGCenterLabel?.alpha = 1.0
                })
        }
    }
    
    func ngncNavigateToLocation(x: Int, y: Int) throws {
        if mNGViewControllerGrid.count - 1 < y {
            throw NGGridError.GridMoveAttemptPastBounds
        } else if mNGViewControllerGrid[y].count - 1 < x {
            throw NGGridError.GridMoveAttemptPastBounds
        } else if mNGViewControllerGrid[y][x] == nil {
            throw NGGridError.ViewControllerDoesNotExist
        } else if x == mNGTopViewController.0 && y == mNGTopViewController.1 {
            // We are already at this location
            return
        }
        
        // Notify the view controllers that will appear and disappear
        mNGViewControllerGrid[mNGTopViewController.1][mNGTopViewController.0]?.viewWillResignActive()
        mNGViewControllerGrid[y][x]?.viewWillBecomeActive()
        
        if mNGRowsDisaligned {
            // First navigate to the proper row
            let yDist = mNGViewControllerGrid[y][x]!.view.frame.origin.y - ngncGetNavBarHeightWithStatusBar()
            let xDist = self.mNGViewControllerGrid[y][x]!.view.frame.origin.x
            if yDist != 0 && xDist != 0 {
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    for i in 0...self.mNGViewControllerGrid.count - 1 {
                        if self.mNGViewControllerGrid[i].count > 0 {
                            for j in 0...self.mNGViewControllerGrid[i].count - 1 {
                                if self.mNGViewControllerGrid[i].count > j && self.mNGViewControllerGrid[i][j] != nil {
                                    self.mNGViewControllerGrid[i][j]!.view.frame.origin.y -= yDist
                                }
                            }
                        }
                    }
                    self.mNGCenterLabel?.alpha = 0.0
                    }, completion: { (verticalMoveCompleted) -> Void in
                        // Next navigate to the proper column
                        UIView.animateWithDuration(0.15, animations: { () -> Void in
                            for i in 0...self.mNGViewControllerGrid[y].count - 1 {
                                if self.mNGViewControllerGrid[y][i] != nil {
                                    self.mNGViewControllerGrid[y][i]!.view.frame.origin.x -= xDist
                                }
                            }
                            }, completion: { (horizontalMoveCompleted) -> Void in
                                self.mNGViewControllerGrid[self.mNGTopViewController.1][self.mNGTopViewController.0]?.viewDidResignActive()
                                self.mNGViewControllerGrid[y][x]?.viewDidBecomeActive()
                                self.mNGTopViewController = (x, y)
                                self.mNGTopVCForRow[y] = x
                                self.mNGCenterLabel?.text = self.mNGViewControllerGrid[self.mNGTopViewController.1][self.mNGTopViewController.0]!.requestTitle()
                                UIView.animateWithDuration(0.15, animations: { () -> Void in
                                    self.mNGCenterLabel?.alpha = 1.0
                                })
                        })
                })
            } else if yDist != 0 && xDist == 0 {
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    for i in 0...self.mNGViewControllerGrid.count - 1 {
                        if self.mNGViewControllerGrid[i].count > 0 {
                            for j in 0...self.mNGViewControllerGrid[i].count - 1 {
                                if self.mNGViewControllerGrid[i].count > j && self.mNGViewControllerGrid[i][j] != nil {
                                    self.mNGViewControllerGrid[i][j]!.view.frame.origin.y -= yDist
                                }
                            }
                        }
                    }
                    self.mNGCenterLabel?.alpha = 0.0
                    }, completion: { (verticalMoveCompleted) -> Void in
                        // Here we are already at the proper column
                        self.mNGViewControllerGrid[self.mNGTopViewController.1][self.mNGTopViewController.0]?.viewDidResignActive()
                        self.mNGViewControllerGrid[y][x]?.viewDidBecomeActive()
                        self.mNGTopViewController = (x, y)
                        self.mNGTopVCForRow[y] = x
                        self.mNGCenterLabel?.text = self.mNGViewControllerGrid[self.mNGTopViewController.1][self.mNGTopViewController.0]!.requestTitle()
                        UIView.animateWithDuration(0.15, animations: { () -> Void in
                            self.mNGCenterLabel?.alpha = 1.0
                        })
                })
            }else if yDist == 0 {
                // We are already at the proper row, so simply navigate to the proper column
                UIView.animateWithDuration(0.15, animations: { () -> Void in
                    for i in 0...self.mNGViewControllerGrid[y].count - 1 {
                        if self.mNGViewControllerGrid[y][i] != nil {
                            self.mNGViewControllerGrid[y][i]!.view.frame.origin.x -= xDist
                        }
                    }
                    }, completion: { (horizontalMoveCompleted) -> Void in
                        self.mNGViewControllerGrid[self.mNGTopViewController.1][self.mNGTopViewController.0]?.viewDidResignActive()
                        self.mNGViewControllerGrid[y][x]?.viewDidBecomeActive()
                        self.mNGTopViewController = (x, y)
                        self.mNGTopVCForRow[y] = x
                        self.mNGCenterLabel?.text = self.mNGViewControllerGrid[self.mNGTopViewController.1][self.mNGTopViewController.0]!.requestTitle()
                        UIView.animateWithDuration(0.15, animations: { () -> Void in
                            self.mNGCenterLabel?.alpha = 1.0
                        })
                })
            }
        } else if mNGColumnsDisaligned {
            // TODO
            let yDist = mNGViewControllerGrid[y][x]!.view.frame.origin.y - ngncGetNavBarHeightWithStatusBar()
            let xDist = self.mNGViewControllerGrid[y][x]!.view.frame.origin.x - self.mNGViewControllerGrid[y][self.mNGTopViewController.0]!.view.frame.origin.x
            if yDist != 0 && xDist != 0 {
                // First navigate to the proper column, then the proper row
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    for i in 0...self.mNGViewControllerGrid.count - 1 {
                        if self.mNGViewControllerGrid[i].count > 0 {
                            for j in 0...self.mNGViewControllerGrid[i].count - 1 {
                                if self.mNGViewControllerGrid[i].count > j && self.mNGViewControllerGrid[i][j] != nil {
                                    self.mNGViewControllerGrid[i][j]!.view.frame.origin.x -= xDist
                                }
                            }
                        }
                    }
                    self.mNGCenterLabel?.alpha = 0.0
                    }, completion: { (verticalMoveCompleted) -> Void in
                        // Next navigate to the proper row
                        UIView.animateWithDuration(0.15, animations: { () -> Void in
                            for i in 0...self.mNGViewControllerGrid.count - 1 {
                                if self.mNGViewControllerGrid[i].count - 1 >= x {
                                    self.mNGViewControllerGrid[i][x]!.view.frame.origin.y -= yDist
                                }
                            }
                            }, completion: { (horizontalMoveCompleted) -> Void in
                                self.mNGViewControllerGrid[self.mNGTopViewController.1][self.mNGTopViewController.0]?.viewDidResignActive()
                                self.mNGViewControllerGrid[y][x]?.viewDidBecomeActive()
                                self.mNGTopViewController = (x, y)
                                self.mNGTopVCForRow[y] = x
                                self.mNGTopVCForColumn[x] = y
                                self.mNGCenterLabel?.text = self.mNGViewControllerGrid[self.mNGTopViewController.1][self.mNGTopViewController.0]!.requestTitle()
                                UIView.animateWithDuration(0.15, animations: { () -> Void in
                                    self.mNGCenterLabel?.alpha = 1.0
                                })
                        })
                })
            } else if xDist != 0 {
                // All we need to do is change columns, we are in the proper row already
                // First navigate to the proper column, then the proper row
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    for i in 0...self.mNGViewControllerGrid.count - 1 {
                        if self.mNGViewControllerGrid[i].count > 0 {
                            for j in 0...self.mNGViewControllerGrid[i].count - 1 {
                                if self.mNGViewControllerGrid[i].count > j && self.mNGViewControllerGrid[i][j] != nil {
                                    self.mNGViewControllerGrid[i][j]!.view.frame.origin.x -= xDist
                                }
                            }
                        }
                    }
                    self.mNGCenterLabel?.alpha = 0.0
                    }, completion: { (verticalMoveCompleted) -> Void in
                        self.mNGViewControllerGrid[self.mNGTopViewController.1][self.mNGTopViewController.0]?.viewDidResignActive()
                        self.mNGViewControllerGrid[y][x]?.viewDidBecomeActive()
                        self.mNGTopViewController = (x, y)
                        self.mNGTopVCForRow[y] = x
                        self.mNGTopVCForColumn[x] = y
                        self.mNGCenterLabel?.text = self.mNGViewControllerGrid[self.mNGTopViewController.1][self.mNGTopViewController.0]!.requestTitle()
                        UIView.animateWithDuration(0.15, animations: { () -> Void in
                            self.mNGCenterLabel?.alpha = 1.0
                        })
                })
            } else if yDist != 0 {
                // All we need to do is change rows, we are in the proper column already
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    for i in 0...self.mNGViewControllerGrid.count - 1 {
                        if self.mNGViewControllerGrid[i].count - 1 >= x {
                            self.mNGViewControllerGrid[i][x]!.view.frame.origin.y -= yDist
                        }
                    }
                    }, completion: { (horizontalMoveCompleted) -> Void in
                        self.mNGViewControllerGrid[self.mNGTopViewController.1][self.mNGTopViewController.0]?.viewDidResignActive()
                        self.mNGViewControllerGrid[y][x]?.viewDidBecomeActive()
                        self.mNGTopViewController = (x, y)
                        self.mNGTopVCForRow[y] = x
                        self.mNGTopVCForColumn[x] = y
                        self.mNGCenterLabel?.text = self.mNGViewControllerGrid[self.mNGTopViewController.1][self.mNGTopViewController.0]!.requestTitle()
                        UIView.animateWithDuration(0.15, animations: { () -> Void in
                            self.mNGCenterLabel?.alpha = 1.0
                        })
                })
            }
        } else {
            // Cycle over all view controllers and shift them by subframe height and width accordingly
            let xDist = mNGViewControllerGrid[y][x]!.view.frame.origin.x
            let yDist = mNGViewControllerGrid[y][x]!.view.frame.origin.y - ngncGetNavBarHeightWithStatusBar()
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
                    self.mNGViewControllerGrid[self.mNGTopViewController.1][self.mNGTopViewController.0]?.viewDidResignActive()
                    self.mNGViewControllerGrid[y][x]?.viewDidBecomeActive()
                    self.mNGTopViewController = (x, y)
                    self.mNGTopVCForRow[y] = x
                    self.mNGCenterLabel?.text = self.mNGViewControllerGrid[self.mNGTopViewController.1][self.mNGTopViewController.0]!.requestTitle()
                    for i in 0...self.mNGTopVCForRow.count - 1 {
                        self.mNGTopVCForRow[i] = self.mNGTopViewController.0
                    }
                    UIView.animateWithDuration(0.15, animations: { () -> Void in
                        self.mNGCenterLabel?.alpha = 1.0
                    })
            }
        }
    }
    
    // MARK: Swipe Navigation
    private var mNGSwipeView : UIView?
    
    func ngncEnableSwipeNavigation() {
        if mNGSwipeView == nil {
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
    }
    
    func ngncDisableSwipeNavigation() {
        mNGSwipeView?.removeFromSuperview()
        mNGSwipeView = nil
    }
    
    @objc private func ngncSwipedLeft() {
        do {
            try ngncCycleRight()
        } catch NGGridError.GridMoveAttemptPastBounds {
            // Do Nothing
        } catch {
            // Should never occur
            fatalError()
        }
    }
    
    @objc private func ngncSwipedRight() {
        do {
            try ngncCycleLeft()
        } catch NGGridError.GridMoveAttemptPastBounds {
            // Do Nothing
        } catch {
            // Should never occur
            fatalError()
        }
    }
    
    @objc private func ngncSwipedUp() {
        do {
            try ngncCycleDown()
        } catch NGGridError.GridMoveAttemptPastBounds {
            // Do Nothing
        } catch {
            // Should never occur
            fatalError()
        }
    }
    
    @objc private func ngncSwipedDown() {
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
