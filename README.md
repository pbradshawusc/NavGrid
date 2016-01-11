# Navigation Grid (NGNavController)
### Created by: Patrick Bradshaw (Github: @pbradshawusc)

> The Navigation Grid is a grid-style navigation controller for iOS written in Swift 2.0.
> The purpose of this element is for smooth and intuitive navigation through related view controllers in an aligned or disaligned grid pattern.

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

> There are two ways to implement the NavGrid, via Composition and Inheritance. Both ways are outlined below, and both are included in order to allow you to use NavGrid in your accustomed style. Personally, I recommend the Inheritance model as it allows you to expand on the functionality directly and override functions if you wish to alter their effect rather than simply augment it. However, the composition method is much safer from accidentally breaking any base functionality of the NavGrid itself.

#### Composition
Simply instantiate a `NGNavigationController` within your active view controller and add the NGNavigationController's view to your view controller's view. You can then use your NavGrid as outlined below

#### Inheritance
Subclass `NGNavigationController` with your own custom class to use as the base controller for you class. Be sure to override `viewDidLoad()` **(calling super.viewDidLoad())** to add at least 1 initial view controller to the grid at index 0,0 (top left).
Note that adding view controllers will work at any time and in any location, but an error of type `NGGridError.ViewControllerAlreadyExists` is thrown if a view controller already exists in that grid location.

#### Usage Beyond Initialization
To access a controller at a specific location, you can use `ngncGetNGViewControllerForLocation(x,y)`, which will return the view controller at grid position x, y if one exists, or throw an error of type `NGGridError.ViewControllerDoesNotExist` if one does not. *Note that x refers to the x index of the view controller in the grid which is the position within a row. Y refers to the y index of the view controller in the grid which is the row that the view controller belongs to. In addition, these grid indices do not change with swiping (either aligned or disaligned) so it is possible for index (0,0) to be directly above (4,1) when the rows are disaligned.*

Additionally, you must subclass NGViewController with your own custom class and override the following four methods **(not calling super.METHODNAME)**:
* `viewWillBecomeActive()`
* `viewDidBecomeActive()`
* `viewWillResignActive()`
* `viewDidResignActive()`

These four functions are used in place of view will/did appear/disappear. Since the view controllers are not being presented traditionally, these functions are used to communicate when each view controller will appear or disappear.

The grid is set to default to an aligned grid pattern. If you would like to switch to a disaligned pattern (rows independent from each other), you may do so by calling `ngncSetRowsAligned(true, animated: Bool)`. This can be called at any time to alternate between aligned and disaligned rows (*Note that when switching to an aligned grid, the offset alignment of your view controllers will be lost, even when switching back to a disaligned pattern*). Disalignment for columns is a feature that will be coming in a future release soon! (Allowing for multiple side-by-side vertical scrolls).

Optionally, override the following functions to determine the behavior of the navigation buttons on the left and right of the navigation bar:
* `ngncLeftButtonTouchDownInside()`
* `ngncLeftButtonTouchUpOutside()`
* `ngncLeftButtonTouchUpInside()`
* `ngncRightButtonTouchDownInside()`
* `ngncRightButtonTouchUpOutside()`
* `ngncRightButtonTouchUpInside()`

Note that if you are using the Composition method, you will need to instead implement the `NGNavigationButtonDelegate` protocol in whatever class you wish to be the delegate for the button callbacks. You will also need to set the delegate for the NavGrid by calling `ngncSetDelegate(delegate: NGNavigationButtonDelegate)` This will have you implement the following functions which will behave exactly like the above 6 functions:
* `ngdLeftButtonTouchDownInside()`
* `ngdLeftButtonTouchUpOutside()`
* `ngdLeftButtonTouchUpInside()`
* `ngdRightButtonTouchDownInside()`
* `ngdRightButtonTouchUpOutside()`
* `ngdRightButtonTouchUpInside()`

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

The included project has a sample application with 9 colored screens and a snap navigation and align/disalign alternation included. The Search button will snap to the Search View Controller and the Profile icon will alternate between aligned and disaligned rows. Feel free to build off of this project or look at the code for samples of usage.

If you would like to try the Composition design style, the included NavGridSampleCompositionNavigationController contains an example of how to implement the NavGrid in this fashion.

Contact
=======

My (rarely used) [Twitter](https://twitter.com/PatrickBUSC)

If you have questions regarding the NavGrid or run into any issues, please create an issue and I'm happy to help as soon as I'm able! For any suggestions you have regarding the future development of the NavGrid, please leave those as a comment on the Suggestions issue. The NavGrid is built to be a comprehensive starting point for many iOS apps, and so I'm always looking to expand the functionality to fit what you as a designer or programmer need.

License
=======

NavGrid is released under a GPL v3.0 license.
Copyright &copy; 2016-present Patrick Bradshaw
