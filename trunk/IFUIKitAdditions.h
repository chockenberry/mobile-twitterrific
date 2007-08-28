//
//  IFUIKitAdditions.h
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 8/28/07.
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//

enum {
    kUIBezierPathTopLeftCorner = 1,
    kUIBezierPathTopRightCorner = 1 << 1,
    kUIBezierPathBottomLeftCorner = 1 << 2,
    kUIBezierPathBottomRightCorner = 1 << 3,
    kUIBezierPathAllCorners = (kUIBezierPathTopLeftCorner | kUIBezierPathTopRightCorner | kUIBezierPathBottomLeftCorner | kUIBezierPathBottomRightCorner)
};
