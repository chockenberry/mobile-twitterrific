//
//  MobileTwitterrificApp.m
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 8/17/07.
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright notice, this
//    list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//  * Neither the name of the Iconfactory nor the names of its contributors may
//    be used to endorse or promote products derived from this software without
//    specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
//  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
//  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
//  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
//  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
//  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
//  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
//  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
//  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>

#import <UIKit/CDStructures.h>
#import <UIKit/UIPushButton.h>
#import <UIKit/UIThreePartButton.h>
#import <UIKit/UINavigationBar.h>
#import <UIKit/UIWindow.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIHardware.h>
#import <UIKit/UITable.h>
#import <UIKit/UITableCell.h>
#import <UIKit/UITableColumn.h>
#import <UIKit/UIButtonBar.h>
#import <UIKit/UIButtonBarButton.h>
#import <UIKit/UIButtonBarTextButton.h>

#import <WebCore/WebFontCache.h>

#import "IFPreferencesController.h"
#import "IFTweetController.h"
#import "IFTweetModel.h"
#import "IFSoundController.h"
#import "IFInputController.h"

#import "IFTestDictionary.h"

#import "MobileTwitterrificApp.h"

@implementation MobileTwitterrificApp

/*
TODO: Figure out how to handle errors and/or alerts. UIAlertSheet looks promising.
*/

#pragma mark Instance management

- (id)init
{
	self = [super init];
	if (self)
	{
		firstLogin = YES;
		timelineConnection = [[IFTwitterTimelineConnection alloc] initWithLogin:nil password:nil delegate:self completedCallbackSelector:@selector(twitterStatusComplete:) authenticationCallbackSelector:@selector(twitterAuthenticate:)];
	}
	
	return self;
}

- (void)dealloc
{
	[timelineConnection release];
	[preferencesController release];
	[tweetController release];
	[inputController release];
	[soundController release];
	[_tweetModel release];

	[super dealloc];
}

#pragma mark Accessors

- (UIWindow *)mainWindow
{
    return _mainWindow;
}

- (void)setMainWindow:(UIWindow *)newMainWindow
{
    [_mainWindow release];
    _mainWindow = [newMainWindow retain];
}

- (IFTweetModel *)tweetModel
{
	return _tweetModel;
}


#pragma mark UITable delegate and data source

- (int) numberOfRowsInTable: (UITable *)table
{
	return [[self tweetModel] tweetCount];
}

- (UITableCell *)table:(UITable *)table cellForRow:(int)row column:(int)column
{
	//NSLog(@"MobileTwitterrificApp: table:cellForRow:column: row = %d, column = %d", row, column);

	NSDictionary *tweet = [[self tweetModel] tweetAtIndex:row];
	
	UIImageAndTextTableCell *imageAndTextTableCell = [[[UIImageAndTextTableCell alloc] init] autorelease];
	[imageAndTextTableCell setTitle:[tweet objectForKey:@"userName"]];

	return imageAndTextTableCell;
}


/*
NOTE: The following methods determine whether the disclosure arrow (>)
is shown for the row. - (BOOL)table:(UITable *)table disclosureClickableForRow:(int)row
determines whether the arrow is clickable. If it isn't clickable, creates a "dead spot"
on the arrow (selection won't change if clicked on arrow). It defaults to YES, so we
don't have to implement it unless we have a good reason to not respond to clicks
on the arrow itself.
*/
- (BOOL)table:(UITable *)table showDisclosureForRow:(int)row
{
	return YES;
}

- (BOOL)table:(UITable *)table disclosureClickableForRow:(int)row
{
	return YES;
}

- (void)tableRowSelected:(NSNotification *)aNotification
{
	[[self tweetModel] selectTweetWithIndex:[table selectedRow]];
	[tweetController showTweet];
}


#pragma mark User interface

