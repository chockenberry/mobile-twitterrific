//
//  IFTweetEditTextView.m
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 9/6/07.
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//

#import "IFTweetEditTextView.h"


@implementation IFTweetEditTextView

- (void)keyDown:(struct __GSEvent *)event;
{
	NSLog(@"IFTweetEditTextView: keyDown:");
	[super keyDown:event];
}

- (void)keyUp:(struct __GSEvent *)event;
{
	NSLog(@"IFTweetEditTextView: keyUp:");
	[super keyUp:event];
}

- (void)mouseDown:(struct __GSEvent *)event;
{
	NSLog(@"IFTweetEditTextView: mouseDown:");
	[super mouseDown:event];
}

- (void)mouseDragged:(struct __GSEvent *)event;
{
	NSLog(@"IFTweetEditTextView: mouseDragged:");
	[super mouseDragged:event];
}

- (void)mouseUp:(struct __GSEvent *)event;
{
	NSLog(@"IFTweetEditTextView: mouseUp:");
	[super mouseUp:event];
}

- (void)webViewDidChange:(NSNotification *)notification
{
//	NSLog(@"IFTweetEditTextView: webViewDidChange: notification = %@", [notification object]);
	NSLog(@"IFTweetEditTextView: webViewDidChange: text = %@ (%d)", [self text], [[self text] length]);
	
	[super webViewDidChange:notification];
}

/*
- (BOOL)webView:(id)view shouldBeginEditingInDOMRange:(id)range
{
	NSLog(@"IFTweetEditTextView: webView:shouldBeginEditingInDOMRange: view = %@, range = %@", view, range);
	return YES;
}
*/

- (BOOL)respondsToSelector:(SEL)aSelector
{
	NSLog(@"IFTweetEditTextView: respondsToSelector: selector = %@", NSStringFromSelector(aSelector));
	return [super respondsToSelector:aSelector];
}


@end
