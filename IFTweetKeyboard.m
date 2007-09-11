//
//  IFTweetKeyboard.m
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 9/6/07.
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//

#import "IFTweetKeyboard.h"


//
// Override settings of the default keyboard implementation
//

/*
@interface UIKeyboardImpl : UIView
{

}
@end
*/

@implementation UIKeyboardImpl (TweetConfiguration)

/*
- (BOOL)autoCapitalizationPreference
{
	return false;
}

- (BOOL)autoCorrectionPreference
{
	return false;
}
*/

- (BOOL)acceptInputString:(id)string
{
	NSLog(@"UIKeyboardImpl: acceptInputString: string = %@", string);
#if 0
	if ([string isEqualToString:@"x"])
	{
		return NO;
	}
	else
	{
		return YES;
	}
#else
	return YES;
#endif
}

- (void)textChanged:(id)text
{
	NSLog(@"UIKeyboardImpl: textChanged: text = %@", text);
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
	NSLog(@"UIKeyboardImpl: respondsToSelector: selector = %@", NSStringFromSelector(aSelector));
	return [super respondsToSelector:aSelector];
}


@end

//

@implementation IFTweetKeyboard

- (id)initWithFrame:(struct CGRect)frame;
{
    self = [super initWithFrame:frame];
	if (self)
	{
		NSLog(@"IFTweetKeyboard: initWithFrame:");
		[UIKeyboard initImplementationNow];
		NSLog(@"IFTweetKeyboard: initWithFrame: delegate = %@", [self delegate]);
		NSLog(@"IFTweetKeyboard: initWithFrame: defaultTextTraits = %@", [self defaultTextTraits]);
		NSLog(@"IFTweetKeyboard: initWithFrame: editingDelegate = %@", [[self defaultTextTraits] editingDelegate]);
	}

	return self;
}

- (void)caretChanged
{
	NSLog(@"IFTweetKeyboard: caretChanged:");
}

- (BOOL)keyboardInputChanged:(id)param
{
	NSLog(@"IFTweetKeyboard: keyboardInputChanged: param = %@", param);
	return YES;
}

- (void)keyDown:(struct __GSEvent *)event;
{
	NSLog(@"IFTweetKeyboard: keyDown:");
	[super keyDown:event];
}

- (void)keyUp:(struct __GSEvent *)event;
{
	NSLog(@"IFTweetKeyboard: keyUp:");
	[super keyUp:event];
}

- (void)mouseDown:(struct __GSEvent *)event;
{
	NSLog(@"IFTweetKeyboard: mouseDown:");
	[super mouseDown:event];
}

- (void)mouseDragged:(struct __GSEvent *)event;
{
	NSLog(@"IFTweetKeyboard: mouseDragged:");
	[super mouseDragged:event];
}

- (void)mouseUp:(struct __GSEvent *)event;
{
	NSLog(@"IFTweetKeyboard: mouseUp:");
	[super mouseUp:event];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
	NSLog(@"IFTweetKeyboard: respondsToSelector: selector = %@", NSStringFromSelector(aSelector));
	return [super respondsToSelector:aSelector];
}

@end
