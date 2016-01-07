# Navigation Grid (NGNavController)
### Created by: Patrick Bradshaw (Github: @pbradshawusc)

> The Navigation Grid is a grid-style navigation controller for iOS written in Swift 2.0.
> The purpose of this element is for smooth and intuitive navigation through related view controllers in a synchronized grid pattern.

Installation
============

Manually
--------

Download the git repository and drag the NavGrid folder/group into you project in xcode.
Additionally, if you would like to use the icons from the test project, drag NGProfile and NGSearch from the images.xcassets folder in the downloaded project to your own images.xcassets folder.

Pods
----

Coming Soon (TM)

Usage
=====

Subclass NGNavigationController with your own custom class to use as the base controller for you class. Be sure to override `viewDidLoad()` **(calling super.viewDidLoad())** to add at least 1 initial view controller to the grid at index 0,0 (top left).
Note that adding view controllers will work at any time and in any location, but an error of type `NGGridError.ViewControllerAlreadyExists` is thrown if a view controller already exists in that grid location.

To access a controller at a specific location, you can use `ngncGetNGViewControllerForLocation(x,y)`, which will return the view controller at grid position x, y if one exists, or throw an error of type `NGGridError.ViewControllerDoesNotExist` if one does not.

Additionally, you must subclass NGViewController with your own custom class and override the following four methods **(not calling super.METHODNAME)**:
* `viewWillBecomeActive()`
* `viewDidBecomeActive()`
* `viewWillResignActive()`
* `viewDidResignActive()`

These four functions are used in place of view will/did appear/disappear. Since the view controllers are not being presented traditionally, these functions are used to communicate when each view controller will appear or disappear.

Optionally, override the following functions to determine the behavior of the navigation buttons on the left and right of the navigation bar:
* `ngncLeftButtonTouchDownInside()`
* `ngncLeftButtonTouchUpOutside()`
* `ngncLeftButtonTouchUpInside()`
* `ngncRightButtonTouchDownInside()`
* `ngncRightButtonTouchUpOutside()`
* `ngncRightButtonTouchUpInside()`

In addition, you can create custom titles for each view by setting the property **mNGTitle** in your NGViewController subclass.

### Navigation

To navigate between the various view controllers in the grid, there are multiple routes.
First, the following methods can be used anywhere to navigate in a certain direction:
* `cycleUp()`
* `cycleDown()`
* `cycleLeft()`
* `cycleRight()`
These methods will move in the direction indicated (moving up/down/left/right view controllers rather than drag direction). These methods all throw an error of type `NGGridError.GridMoveAttemptPastBounds` if an invalid move is attempted.

In addition, the method `ngncNavigateToLocation(x,y)` to navigate directly to the grid location x, y. This will not avoid gaps in the grid, however, and also will throw an error of type `NGGridError.GridMoveAttemptPastBounds` if no view controller exists at location x, y.

Scrolling through controllers by means of swiping is not enabled by default, but can be enabled by calling `ngncEnableSwipeNavigation()` and disabled (at a later point) by calling `ngncDisableSwipeNavigation()`.

Demo App
========

The included project has a sample application with 9 colored screens and a few snap navigations included. Feel free to build off of this project or look at the code for samples of usage.

Contact
=======

My (rarely used) [Twitter](https://twitter.com/PatrickBUSC)

License
=======

NavGrid is released under a GPL v3.0 license.
Copyright &copy; 2016-present Patrick Bradshaw
