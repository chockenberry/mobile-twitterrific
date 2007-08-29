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
*/

typedef enum {
    kUIBezierPathTopLeftCorner = 1,
    kUIBezierPathTopRightCorner = 1 << 1,
    kUIBezierPathBottomLeftCorner = 1 << 2,
    kUIBezierPathBottomRightCorner = 1 << 3,
    kUIBezierPathAllCorners = (kUIBezierPathTopLeftCorner | kUIBezierPathTopRightCorner | kUIBezierPathBottomLeftCorner | kUIBezierPathBottomRightCorner)
} UIBezierPathCorners;

typedef enum
{
	kUIViewSwipeUp = 1,
	kUIViewSwipeDown = 2,
	kUIViewSwipeLeft = 4,
	kUIViewSwipeRight = 8
} UIViewSwipeDirection;