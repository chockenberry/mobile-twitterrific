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

#import "UIView-Color.h"

#import <UIKit/CDStructures.h>
#import <UIKit/UISwitchControl.h>
#import <UIKit/UISegmentedControl.h>
#import <UIKit/UIThreePartButton.h>
#import <UIKit/UIPushButton-Original.h>

//#import <UIKit/UIWebView.h>
#import <WebCore/WebFontCache.h>
#import <AppKit/NSFontManager.h>

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

- (void)buttonAction0
{
	NSLog(@"IFTweetController: buttonAction0");
}

- (void)buttonAction1
{
	NSLog(@"IFTweetController: buttonAction1");
}

- (void)buttonAction2
{
	NSLog(@"IFTweetController: buttonAction2");
}

- (void)buttonAction3
{
	NSLog(@"IFTweetController: buttonAction3");
}

- (void)buttonAction4
{
	NSLog(@"IFTweetController: buttonAction4");
}

- (void)buttonAction5
{
	NSLog(@"IFTweetController: buttonAction5");
}

- (void)buttonAction6
{
	NSLog(@"IFTweetController: buttonAction6");
}

- (void)buttonAction7
{
	NSLog(@"IFTweetController: buttonAction7");
}

- (void)buttonAction8
{
	NSLog(@"IFTweetController: buttonAction8");
}

- (void)buttonAction9
{
	NSLog(@"IFTweetController: buttonAction9");
}

- (void)buttonAction10
{
	NSLog(@"IFTweetController: buttonAction10");
}

- (void)buttonAction11
{
	NSLog(@"IFTweetController: buttonAction11");
}

- (void)buttonAction12
{
	NSLog(@"IFTweetController: buttonAction12");
}

- (void)buttonAction13
{
	NSLog(@"IFTweetController: buttonAction13");
}

- (void)buttonAction14
{
	NSLog(@"IFTweetController: buttonAction14");
}

