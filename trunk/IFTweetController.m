//
//  IFTweetController.m
//  MobileTwitterrific
//
//  Created by Martin Gordon on 8/21/07.
//  Copyright 2007 Martin Gordon. All rights reserved.
//

#import "IFTweetController.h"
#import "IFTweetModel.h"
#import "IFTweetView.h"
#import "IFTransparentBox.h"

#import "UIView-Color.h"

#import <UIKit/CDStructures.h>
#import <UIKit/UISwitchControl.h>
#import <UIKit/UISegmentedControl.h>
#import <UIKit/UIThreePartButton.h>
#import <UIKit/UIPushButton-Original.h>

#import <GraphicsServices/GraphicsServices.h>

//#import <UIKit/UIWebView.h>
//#import <WebCore/WebFontCache.h>
//#import <AppKit/NSFontManager.h>

#import "IFUIKitAdditions.h"

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

- (void)button1Down
{
	NSLog(@"IFTweetController: button1Down");
}

- (void)button1MovedInside
{
	NSLog(@"IFTweetController: button1MovedInside");
}

- (void)button1MovedOutside
{
	NSLog(@"IFTweetController: button1MovedOutside");
}

- (void)button1UpInside
{
	NSLog(@"IFTweetController: button1UpInside");
}

- (void)button1UpOutside
{
	NSLog(@"IFTweetController: button1UpOutside");
}


- (void)showTweet
{
	IFTweetModel *tweetModel = [controller tweetModel];
	
	struct CGRect contentRect = [UIHardware fullScreenApplicationContentRect];
	contentRect.origin.x = 0.0f;
	contentRect.origin.y = 0.0f;
	
	// create the main view
	UIView *tweetView = [[[UIView alloc] initWithFrame:contentRect] autorelease];
	[tweetView setBackgroundColor:[UIView colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0]];
	
	// create a background image
	UIImageView *background = [[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, contentRect.size.width, contentRect.size.height)] autorelease];
	[background setImage:[UIImage defaultDesktopImage]];
	[tweetView addSubview:background];

	// create the navigation bar
	UINavigationBar *navigationBar = [[[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, contentRect.size.width, 44.0f)] autorelease];
	[navigationBar showButtonsWithLeftTitle:@"Back" rightTitle:nil leftBack:YES];	
	[navigationBar setBarStyle:0];
	[navigationBar setDelegate:self]; 
	[tweetView addSubview:navigationBar];

	// create the up and down buttons in a segmented control
/*
NOTE: The styles enumeration used withStyle are:
	0 - Gray, no border
	1 - Gray, black border
	2 - Standard light blue
	3 - Like 0
	4 - Like 0
	5 - Like 1
	6+ - ?
*/
	UISegmentedControl *upDownSegmentedControl = [[[UISegmentedControl alloc] initWithFrame:CGRectMake(contentRect.size.width - 88.0f - 5.0f, 7.0f, 88.0f, 32.0f) withStyle:2 withItems:nil] autorelease];
	[upDownSegmentedControl setMomentaryClick:YES];
	[upDownSegmentedControl setDelegate:self];
	[upDownSegmentedControl addSegmentWithTitle:@""];
	[upDownSegmentedControl addSegmentWithTitle:@""];
	[upDownSegmentedControl setImage:[UIImage imageNamed:@"arrowup.png"] forSegment:0];
	[upDownSegmentedControl setImage:[UIImage imageNamed:@"arrowdown.png"] forSegment:1];
	[navigationBar addSubview:upDownSegmentedControl];
  
	int selectionIndex = [tweetModel selectionIndex];
	if (selectionIndex == 0)
	{
		[upDownSegmentedControl setEnabled:NO forSegment:0];    
	}
	else if (selectionIndex == [tweetModel tweetCount] - 1)
	{
		[upDownSegmentedControl setEnabled:NO forSegment:1];    
	}

	NSDictionary *tweet = [tweetModel selectedTweet];	
	IFTweetView *fullTweetView = [[[IFTweetView alloc] initWithFrame:CGRectMake(10.0f, 54.0f, contentRect.size.width - 20.0f, 140.0f)] autorelease];
	[fullTweetView setContent:tweet];
	[tweetView addSubview:fullTweetView];

	// create a box to put the buttons in
	IFTransparentBox *box = [[[IFTransparentBox alloc] initWithFrame:CGRectMake(0.0f, 290.0f, contentRect.size.width, 190.0f)] autorelease];
	[box setBackgroundColor:[UIView colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.750]];
	[tweetView addSubview:box];
	
	// add the push buttons
	UIThreePartButton *button1 = [[[UIThreePartButton alloc] initWithTitle:@"Hit me" autosizesToFit:YES] autorelease];
