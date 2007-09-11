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
	[_tweetPostView release];
	_tweetPostView = nil;
	
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

	// create the view for entering the message for the post
	_tweetPostView = [[IFTweetPostView alloc] initWithFrame:CGRectMake(10.0f, 154.0f, contentRect.size.width - 20.0f, 90.0f)];
	[inputView addSubview:_tweetPostView];

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

	// create a connection that will be used to post the message
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *login = [userDefaults stringForKey:@"login"];
	NSString *password = [userDefaults stringForKey:@"password"];
	updateConnection = [[IFTwitterUpdateConnection alloc] initWithLogin:login password:password delegate:self completedCallbackSelector:@selector(twitterUpdateComplete:) authenticationCallbackSelector:@selector(twitterAuthenticate:)];

}

- (void)hideInput
{
	// restore the original content view
	[[controller mainWindow] setContentView:_oldContentView];
	[_oldContentView release];
	_oldContentView = nil;
}

#pragma mark IFTwitterConnection callbacks

- (void)twitterAuthenticate:(id)object
{
	NSLog(@"IFInputController: twitterAuthenticate: object = %@", [object description]);
	
	[[(IFTwitterConnection *)object connection] cancel];
	NSLog(@"MobileTwitterrificApp: twitterAuthenticate: invalid username or password. giving up.");
    
/*
TODO: Figure out how to handle authentication. It's probably easiest to have a 
configuration item for login/password and put that into the URL for the request.
If so, then handling the authentication challenge is unnecessary.
*/
/*
	if (autoLogin && firstLogin)
	{
		[self setLogin:[[userDefaultsController values] valueForKey:@"lastLogin"]];
		[self setPassword:[IFKeychainUtilities getKeychainPasswordForLogin:[self login]]];
		if (connectionLogging)
		{
			NSLog(@"IFMainController: twitterAuthenticate: autoLogin with login = %@, password = %@", [self login], [self password]);
		}
	}
	else
	{
		if (! [self login] || ! [self password])
		{
			[authenticationPanel makeFirstResponder:authenticationUserName];
			[self openAuthenticationSheet];
			[NSApp runModalForWindow:authenticationPanel];

			[self setLogin:[authenticationUserName stringValue]];
			[self setPassword:[authenticationPassword stringValue]];
			
			[IFKeychainUtilities setKeychainForLogin:[self login] withPassword:[self password]];

			[[userDefaultsController values] setValue:[self login] forKey:@"lastLogin"];
			
			// check password for a semicolon
			NSRange semicolonRange = [[self password] rangeOfString:@":"];
			if (semicolonRange.location != NSNotFound)
			{
				[[NSAlert alertWithMessageText:NSLocalizedString(@"PasswordProblem", nil) defaultButton:NSLocalizedString(@"OK", nil) alternateButton:nil otherButton:nil informativeTextWithFormat:NSLocalizedString(@"PasswordProblemText", nil)] runModal];
			}
		}
		if (connectionLogging)
		{
			NSLog(@"IFMainController: twitterAuthenticate: login = %@, password = %@", [self login], [self password]);
		}
	}
*/
}

- (void)twitterUpdateComplete:(id)object
{
	NSLog(@"IFInputController: twitterUpdateComplete: object = %@", [object description]);

	if ([object didSucceed])
	{
		[self hideInput]; 
	}
	else
	{
		NSLog(@"IFInputController: twitterUpdateComplete: errorType = %@, error = %@", [object errorType], [object error]);
		//[self processConnectionFailure:[object errorType] withError:[object error]];
	}
}

#pragma mark UINavigationBar delegate

- (void)navigationBar:(UINavigationBar*)navbar buttonClicked:(int)button 
{
	NSLog(@"IFInputController: navigationBar:buttonClicked: button = %d", button);

	switch (button) 
	{
	case 0:
		// Send
		{
			NSString *message = [_tweetPostView message];
			if ([message length] > 0)
			{
				[updateConnection post:message];
			}
		}
		break;
	case 1:
		// Cancel
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