- (void)buttonAction15
{
	NSLog(@"IFTweetController: buttonAction15");
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

#if 0
#if 1
	// create the text view
	NSDictionary *tweet = [tweetModel selectedTweet];	
	UITextView *textView = [[[UITextView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, contentRect.size.width, contentRect.size.height - 44.0f)] autorelease];
	NSString *html = [[[NSString alloc] initWithString:[NSString stringWithFormat:@"<img src=\"%@\" width=\"80\" height=\"80\"><b>%@</b><br/>%@<br/><a href=\"http://iconfactory.com\">link</a>",
			[tweet objectForKey:@"userAvatarUrl"], [tweet objectForKey:@"userName"], [tweet objectForKey:@"text"]]] autorelease];
	
	[textView setEditable:NO];
	[textView setTextSize:16.0f];
	[textView setHTML:html];
	[textView setDelegate:self];
	[textView setTapDelegate:self];
//	[[textView _webView] setDelegate:self];
//	[(WebView *)*[(UIWebView *)[textView _webView] webView] setPolicyDelegate:self];
	[textView becomeFirstResponder];
	[tweetView addSubview:textView];	
#else
	UIWebView *webView = [[[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, contentRect.size.width, contentRect.size.height - 44.0f)] autorelease];
	[[[webView webView] mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://iconfactory.com/home/staff"]]];
	[tweetView addSubview:webView];
#endif
#else
	NSDictionary *tweet = [tweetModel selectedTweet];	
	IFTweetView *fullTweetView = [[[IFTweetView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, contentRect.size.width, 216.0f)] autorelease];
	[fullTweetView setContent:tweet];
	[tweetView addSubview:fullTweetView];
#endif

	// add the push buttons
#if 1
#if 0
	UIThreePartButton *button1 = [[[UIThreePartButton alloc] initWithFrame:CGRectMake(10.0f, 300.0f, contentRect.size.width - 20.0f, 47.0f)] autorelease];
	[button1 setBackgroundImage:[UIImage imageNamed:@"bottombarred.png"]];
	[button1 setPressedBackgroundImage:[UIImage imageNamed:@"bottombarred_pressed.png"]];
#else

	UIThreePartButton *button1 = [[[UIThreePartButton alloc] initWithTitle:@"Hit me" autosizesToFit:YES] autorelease];
	struct __GSFont *font = [NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:NSBoldFontMask size:24.0f];
	[button1 setTitleFont:font];
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
//	[button1 addTarget:self action:@selector(buttonAction0) forEvents:0];
	[button1 addTarget:self action:@selector(buttonAction1) forEvents:1]; // mouse down
	[button1 addTarget:self action:@selector(buttonAction2) forEvents:2];
	[button1 addTarget:self action:@selector(buttonAction3) forEvents:4]; // mouse moved
	[button1 addTarget:self action:@selector(buttonAction4) forEvents:8]; // mouse exited
	[button1 addTarget:self action:@selector(buttonAction5) forEvents:16];
	[button1 addTarget:self action:@selector(buttonAction6) forEvents:32];
	[button1 addTarget:self action:@selector(buttonAction7) forEvents:64]; // mouse up inside
	[button1 addTarget:self action:@selector(buttonAction8) forEvents:128]; // mouse up outside
	
/*
	[button1 addTarget:self action:@selector(buttonAction2) forEvents:2];
	[button1 addTarget:self action:@selector(buttonAction3) forEvents:3];
	[button1 addTarget:self action:@selector(buttonAction4) forEvents:4];
	[button1 addTarget:self action:@selector(buttonAction5) forEvents:5];
	[button1 addTarget:self action:@selector(buttonAction6) forEvents:6];
	[button1 addTarget:self action:@selector(buttonAction7) forEvents:7];
	[button1 addTarget:self action:@selector(buttonAction8) forEvents:8];
	[button1 addTarget:self action:@selector(buttonAction9) forEvents:9];
	[button1 addTarget:self action:@selector(buttonAction10) forEvents:10];
	[button1 addTarget:self action:@selector(buttonAction11) forEvents:11];
	[button1 addTarget:self action:@selector(buttonAction12) forEvents:12];
	[button1 addTarget:self action:@selector(buttonAction13) forEvents:13];
	[button1 addTarget:self action:@selector(buttonAction14) forEvents:14];
	[button1 addTarget:self action:@selector(buttonAction15) forEvents:15];
	[button1 addTarget:self action:@selector(buttonAction0) forEvents:0xffff];
*/
#endif
#else
	UIPushButton *button1 = [[[UIPushButton alloc] initWithFrame:CGRectMake(0.0f, 300.0f, contentRect.size.width - 20.0f, 47.0f)] autorelease];
	[button1 setImage:[UIImage imageNamed:@"bottombarred.png"] forState:0];
	[button1 setImage:[UIImage imageNamed:@"bottombarred_pressed.png"] forState:1];
	[button1 setAutosizesToFit:YES];
	[button1 setDrawContentsCentered:YES];
	[button1 setTitle:@"Red Alert"];
#endif	
	[tweetView addSubview:button1];
/*
+ (struct __GSFont *)defaultFont;	// IMP=0x3241a7e4
- (CDAnonymousStruct4)_backgroundSlices:(struct CGSize)fp8;	// IMP=0x3241a920
- (id)background;	// IMP=0x3241a900
- (void)drawTitleAtPoint:(struct CGPoint)fp8 width:(float)fp16;	// IMP=0x3241a998
- (id)initWithFrame:(struct CGRect)fp8;	// IMP=0x3241a7f8
- (float)minTitleMargin;	// IMP=0x3241a964
- (void)setBackgroundImage:(id)fp8;	// IMP=0x3241a8c0
- (void)setBackgroundSlices:(CDAnonymousStruct4)fp8;	// IMP=0x3241a880
- (void)setPressedBackgroundImage:(id)fp8;	// IMP=0x3241a8e0
*/
	
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
