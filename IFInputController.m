//
//  IFInputController.h
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 8/24/07.
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//

#import "IFInputController.h"
#import "IFTweetModel.h"
#import "IFTweetView.h"
#import "IFTweetPostView.h"
#import "IFTweetKeyboard.h"
#import "IFTweetEditTextView.h"

#import "UIView-Color.h"

#import <UIKit/CDStructures.h>
#import <UIKit/UISwitchControl.h>
#import <UIKit/UISegmentedControl.h>

#import "IFUIKitAdditions.h"

#pragma mark Instance management

@implementation IFInputController

- (id)initWithAppController:(MobileTwitterrificApp *)appController
{
	self = [super init];
	if (self != nil)
	{
		controller = appController;
	}
	return self;
}

- (void)dealloc
{
//	[_editingTextView release];
//	_editingTextView = nil;
//	[_counterTextView release];
//	_counterTextView = nil;
	
	
	[super dealloc];
}


#pragma mark View control

- (void)showInput
{
	IFTweetModel *tweetModel = [controller tweetModel];
	
	struct CGRect contentRect = [UIHardware fullScreenApplicationContentRect];
	contentRect.origin.x = 0.0f;
	contentRect.origin.y = 0.0f;
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

	// create the main view
	UIView *inputView = [[[UIView alloc] initWithFrame:contentRect] autorelease];
	
	// create a background image
	UIImageView *background = [[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, contentRect.size.width, contentRect.size.height)] autorelease];
	[background setImage:[UIImage defaultDesktopImage]];
	[inputView addSubview:background];

	// create the navigation bar
	UINavigationBar *navigationBar = [[[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, contentRect.size.width, 44.0f)] autorelease];
	[navigationBar showButtonsWithLeftTitle:@"Cancel" rightTitle:@"Send" leftBack:NO];
	[navigationBar setBarStyle:kUINavigationBarBlack];
	[navigationBar setDelegate:self]; 
	[inputView addSubview:navigationBar];

	// create the view for previewing the currently selected tweet
	NSDictionary *tweet = [tweetModel selectedTweet];	
	IFTweetView *tweetView = [[[IFTweetView alloc] initWithFrame:CGRectMake(10.0f, 54.0f, contentRect.size.width - 20.0f, 90.0f)] autorelease];
	[tweetView setContent:tweet];
	[inputView addSubview:tweetView];

#if 0
	// create the text view for editing
	_editingTextView = [[IFTweetEditTextView alloc] initWithFrame:CGRectMake(50.0f, 44.0f + 100.0f, contentRect.size.width - 40.0 - 10.0f, contentRect.size.height - 44.0f - 100.0f - 216.0f)];
	[_editingTextView setEditable:YES];
//	[_editingTextView setText:@"This is a test of the emergency broadcasting system. In the event of a real emergency, you would have been instructed where to tune in your area for further information. This concludes this test of the emergency broadcasting system."];
	[_editingTextView setText:@""];
	[_editingTextView setBackgroundColor:[UIView colorWithRed:1.0f green:0.0f blue:1.0f alpha:0.0]];
	[_editingTextView setTextColor:[UIView colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0]];
	[_editingTextView setCaretColor:[UIView colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0]];
	[_editingTextView setTextSize:18.0f];

//	[_editingTextView setMarginTop:0];
//	[_editingTextView setBottomBufferHeight:22.0f];
	[_editingTextView setDelegate:self];
	
	[inputView addSubview:_editingTextView];

	_counterTextView = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 44.0f + 100.0f, 40.0f, 20.0f)];
	[_counterTextView setEditable:NO];
//	[_counterTextView setText:@"This is a test of the emergency broadcasting system. In the event of a real emergency, you would have been instructed where to tune in your area for further information. This concludes this test of the emergency broadcasting system."];
	[_counterTextView setText:@""];
	[_counterTextView setBackgroundColor:[UIView colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0]];
	[_counterTextView setTextColor:[UIView colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5]];
	[_counterTextView setTextSize:16.0f];

	[inputView addSubview:_counterTextView];

//	[_editingTextView becomeFirstResponder];
#else
	IFTweetPostView *tweetPostView = [[[IFTweetPostView alloc] initWithFrame:CGRectMake(10.0f, 154.0f, contentRect.size.width - 20.0f, 90.0f)] autorelease];
	[inputView addSubview:tweetPostView];
#endif

	// create the keyboard
	IFTweetKeyboard *keyboard = [[[IFTweetKeyboard alloc] initWithFrame: CGRectMake(0.0f, contentRect.size.height - 216.0f, contentRect.size.width, 216.0f)] autorelease];
	[keyboard setReturnKeyEnabled:NO];
//	[keyboard setTapDelegate:_editingTextView];
//	[keyboard setDelegate:self];
//	[keyboard setTapDelegate:self];
	[inputView addSubview:keyboard];

//	[inputView setKeyboard:_editingTextView];
	
	// setup the views
	UIWindow *mainWindow = [controller mainWindow];
	_oldContentView = [[mainWindow contentView] retain];
	[mainWindow setContentView:inputView];
	
	// ensure that the keyboard input will go into the editing field
//	[_editingTextView becomeFirstResponder];
 
//	[mainWindow makeKey:editingTextView];

	CFRelease(colorSpace);
}

- (void)hideInput
{
	// restore the original content view
	[[controller mainWindow] setContentView:_oldContentView];
	[_oldContentView release];
	_oldContentView = nil;
}

#pragma mark UINavigationBar delegate

- (void)navigationBar:(UINavigationBar*)navbar buttonClicked:(int)button 
{
	switch (button) 
	{
	case 0: 
		[self hideInput]; 
		break;
	case 1: 
		[self hideInput]; 
		break;
	}
}

/*
#pragma mark UIView delegate

- (BOOL)view:(id)view handleTapWithCount:(int)count event:(struct __GSEvent *)event
{
	NSLog(@"IFInputController: view:handleTapWithCount:event: view = %@, count = %d", view, count);
	
	NSLog(@"IFInputController: view:handleTapWithCount:event: text = %@, length = %d", [_editingTextView text], [[_editingTextView text] length]);
	
	return YES;
}
*/

#pragma mark HACKING AWAY AT THE DELEGATE

- (BOOL)respondsToSelector:(SEL)aSelector
{
	NSLog(@"IFInputController: respondsToSelector: selector = %@", NSStringFromSelector(aSelector));
	return [super respondsToSelector:aSelector];
}

@end