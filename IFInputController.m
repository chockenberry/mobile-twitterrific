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

#import <UIKit/CDStructures.h>
#import <UIKit/UISwitchControl.h>
#import <UIKit/UISegmentedControl.h>

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
	
	// create the navigation bar
	UINavigationBar *navigationBar = [[[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, contentRect.size.width, 44.0f)] autorelease];
	[navigationBar showButtonsWithLeftTitle:@"Cancel" rightTitle:@"Send" leftBack:NO];
	[navigationBar setBarStyle:0];
	[navigationBar setDelegate:self]; 
	[inputView addSubview:navigationBar];

	// create the text view for previewing
	NSDictionary *tweet = [tweetModel selectedTweet];	

	UITextView *previewTextView = [[[UITextView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, contentRect.size.width, 100.0f)] autorelease];
	NSString *html = [[[NSString alloc] initWithString:[NSString stringWithFormat:@"<b>%@</b><br/>%@",
			[tweet objectForKey:@"userName"], [tweet objectForKey:@"text"]]] autorelease];
	[previewTextView setEditable:NO];
	const float grayComponents[4] = {0.75, 0.75, 0.75, 1};
	[previewTextView setBackgroundColor:CGColorCreate(colorSpace, grayComponents)];
//	struct __GSFont *previewFont = [NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:2 size:16.0f];
//	[previewTextView setTextFont:previewFont];
	[previewTextView setHTML:html];
	[inputView addSubview:previewTextView];	

/*
	// create the keyboard
	UIKeyboard *keyboard = [[[UIKeyboard alloc] initWithFrame: CGRectMake(0.0f, contentRect.size.height - 216.0f, contentRect.size.width, 216.0f)] autorelease];
	[keyboard setReturnKeyEnabled:NO];
	[inputView addSubview:keyboard];
*/

 	// create the text view for editing
#if 1
	UITextView *editingTextView = [[[UITextView alloc] initWithFrame:CGRectMake(0.0f, 44.0f + 100.0f, contentRect.size.width, contentRect.size.height - 44.0f - 100.0f - 216.0f)] autorelease];
	[editingTextView setEditable:YES];
	[editingTextView setText:@""];
	[inputView addSubview:editingTextView];

	[editingTextView becomeFirstResponder];
#else
	UITextField *editingTextField = [[[UITextField alloc] initWithFrame:CGRectMake(0.0f, 44.0f + 100.0f, contentRect.size.width, contentRect.size.height - 44.0f - 100.0f - 216.0f)] autorelease];
	//[editingTextField setEditable:YES];
	[editingTextField setText:@"What are you doing?"];
	[inputView addSubview:editingTextField];

	[editingTextField becomeFirstResponder];
#endif

	// create the keyboard
	UIKeyboard *keyboard = [[[UIKeyboard alloc] initWithFrame: CGRectMake(0.0f, contentRect.size.height - 216.0f, contentRect.size.width, 216.0f)] autorelease];
	[keyboard setReturnKeyEnabled:NO];
	[keyboard setTapDelegate:editingTextView];
	[inputView addSubview:keyboard];

 
	// setup the views
	UIWindow *mainWindow = [controller mainWindow];
	_oldContentView = [[mainWindow contentView] retain];
	[mainWindow setContentView:inputView];
	
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

@end
