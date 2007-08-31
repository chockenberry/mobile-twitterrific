//
//  UIView-Color.m
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 8/31/07.
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//

#import "UIView-Color.h"

@implementation UIView(Color)

+ (CGColorRef)colorWithRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha;
{
	float rgba[4] = {red, green, blue, alpha};
	CGColorRef color = (CGColorRef)[(id)CGColorCreate((CGColorSpaceRef)[(id)CGColorSpaceCreateDeviceRGB() autorelease], rgba) autorelease];
	return color;
}

@end