//	struct __GSFont *font = [NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:NSBoldFontMask size:24.0f];
	GSFontRef font = GSFontCreateWithName("Helvetica", kGSFontTraitBold, 24.0f);
	[button1 setTitleFont:font];
	CFRelease(font);
	[button1 setImage:[UIImage imageNamed:@"refresh.png"]];
	[button1 setBackgroundImage:[UIImage imageNamed:@"bottombarred.png"]];
	[button1 setPressedBackgroundImage:[UIImage imageNamed:@"bottombarred_pressed.png"]];
	CDAnonymousStruct4 pieces;
	pieces.left.origin.x = 0;
	pieces.left.origin.y = 0;
	pieces.left.size.width = 14;
	pieces.left.size.height = 47;
	pieces.middle.origin.x = 15;
	pieces.middle.origin.y = 0;
	pieces.middle.size.width = 1;
	pieces.middle.size.height = 47;
	pieces.right.origin.x = 16;
	pieces.right.origin.y = 0;
	pieces.right.size.width = 14;
	pieces.right.size.height = 47;
	[button1 setBackgroundSlices:pieces];
	[button1 setShadowColor:[UIView colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0]];
	[button1 setShadowOffset:-1.0];
	[button1 setDrawsShadow:YES];
	[button1 setFrame:CGRectMake(10.0f, 300.0f, contentRect.size.width - 20.0f, 47.0f)];

	[button1 addTarget:self action:@selector(button1Down) forEvents:kUIControlEventMouseDown];
	[button1 addTarget:self action:@selector(button1MovedInside) forEvents:kUIControlEventMouseMovedInside];
	[button1 addTarget:self action:@selector(button1MovedOutside) forEvents:kUIControlEventMouseMovedOutside];
	[button1 addTarget:self action:@selector(button1UpInside) forEvents:kUIControlEventMouseUpInside];
	[button1 addTarget:self action:@selector(button1UpOutside) forEvents:kUIControlEventMouseUpOutside];

	[tweetView addSubview:button1];
	
	// setup the views
	UIWindow *mainWindow = [controller mainWindow];
	_oldContentView = [[mainWindow contentView] retain];
	[mainWindow setContentView:tweetView];
}

- (void)moveTweetSelectionBy:(int)offset
{
	IFTweetModel *tweetModel = [controller tweetModel];
	int newIndex = [tweetModel selectionIndex] + offset;
	[tweetModel selectTweetWithIndex:newIndex];

	// notify the app controller that new user defaults are available
	[[NSNotificationCenter defaultCenter] postNotificationName:TWEET_SELECTION_CHANGED object:nil];
}

- (void)showTweetAfterCurrent
{
	[self moveTweetSelectionBy:-1];
	[self showTweet];
}

- (void)showTweetBeforeCurrent
{
	[self moveTweetSelectionBy:+1];
	[self showTweet];
}

- (void)hideTweet
{
	// restore the original content view
	[[controller mainWindow] setContentView:_oldContentView];
	[_oldContentView release];
	_oldContentView = nil;
}

#pragma mark UIView delegate

- (BOOL)view:(id)view handleTapWithCount:(int)count event:(struct __GSEvent *)event
{
	NSLog(@"IFTweetController: view:handleTapWithCount:event: view = %@, count = %d", view, count);
	
	return YES;
}

#pragma mark UINavigationBar delegate

- (void)navigationBar:(UINavigationBar*)navbar buttonClicked:(int)button 
{
	//NSLog(@"IFTweetController: navigationBar:buttonClicked: button = %d", button);

	switch (button) 
	{
	case 0:
		break;
	case 1: 
		[self hideTweet]; 
		break;
	}
}

#pragma mark UISegmentedControl delegate

- (void)segmentedControl:(UISegmentedControl *)segmentedControl selectedSegmentChanged:(int)segment
{
	/*
	The next tweet in the IFTweetModel is the one above the current one in the table,
	but it makes sense for the Next button to show the tweet below this one than the next one
	chronologically. The method called and the button title are the opposite of each other.  
	*/
	switch (segment)
	{
	case 0: // "Up" button
		[self hideTweet];
		[self showTweetAfterCurrent];
		break;
	case 1: // "Down" button
		[self hideTweet];
		[self showTweetBeforeCurrent];
		break;
	}
}

/*
#pragma mark HACKING AWAY AT THE DELEGATE

- (BOOL)respondsToSelector:(SEL)aSelector
{
	NSLog(@"IFTweetController: respondsToSelector: selector = %@", NSStringFromSelector(aSelector));
	return [super respondsToSelector:aSelector];
}
*/

@end
