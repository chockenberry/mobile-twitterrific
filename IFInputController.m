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
	
	// create the main view
	UIView *inputView = [[[UIView alloc] initWithFrame:contentRect] autorelease];
	
	// create the navigation bar
	UINavigationBar *navigationBar = [[[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, contentRect.size.width, 44.0f)] autorelease];
	[navigationBar showButtonsWithLeftTitle:@"Cancel" rightTitle:@"Send" leftBack:NO];
	[navigationBar setBarStyle:0];
	[navigationBar setDelegate:self]; 
	[inputView addSubview:navigationBar];

	// create the text view
	NSDictionary *tweet = [tweetModel selectedTweet];	
	UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, contentRect.size.width, contentRect.size.height - 44.0f - 216.0f)];
	NSString *html = [[NSString alloc] initWithString:[NSString stringWithFormat:@"<b>%@</b><br/>%@",
			[tweet objectForKey:@"userName"], [tweet objectForKey:@"text"]]];
	[textView setEditable:NO];
	[textView setHTML:html];
	[inputView addSubview:textView];	

	UIKeyboard *keyboard = [[UIKeyboard alloc] initWithFrame: CGRectMake(0.0f, contentRect.size.height - 216.0f, contentRect.size.width, 216.0f)];
	[inputView addSubview:keyboard];

  
	// setup the views
	UIWindow *mainWindow = [controller mainWindow];
	_oldContentView = [[mainWindow contentView] retain];
	[mainWindow setContentView:inputView];
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
