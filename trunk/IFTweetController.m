//
//  IFTweetController.m
//  MobileTwitterrific
//
//  Created by Martin Gordon on 8/21/07.
//  Copyright 2007 Martin Gordon. All rights reserved.
//

#import "IFTweetController.h"
#import <UIKit/CDStructures.h>
#import <UIKit/UISwitchControl.h>

#pragma mark Instance management

@implementation IFTweetController
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

- (void)showTweet:(int)tweetIndex
{
	currentIndex = tweetIndex;
	struct CGRect contentRect = [UIHardware fullScreenApplicationContentRect];
	contentRect.origin.x = 0.0f;
	contentRect.origin.y = 0.0f;
	
	// create the main view
	UIView *tweetView = [[[UIView alloc] initWithFrame:contentRect] autorelease];
	
	// create the navigation bar
	UINavigationBar *navigationBar = [[[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, contentRect.size.width, 48.0f)] autorelease];
	if (tweetIndex < [[controller tweets] count] - 1)
		[navigationBar showButtonsWithLeftTitle:@"Back" rightTitle:@"Next" leftBack:YES];
	else
		[navigationBar showButtonsWithLeftTitle:@"Back" rightTitle:nil leftBack:YES];
	
	[navigationBar setBarStyle:0];
	[navigationBar setDelegate:self]; 
	[tweetView addSubview:navigationBar];
	
	// create the text view
	UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 48.0f, contentRect.size.width, contentRect.size.height - 48.0f)];
	NSString *html = [[NSString alloc] initWithString:[NSString stringWithFormat:@"<b>%@</b><br/>%@", 
		[[[controller tweets] objectAtIndex:currentIndex] objectForKey:@"userName"],
		[[[controller tweets] objectAtIndex:currentIndex] objectForKey:@"text"]]];
	
	[textView setEditable:NO];
	[textView setHTML:html];
	[tweetView addSubview:textView];	
	
	// setup the views
	UIWindow *mainWindow = [controller mainWindow];
	_oldContentView = [[mainWindow contentView] retain];
	[mainWindow setContentView:tweetView];
}

- (void)hideTweet
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
		[self hideTweet];
		[self showTweet:currentIndex + 1];
		break;
	case 1: 
		[self hideTweet]; 
		break;
	}
}
@end
