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
	return YES;
}

- (void)mouseDown:(struct __GSEvent *)event;
{
	NSLog(@"IFTweetTable: mouseDown:");
	[super mouseDown:event];
}

- (void)mouseUp:(struct __GSEvent *)event;
{
	NSLog(@"IFTweetTable: mouseUp:");
	[super mouseUp:event];
}

- (BOOL)canHandleSwipes
{
	return YES;
}

- (int)swipe:(int)num withEvent:(struct __GSEvent *)event;
{
	NSLog(@"IFTweetTable: swipe:withEvent: num = %d", num);
}

- (void)drawContentInRect:(struct CGRect)rect selected:(BOOL)selected
{
	NSLog(@"IFTweetTable: drawContentInRect:");
}	

- (void)drawRow:(int)row inRect:(struct CGRect)rect
{
	NSLog(@"IFTweetTable: drawRow:inRect:");
}	

- (void)drawRect:(struct CGRect)rect
{
	NSLog(@"IFTweetTable: drawRect:");
}	

- (struct CGRect)selectionBarRect
{
	NSLog(@"IFTweetTable: selectionBarRect:");
	return CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
}	

- (BOOL)selectHighlightedRow
{
	NSLog(@"IFTweetTable: selectHighlightedRow:");
	return NO;
}

- (BOOL)highlightRow:(int)row
{
	NSLog(@"IFTweetTable: highlightRow: row = %d", row);
	return NO;
}

- (void)highlightView:(id)view state:(BOOL)state
{
	NSLog(@"IFTweetTable: highlightView:state: view = %@, state = %d", view, state);
}

#pragma mark HACKING AWAY AT THE DELEGATE

- (BOOL)respondsToSelector:(SEL)aSelector
{
	NSLog(@"IFTweetTable: request for selector: %@", NSStringFromSelector(aSelector));
	return [super respondsToSelector:aSelector];
}


@end

/*
3098c384 T _GSEventGetAccessoryKeyStateInfo
3098b258 T _GSEventGetCharacterSet
3098b174 T _GSEventGetClickCount
3098b0c4 T _GSEventGetDeltaX
3098b0e4 T _GSEventGetDeltaY
3098cbf4 T _GSEventGetEventNumber
3098b038 T _GSEventGetHandInfo
3098c908 T _GSEventGetInnerMostPathPosition
3098b2cc T _GSEventGetKeyWindow
3098b07c T _GSEventGetLocationInWindow
3098b260 T _GSEventGetModifierFlags
3098c938 T _GSEventGetOuterMostPathPosition
3098b058 T _GSEventGetPathInfoAtIndex
3098b0a8 T _GSEventGetSubType
3098b17c T _GSEventGetTimestamp
3098ad68 T _GSEventGetType
3098aed4 T _GSEventGetTypeID
3098cc10 T _GSEventGetWindow


3098c6bc T _GSEventIsChordingHandEvent
3098caac T _GSEventIsForceQuitEvent
3098b08c T _GSEventIsHandEvent
3098c96c T _GSEventIsKeyCharacterEventType
3098b268 T _GSEventIsKeyRepeating
3098cae8 t _GSEventIsMouseEventType
3098ca68 T _GSEventIsTabKeyEvent
*/