- (void)parseXMLDocument:(NSXMLDocument *)document ofType:(NSString *)type
{
	//NSError *error = nil;

/*
NOTE: This would be so much easier if there was XPath support in NSXMLDocument.
Since there isn't we'll just enumerate the children and look for node names
and stringValues.
*/

	// get the status nodes from the XML document
	//NSArray *statusNodes  = [document nodesForXPath:@"statuses/status" error:&error];
	NSArray *statusNodes = [[[document children] lastObject] children];
	//NSLog(@"statusNodes = %@", statusNodes);

	// process each status node
	unsigned int tweetCount = 0;
	unsigned int tweetFeedCount = 0;
	BOOL addedNewContent = NO;
	//NSString *firstAddedId = nil;
	NSEnumerator *statusNodeEnumerator = [statusNodes objectEnumerator];
	NSXMLNode *statusNode = nil;
	while ((statusNode = [statusNodeEnumerator nextObject]))
	{
		// create a dictionary where content from the status node will be collected
		NSMutableDictionary *content = [[[NSMutableDictionary alloc] init] autorelease];
		
		// the type is used to track the source of the content (timeline, replies or direct messages)
		[content setValue:type forKey:@"type"];

		NSEnumerator *statusChildEnumerator = [[statusNode children] objectEnumerator];
		NSXMLNode *statusChildNode = nil;
		while ((statusChildNode = [statusChildEnumerator nextObject]))
		{
			NSString *statusChildName = [statusChildNode name];
			
			//NSLog(@"status child name = %@, stringValue = %@", statusChildName, [statusChildNode objectValue]);

			if ([statusChildName isEqualToString:@"id"])
			{
				[content setValue:[statusChildNode stringValue] forKey:@"id"];
			}
			else if ([statusChildName isEqualToString:@"text"])
			{
				NSMutableString *text = [NSMutableString stringWithString:[statusChildNode stringValue]];
				[text replaceOccurrencesOfString:@"&gt;" withString:@">" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [text length])];
				[text replaceOccurrencesOfString:@"&lt;" withString:@"<" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [text length])];
				if (text)
				{
					[content setValue:text forKey:@"text"];
				}
			}
			else if ([statusChildName isEqualToString:@"created_at"])
			{
				NSDate *date = [NSDate dateWithNaturalLanguageString:[statusChildNode stringValue]];
				if (date)
				{
					[content setValue:date forKey:@"date"];
				}
			}
			else if ([statusChildName isEqualToString:@"user"])
			{
				NSEnumerator *userChildEnumerator = [[statusChildNode children] objectEnumerator];
				NSXMLNode *userChildNode = nil;
				while ((userChildNode = [userChildEnumerator nextObject]))
				{
					NSString *userChildName = [userChildNode name];
					if ([userChildName isEqualToString:@"name"])
					{
						[content setValue:[userChildNode stringValue] forKey:@"userName"];
					}
					else if ([userChildName isEqualToString:@"screen_name"])
					{
						[content setValue:[userChildNode stringValue] forKey:@"screenName"];
					}
					else if ([userChildName isEqualToString:@"profile_image_url"])
					{
						[content setValue:[userChildNode stringValue] forKey:@"userAvatarUrl"];
/*
TODO: Instantiate UIImage from URL
*/
					}
					else if ([userChildName isEqualToString:@"url"])
					{
						[content setValue:[userChildNode stringValue] forKey:@"userUrl"];
					}
				}
			}
			
		}
		
//		NSString *tweetId = [content objectForKey:@"id"];
//		if (tweetId)
		{
			//NSLog(@"MobileTwitterrificApp: parseXMLDocument: content id = %@, type = %@", [content objectForKey:@"id"], [content objectForKey:@"type"]);

			BOOL tweetWasAdded = [_tweetModel addTweet:content];
			if (tweetWasAdded)
			{
			
//			// check to see if id already exists
//			int index = [self indexForId:id];
//			if (index == -1)
//			{
/*
				// add the content to the user interface
				UIImageAndTextTableCell *imageAndTextTableCell = [[UIImageAndTextTableCell alloc] init];
				[imageAndTextTableCell setTitle:[content objectForKey:@"userName"]];
				[rowCells addObject:imageAndTextTableCell];
*/		
				// add the content to the model
//				[tweets addObject:content];
//				[_tweetModel addTweet:content];
				
				addedNewContent = YES;
				tweetCount += 1;
			}
			
			tweetFeedCount += 1;
		}
	}	
	
	NSLog(@"MobileTwitterrificApp: parseXMLDocument: received %d tweets", tweetFeedCount);

	if (addedNewContent)
	{
		NSLog(@"MobileTwitterrificApp: parseXMLDocument: created %d tweets", tweetCount);
/*
TODO: Manage the table cells and the model more intelligently. The current
implementation is just a proof-of-concept. Hopefully, the right choice will become
clearer once the UI and associated views are established.
*/
		//[self sortTweets]; // to display tweets from newest to oldest
		//[self removeOldTweets]; // to clean up data and keep memory usage to a minimum
		
		[table reloadData];

		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		BOOL notify = [userDefaults boolForKey:@"notify"];
		if (notify)
		{
			[soundController playNotification];
		}
	}
}

