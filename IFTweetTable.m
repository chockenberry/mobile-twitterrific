//
//  IFTweetTable.m
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 8/28/07.
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//

#import "IFTweetTable.h"


@implementation IFTweetTable

- (BOOL)canSelectRow:(int)row
{
	//NSLog(@"IFTweetTable: canSelectRow: row = %d", row);
	return YES;
}

/*
- (BOOL)canHandleSwipes
{
	return YES;
}
*/

- (int)swipe:(int)num withEvent:(struct __GSEvent *)event;
{
	NSLog(@"IFTweetTable: swipe:withEvent: num = %d", num);
}

/*
#pragma mark HACKING AWAY AT THE DELEGATE

- (BOOL)respondsToSelector:(SEL)aSelector
{
	//NSLog(@"IFTweetTable: respondsToSelector: selector = %@", NSStringFromSelector(aSelector));
	return [super respondsToSelector:aSelector];
}
*/

@end
