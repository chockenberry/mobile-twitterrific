//
//  IFUIKitAdditions.h
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 8/28/07.
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//

/*
NOTE: Yeah, these should be in the class definition (framework header.) Hopefully at
some point in the near future, we'll see these cause some duplicate definitions.

If you see build errors about duplicate definitions, it means your UIKit headers are
out-of-date and you need to update from the SVN repository at http://svn.berlios.de
More information is in this project's README file.
*/

#if 0
/* UIControl */

typedef enum {
    kUIControlEventMouseDown = 1 << 0,
    kUIControlEventMouseMovedInside = 1 << 2, // mouse moved inside control target
    kUIControlEventMouseMovedOutside = 1 << 3, // mouse moved outside control target
    kUIControlEventMouseUpInside = 1 << 6, // mouse up inside control target
    kUIControlEventMouseUpOutside = 1 << 7, // mouse up outside control target
    kUIControlAllEvents = (kUIControlEventMouseDown | kUIControlEventMouseMovedInside | kUIControlEventMouseMovedOutside | kUIControlEventMouseUpInside | kUIControlEventMouseUpOutside)
} UIControlEventMasks;

/* UIScroller */

typedef enum {
    kUIScrollerIndicatorBlack = 1,
    kUIScrollerIndicatorWhite = 2,
    kUIScrollerIndicatorBlackWithWhiteBorder = 3
} UIScrollerIndicatorStyles;


/* UISimpleTableCell, UITextLabel */

typedef enum {
    kUITextLabelEllipsisNone = 0, // this shows how the ellipsis is
    kUITextLabelEllipsisLeading = 1, // this shows ... the ellipsis is added
	kUITextLabelEllipsisEnd = 2, // this shows how the ellipsis...
	kUITextLabelEllipsisTrailing = 3 // this shows how the ... is added
} UITextLabelEllipsisStyles;

/* UINavigationBar */

typedef enum {
    kUINavigationBarBlue = 0,
	kUINavigationBarBlack = 1
} UINavigationBarStyles;

#endif

/* UIApplication notifications?

3a3b5284 S _UIApplicationOrientationDidChangeNotification
3a3b5280 S _UIApplicationOrientationUserInfoKey
3a3b528c S _UIApplicationResumedEventsOnlyNotification
3a3b5290 S _UIApplicationResumedNotification
3a3b5288 S _UIApplicationStatusBarHeightChangedNotification
3a3b5294 S _UIApplicationSuspendedEventsOnlyNotification
3a3b5298 S _UIApplicationSuspendedNotification
3a3b5274 S _UIApplicationWillBeginSuspendAnimation
3a3b527c S _UIApplicationWillSuspendNotification

extern NSString *UIApplicationOrientationDidChangeNotification;

*/

/* UIKit notifications?

3a3b52a8 S _UIKitDesktopImageChangedNotification

extern NSString *UIKitDesktopImageChangedNotification;

*/