- (void)setupUserInterface
{
/*
NOTE: Use UIHardware to get screen dimensions, since they can (and probably will)
change in the future. Anytime you find yourself hardcoding 320.0f and 480.0f,
resist the urge.
*/
	struct CGRect contentRect = [UIHardware fullScreenApplicationContentRect];
	contentRect.origin.x = 0.0f;
	contentRect.origin.y = 0.0f;

	// create a controller for managing the user's preference view, the detailed tweet view, and the input view
	preferencesController = [[IFPreferencesController alloc] initWithAppController:self];
	tweetController = [[IFTweetController alloc] initWithAppController:self];
	inputController = [[IFInputController alloc] initWithAppController:self];

	// create a controller for sounds
	soundController = [[IFSoundController alloc] init];
	
	// create a model for managing the tweets
	_tweetModel = [[IFTweetModel alloc] init];

	UIWindow *window = [[UIWindow alloc] initWithContentRect:[UIHardware fullScreenApplicationContentRect]];

/*
TODO: The main view should consist of three UI components:

1) The navigation bar (with [Setup] and [Refresh])
2) The main tweet view
3) A toolbar with [?] (for updates) [@] (for replies) [D] (for direct messages) -- each button will open an "update view"
with "What are you doing?" and some context for the post.
*/

	// create a table whose height is the full screen, less the navbar, less the button bar
	table = [[UITable alloc] initWithFrame:CGRectMake(0.0f, 44.0f, contentRect.size.width, contentRect.size.height - 44.0f - 44.0f)];
	UITableColumn *tableColumn = [[UITableColumn alloc] initWithTitle:@"Twitterrific" identifier:@"twitterrific" width:contentRect.size.width];

	[window orderFront:self];
	[window makeKey:self];
	[window _setHidden:NO];

	[table addTableColumn:tableColumn]; 
	[table setDataSource:self];
	[table setDelegate:self];
	[table reloadData];

/*
NOTE: The styles enumeration used withBarStyle are:
	0 - Standard light blue
	1 - Shiny black
	2 - Like 1
	3 - Like 0
	4+ - ?
*/
	UINavigationBar *navigationBar = [[[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, contentRect.size.width, 44.0f)] autorelease];
	[navigationBar showButtonsWithLeftTitle:@"Refresh" rightTitle:@"Setup"];
	[navigationBar setBarStyle:1];
	[navigationBar setDelegate:self];

/*
	UIButtonBar *buttonBar = [[[UIButtonBar alloc] initWithFrame:CGRectMake(0.0f, contentRect.size.height - 44.0f, contentRect.size.width, 44.0f)] autorelease];
	[buttonBar setBarStyle:0];
	[buttonBar setDelegate:self];
*/

	UIView *mainView = [[UIView alloc] initWithFrame:contentRect];
	[mainView addSubview:navigationBar];
	[mainView addSubview:table];
	

/*
These look like promising keys for the NSDictionary (from UIKit)

UIButtonBarButtonTitleWidth
UIButtonBarButtonStyle
UIButtonBarButtonTarget
UIButtonBarButtonAction
UIButtonBarButtonTag
UIButtonBarButtonSelectedInfo
UIButtonBarButtonInfo
UIButtonBarButtonTitle
UIButtonBarButtonType

// these are probably class names
UIButtonBarButtonItem
UIButtonBarCustomizeHeader
UIButtonBarCustomizeView
UIButtonBarTextButton
UIButtonBarButton
UIButtonBarButtonBadge
UISwappableImageView
UISelectionIndicatorView
kUIButtonBarButtonInfoOffset
kUIButtonBarButtonTitleVerticalHeight

// standard images?
UIButtonBarSelectedIndicator.png
UIButtonBarBlueMiniButton.png
UIButtonBarMiniButton.png
UIButtonBarMiniButtonPressed.png
*/
	NSLog(@"creating testButton");
//	UIButtonBarButton *testButton = [[[UIButtonBarButton alloc] initWithImage:[UIImage imageNamed:@"arrowup.png"] selectedImage:[UIImage imageNamed:@"arrowdown.png"] label:@"Test" labelHeight:20.0f withBarStyle:0 withStyle:0 withOffset:NSMakeSize(4.0f, 0.0f)] autorelease];

//	struct __GSFont *font = [NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:2 size:16.0f];
//	UIButtonBarTextButton *testButton = [[[UIButtonBarTextButton alloc] initWithTitle:@"Title" selectedTitle:@"Selected" withFont:font withBarStyle:0 withStyle:0 withTitleWidth:44.0f] autorelease];      

	NSLog(@"creating dictionary");
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithFloat:44.0f], @"UIButtonBarButtonTitleWidth",
		[NSNumber numberWithInt:0], @"UIButtonBarButtonStyle",
		@"Title", @"UIButtonBarButtonTitle",
		@"Tag", @"UIButtonBarButtonTag",
		@"UIButtonBarButton", @"UIButtonBarButtonType",
		self, @"UIButtonBarButtonTarget",
		nil];
