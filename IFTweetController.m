//
//  IFTweetController.m
//  MobileTwitterrific
//
//  Created by Martin Gordon on 8/21/07.
//  Copyright 2007 Martin Gordon. All rights reserved.
//

#import "IFTweetController.h"
#import "IFTweetModel.h"

#import <UIKit/CDStructures.h>
#import <UIKit/UISwitchControl.h>
#import <UIKit/UISegmentedControl.h>

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

- (void)showTweet
{
	IFTweetModel *tweetModel = [controller tweetModel];
	
	struct CGRect contentRect = [UIHardware fullScreenApplicationContentRect];
	contentRect.origin.x = 0.0f;
	contentRect.origin.y = 0.0f;
	
	// create the main view
	UIView *tweetView = [[[UIView alloc] initWithFrame:contentRect] autorelease];
	
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
	UISegmentedControl *upDownSegmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(contentRect.size.width - 88.0f - 5.0f, 7.0f, 88.0f, 32.0f) withStyle:2 withItems:nil];
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
  
	// create the text view
	NSDictionary *tweet = [tweetModel selectedTweet];	
	UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, contentRect.size.width, contentRect.size.height - 44.0f)];
	NSString *html = [[NSString alloc] initWithString:[NSString stringWithFormat:@"<b>%@</b><br/>%@",
			[tweet objectForKey:@"userName"], [tweet objectForKey:@"text"]]];
	
	[textView setEditable:NO];
	[textView setHTML:html];
	[tweetView addSubview:textView];	
  
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

#pragma mark UINavigationBar delegate

- (void)navigationBar:(UINavigationBar*)navbar buttonClicked:(int)button 
{
	//NSLog(@"MobileTwitterrificApp: navigationBar:buttonClicked: button = %d", button);

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
@end
