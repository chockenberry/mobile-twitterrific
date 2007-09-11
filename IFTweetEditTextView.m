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

- (BOOL) isValidDelegateForSelector:(SEL)selector
{
	return (([self delegate] != nil) && [[self delegate] respondsToSelector:selector]);
}

- (void)webViewDidChange:(NSNotification *)notification
{
//	NSLog(@"IFTweetEditTextView: webViewDidChange: notification = %@", [notification object]);
//	NSLog(@"IFTweetEditTextView: webViewDidChange: text = %@ (%d)", [self text], [[self text] length]);
	if ([[self text] length] > 140)
	{
		// limit the text to 140 characters
		[self setText:[[self text] substringToIndex:140]];
	}
	else
	{
		// notify the delegate that the text has changed
		if ([self isValidDelegateForSelector:@selector(editTextViewDidChange:)])
		{
			[[self delegate] performSelector:@selector(editTextViewDidChange:) withObject:self];
		}
	}

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