//		@selector(buttonAction:), @"UIButtonBarButtonAction",
//		testButton, @"UIButtonBarButton", 
	
	
	NSLog(@"creating test dictionary");
	IFTestDictionary *testDictionary = [[IFTestDictionary alloc] initWithDictionary:dictionary];
	
	NSLog(@"creating array");
	NSArray *itemList = [NSArray arrayWithObject:testDictionary];
//	NSArray *itemList = [NSArray arrayWithObject:dictionary];

	NSLog(@"creating buttonBar");
	UIButtonBar *buttonBar = [[[UIButtonBar alloc] initInView:mainView withItemList:itemList] autorelease];

/*
	NSLog(@"creating dictionary");
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
		self, @"UIButtonBarButtonTarget",
		nil];
	id button = [buttonBar createButtonWithDescription:dictionary];
	NSLog(@"button = %@", button);
*/
	
	[buttonBar setBarStyle:1];
	[buttonBar setDelegate:self];
	
	[mainView addSubview:buttonBar];

	[window setContentView:mainView];
	[self setMainWindow:window];
}

#pragma mark Timers

- (void)refresh
{
	[timelineConnection refresh];
}

#pragma mark Notifications

- (void)updatePreferences
{
	NSLog(@"MobileTwitterrificApp: updatePreferences:");
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *login = [userDefaults stringForKey:@"login"];
	NSString *password = [userDefaults stringForKey:@"password"];
	BOOL refresh = [userDefaults boolForKey:@"refresh"];

	// stop the current timer if there is one
	if (refreshTimer)
	{
		[refreshTimer invalidate];
		[refreshTimer release];
		refreshTimer = nil;
	}
	if (refresh)
	{
/*
TODO: Make the refresh interval a preference.
*/
		refreshTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
		[refreshTimer retain];
	}
	
	[timelineConnection setLogin:login];
	[timelineConnection setPassword:password];
	firstLogin = YES;
}

- (void)updateTweetSelection
{
	int newIndex = [[self tweetModel] selectionIndex];
	NSLog(@"MobileTwitterrificApp: updateTweetSelection: new index = %d", newIndex);
/*
TODO: The following code causes weird things to happen with the table. Need to find a way
to handle the selection update from the tweetController. Probably has something to do with
the main view not being a contentView when the notification is sent.
*/
	//[table selectRow:newIndex byExtendingSelection:NO withFade:NO scrollingToVisible:YES];
	//[table selectRow:newIndex byExtendingSelection:NO];
}	

- (void)setupNotifications
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePreferences) name:PREFERENCES_CHANGED object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTweetSelection) name:TWEET_SELECTION_CHANGED object:nil];
}


#pragma mark UIApplication delegate

- (void)applicationDidFinishLaunching:(id)unused
{
	NSLog(@"MobileTwitterrificApp: applicationDidFinishLaunching: unused = %@", [unused description]);
	
	[self setupUserInterface];
	[self setupNotifications];
	
	[self updatePreferences];
	
	[self refresh];
}

/*
NOTE: These methods are an attempt to figure out how suspended operation works. I'd
like to use this to retrieve tweets in the background. These method signatures were
lifted from the MobileMail class-dump -- it does a similar thing when it checks for
new mail while other applications are running.

But there's a problem. The NSLog output can only be viewed when running from the shell
command line. And when you're running in that mode, there's no Springboard to watch
the Home button. So there's nothing to initiate the calls to the suspend methods in
the delegate.

This will probably call for some kind of logging that writes the information to a
log file which can then be monitored after a launch from Springboard.
*/

- (void)applicationDidFinishLaunchingSuspended:(id)unused;
{
	NSLog(@"MobileTwitterrificApp: applicationDidFinishLaunchingSuspended: unused = %@", [unused description]);
}

- (void)cleanUpAfterSuspend
{
	NSLog(@"MobileTwitterrificApp: cleanUpAfterSuspend");
}

- (BOOL)applicationSuspend:(struct __GSEvent *)fp8 settings:(id)unused
{
	NSLog(@"MobileTwitterrificApp: applicationSuspend: unused = %@", [unused description]);
}

- (void)applicationWillSuspendForEventsOnly
{
	NSLog(@"MobileTwitterrificApp: applicationWillSuspendForEventsOnly");
}

- (void)didReceiveMemoryWarning;
{
	NSLog(@"MobileTwitterrificApp: didReceiveMemoryWarning");
}

- (void)didReceiveUrgentMemoryWarning;
{
	NSLog(@"MobileTwitterrificApp: didReceiveUrgentMemoryWarning");
}

- (void)applicationResume:(struct __GSEvent *)fp8;
{
	NSLog(@"MobileTwitterrificApp: applicationResume");
}

- (void)applicationWillTerminate;
{
	NSLog(@"MobileTwitterrificApp: applicationWillTerminate");
}

- (void)willSleep;
{
	NSLog(@"MobileTwitterrificApp: willSleep");
}

#pragma mark IFTwitterConnection callbacks

- (void)twitterAuthenticate:(id)object
{
	NSLog(@"MobileTwitterrificApp: twitterAuthenticate: object = %@", [object description]);
	
	// let the connection use the saved passwords the first time
	if (!firstLogin && [object isKindOfClass:[IFTwitterConnection class]])
	{
		[[(IFTwitterConnection *)object connection] cancel];
		NSLog(@"MobileTwitterrificApp: twitterAuthenticate: invalid username or password. giving up.");
	}
	firstLogin = NO;
    
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

- (void)twitterStatusComplete:(id)object
{
	NSLog(@"MobileTwitterrificApp: twitterStatusComplete: object = %@", [object description]);

	if ([object didSucceed])
	{
		NSData *downloadData = [object downloadData];
		if (downloadData)
		{
			// build an XML document with the data we have received over the connection
			NSError *error = nil;
/*
NOTE: The wacky instantiation of NSXMLDocument is to work around a problem with the
ARM linker. For some reason, it does not see the NSXMLDocument symbol that is defined
in the OfficeImport framework. So we cheat and resolve the symbol at runtime.

Props to Lucas Newman for figuring out this workaround.
*/
			//NSXMLDocument *document = [[[NSXMLDocument alloc] initWithData:downloadData options:NSXMLNodeOptionsNone error:&error] autorelease];
			NSXMLDocument *document = [[[NSClassFromString(@"NSXMLDocument") alloc] initWithData:downloadData options:NSXMLNodeOptionsNone error:&error] autorelease];
			
			NSString *rootElementName = [[document rootElement] name];
			//NSLog(@"MobileTwitterrificApp: twitterStatusComplete: rootElementName = %@", rootElementName);
			
			if ([rootElementName isEqualToString:@"statuses"])
			{
				// xml document contains either a friends or public list of recent updates, so add tweet controllers
				[self parseXMLDocument:document ofType:[object type]];
			}
			else
			{
				//[[NSAlert alertWithMessageText:NSLocalizedString(@"NoTweets", nil) defaultButton:NSLocalizedString(@"OK", nil) alternateButton:nil otherButton:nil informativeTextWithFormat:NSLocalizedString(@"NoTweetsText", nil)] runModal];
			}
		}
	}
	else
	{
		NSLog(@"MobileTwitterrificApp: twitterStatusComplete: errorType = %@, error = %@", [object errorType], [object error]);
		//[self processConnectionFailure:[object errorType] withError:[object error]];
	}
}

#pragma mark UINavigationBar delegate

- (void)navigationBar:(UINavigationBar*)navbar buttonClicked:(int)button 
{
	NSLog(@"MobileTwitterrificApp: navigationBar:buttonClicked: button = %d", button);
	switch (button) 
	{
	case 0: 
		[preferencesController showPreferences]; 
		break;
	case 1:
		//[self refresh];
		[inputController showInput];
		break;
	}
}

#pragma mark UIButtonBar delegate

- (void)buttonBar:(UIButtonBar*)buttonBar buttonClicked:(int)button 
{
	NSLog(@"MobileTwitterrificApp: buttonBar:buttonClicked: button = %d", button);
}

- (void)buttonAction:(id)sender
{
	NSLog(@"MobileTwitterrificApp: buttonAction: sender = %@", sender);
}

@end