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

#import <GraphicsServices/GraphicsServices.h>

#import <UIKit/UIView-Geometry.h>

//#import <LayerKit/LayerKit.h>

//#import <WebCore/WebFontCache.h>
//#import <AppKit/NSFontManager.h>
//#import <UIKit/NSString-UIStringDrawing.h>

#import "IFPreferencesController.h"
#import "IFTweetController.h"
#import "IFTweetModel.h"
#import "IFAvatarModel.h"
#import "IFSoundController.h"
#import "IFInputController.h"

#import "IFTweetTable.h"
#import "IFTweetTableCell.h"
#import "IFTwitterrificToolbar.h"

#import "UIView-Color.h"

#import "MobileTwitterrificApp.h"

#import "IFUIKitAdditions.h"

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


#pragma mark UITable delegate, data source, and actions

- (int) numberOfRowsInTable: (UITable *)table
{
	return [[self tweetModel] tweetCount];
}

- (float)table:(UITable *)table heightForRow:(int)row
{
#if 1
	struct CGSize size;

	NSDictionary *tweet = [[self tweetModel] tweetAtIndex:row];

	NSString *text = [tweet valueForKey:@"text"];

/*
NOTE: Calling methods in the NSString-UIStringDrawing category causes segmentation faults.
May be an issue with the toolchain, I don't know. Calculating the size based on the
length of the line does not take into account differing line lengths due to font pitch.
*/
#if 1
	UITextLabel *label = [[[UITextLabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f)] autorelease];
	[label setWrapsText:YES];
//	struct __GSFont *labelFont = [NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:0 size:16.0f];
	GSFontRef labelFont = GSFontCreateWithName("Helvetica", 0, 16.0f);
	[label setFont:labelFont];
	CFRelease(labelFont);
	[label setText:text];

	[label sizeToFit];
	struct CGRect frame = [label frame];
	size.width = 258.0f;
	float numberOfLines = ceil(frame.size.width / size.width);
	size.height = frame.size.height * numberOfLines;
#else
	struct __GSFont *textFont = [NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:0 size:16.0f];
//	struct CGSize size = [text sizeInRect:[_textLabel bounds] withFont:textFont];
//	struct CGSize size = [@"This is a test of the emergency broadcasting system" sizeWithFont:textFont forWidth:260.0f ellipsis:YES];
	size = [text sizeWithFont:textFont forWidth:258.0f ellipsis:YES];

	NSLog(@"IFTweetTableCell: setContent: size = %f, %f", size.width, size.height);
#endif

	size.height += 24.0f;
	if (size.height < 60.0f)
	{
		size.height = 60.0f;
	}
	
	return size.height;
#else
	return 120.0f;
#endif
}

- (UITableCell *)table:(UITable *)table cellForRow:(int)row column:(int)column
{
	//NSLog(@"MobileTwitterrificApp: table:cellForRow:column: row = %d, column = %d", row, column);

	NSDictionary *tweet = [[self tweetModel] tweetAtIndex:row];

/*
NOTE: We build table cells on an as needed basis. This lowers the memory footprint of
the application and provides adequate performance while scrolling.
*/
	IFTweetTableCell *tweetTableCell = [[[IFTweetTableCell alloc] init] autorelease];
	[tweetTableCell setContent:tweet];

	return tweetTableCell;
}

/*
NOTE: Not sure how this works yet (only know that it gets called if setReusesTableCells:YES
is called. It might be useful to recycle cell objects, so we'll leave it commented out for now.

- (UITableCell *)table:(UITable *)tab cellForRow:(int)row column:(int)column reusing:(id)cell
{
	NSLog(@"MobileTwitterrificApp: table:cellForRow:column: row = %d, column = %d, reusing = %@", row, column, cell);
	return [self table:tab cellForRow:row column:column];
}
*/

- (void)tableRowSelected:(NSNotification *)aNotification
{
	IFTweetModel *tweetModel = [self tweetModel];
	[tweetModel selectTweetWithIndex:[table selectedRow]];

	// save the selected id
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSDictionary *selectedTweet = [tweetModel selectedTweet];
	[userDefaults setObject:[selectedTweet objectForKey:@"id"] forKey:@"selectedId"];
}


#pragma mark User interface

- (void)adjustTableRowSelection
{
	IFTweetModel *tweetModel = [self tweetModel];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

	// adjust the selected row using the selected id
	NSString *selectedId = [userDefaults stringForKey:@"selectedId"];
	[tweetModel selectTweetWithId:selectedId];
	int selectionIndex = [tweetModel selectionIndex];
	if (selectionIndex < 0)
	{
		// there is no selected id, so select the first one
		selectionIndex = 0;
	}
	[table selectRow:selectionIndex byExtendingSelection:NO];
	[table scrollRowToVisible:selectionIndex];
}

- (void)parseXMLDocument:(NSXMLDocument *)document ofType:(NSString *)type
{
	IFTweetModel *tweetModel = [self tweetModel];

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
					}
					else if ([userChildName isEqualToString:@"url"])
					{
						[content setValue:[userChildNode stringValue] forKey:@"userUrl"];
					}
				}
			}
			
		}
		
		//NSLog(@"MobileTwitterrificApp: parseXMLDocument: content id = %@, type = %@", [content objectForKey:@"id"], [content objectForKey:@"type"]);

		BOOL tweetWasAdded = [tweetModel addTweet:content];
		if (tweetWasAdded)
		{			
			addedNewContent = YES;
			tweetCount += 1;
		}
		
		tweetFeedCount += 1;
	}	
	
	NSLog(@"MobileTwitterrificApp: parseXMLDocument: received %d tweets", tweetFeedCount);

	if (addedNewContent)
	{
		NSLog(@"MobileTwitterrificApp: parseXMLDocument: created %d tweets", tweetCount);
		
		[table reloadData];
		[self adjustTableRowSelection];
		
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		BOOL notify = [userDefaults boolForKey:@"notify"];
		if (notify)
		{
			[soundController playNotification];
		}
		
/*
NOTE: This is mainly here for debugging purposes -- when running from the command line,
the applicationWillSuspend method doesn't get called when Control-C is used to kill the
process.
*/
#if 1
		[userDefaults setObject:[[self tweetModel] tweets] forKey:@"tweets"];
		[userDefaults synchronize];
		//NSLog(@"MobileTwitterrificApp: parseXMLDocument: persisted %d tweets", [[userDefaults objectForKey:@"tweets"] count]);
#endif
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
	
	UIWindow *window = [[UIWindow alloc] initWithContentRect:[UIHardware fullScreenApplicationContentRect]];

	UIView *mainView = [[UIView alloc] initWithFrame:contentRect];

	// create a background image
	UIImageView *background = [[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, contentRect.size.width, contentRect.size.height)] autorelease];
	[background setImage:[UIImage defaultDesktopImage]];
	[mainView addSubview:background];

	// create a table with one column whose size fits the entire screen
	table = [[[IFTweetTable alloc] initWithFrame:CGRectMake(0.0f, 0.0f, contentRect.size.width, contentRect.size.height - 44.0f)] autorelease];
	UITableColumn *tableColumn = [[UITableColumn alloc] initWithTitle:@"Twitterrific" identifier:@"twitterrific" width:contentRect.size.width];
	[table addTableColumn:tableColumn];
	[table setDataSource:self];
	[table setDelegate:self];
	[table setRowHeight:102.0f];
	[table setBackgroundColor:[UIView colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f]];
//	[table setBackgroundColor:[UIView colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f]];
	[table setScrollerIndicatorStyle:kUIScrollerIndicatorWhite];
	[mainView addSubview:table];

	// create a toolbar that overlays the table
	IFTwitterrificToolbar *toolbar = [[[IFTwitterrificToolbar alloc] initWithFrame:CGRectMake(0.0f, contentRect.size.height - 44.0f, contentRect.size.width, 44.0f)] autorelease];
	[toolbar setDelegate:self];
	[mainView addSubview:toolbar];

	// setup the window
	[window setContentView:mainView];
	[self setMainWindow:window];

	[window orderFront:self];
	[window makeKey:self];
	[window _setHidden:NO];

#if 0
	LKTransform sublayerTransform = LKTransformIdentity;
	sublayerTransform.m34 = 1.0 / -500.0;
	[[[mainView superview] _layer] setSublayerTransform:sublayerTransform];
	[(LKLayer *)[mainView _layer] setTransform:LKTransformMakeRotation(M_PI / 4, 0.5, -1, 0)];
//	[(LKLayer *)[mainView _layer] setTransform:LKTransformMakeRotation(M_PI / 4, 0, -1, 0)];
#endif
	
	// spring into action
	[table reloadData];
	[self adjustTableRowSelection];
}

#pragma mark Timers

- (void)refresh
{
	[timelineConnection refresh];
	[self setStatusBarShowsProgress:YES];
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
	
	if (([login length] > 0) && ([password length] > 0))
	{
		[timelineConnection setLogin:login];
		[timelineConnection setPassword:password];
	}
	else
	{
		[timelineConnection setLogin:nil];
		[timelineConnection setPassword:nil];
	}
	firstLogin = YES;
}

- (void)updateTweetSelection
{
	int newIndex = [[self tweetModel] selectionIndex];
	//NSLog(@"MobileTwitterrificApp: updateTweetSelection: new index = %d", newIndex);
	[table selectRow:newIndex byExtendingSelection:NO];
}	

- (void)setupNotifications
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePreferences) name:PREFERENCES_CHANGED object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTweetSelection) name:TWEET_SELECTION_CHANGED object:nil];
}


#pragma mark Models

- (void)setupModels
{
	// create a model for managing the tweets
	_tweetModel = [[IFTweetModel alloc] init];

	// get the tweets we saved when we last quit
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSArray *tweets = [userDefaults objectForKey:@"tweets"];
	//NSLog(@"MobileTwitterrificApp: setupModels: tweets = %@", tweets);
	if (tweets)
	{
		NSLog(@"MobileTwitterrificApp: setupModels: loading %d tweets", [tweets count]);
		[[self tweetModel] setTweets:tweets];
	}
}

#pragma mark UIApplication delegate

/*
+ (BOOL)shouldMakeUIForDefaultPNG
{
	return YES;
}
*/

- (void)applicationDidFinishLaunching:(id)unused
{
	NSLog(@"MobileTwitterrificApp: applicationDidFinishLaunching: unused = %@", [unused description]);
	
	NSLog(@"default image = %@", [self createApplicationDefaultPNG]);
	
	[self setupModels];
	
	[self setupUserInterface];
	[self setupNotifications];
	
	[self updatePreferences];
	
	[self refresh];
}

/*
NOTE: Always called, regardless of whether the application can handle suspended operation
or not.
*/
- (void)applicationWillSuspend;
{
	// save our current list of tweets
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:[[self tweetModel] tweets] forKey:@"tweets"];
	[userDefaults synchronize];
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

	[self setStatusBarShowsProgress:NO];

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
		[self refresh];
		//[inputController showInput];
		break;
	}
}

#pragma mark IFTwitterrificToolbar delegate

- (void)refreshPressed
{
	NSLog(@"MobileTwitterrificApp: refreshPressed");
	[self refresh];
}

- (void)postPressed
{
	NSLog(@"MobileTwitterrificApp: postPressed");
	[inputController showInput];
}

- (void)replyPressed
{
	NSLog(@"MobileTwitterrificApp: replyPressed");
	[inputController showInput];
}

- (void)messagePressed
{
	NSLog(@"MobileTwitterrificApp: messagePressed");
	[inputController showInput];
//	[self openURL:[NSURL URLWithString:@"http://iconfactory.com"]];
}

- (void)detailPressed
{
	NSLog(@"MobileTwitterrificApp: detailPressed");
	[tweetController showTweet];
}

- (void)configurePressed
{
	NSLog(@"MobileTwitterrificApp: configurePressed");
	[preferencesController showPreferences];
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

#pragma mark UIView delegate

- (double)viewDoubleTapDelay:(id)view
{
	NSLog(@"MobileTwitterrificApp: viewDoubleTapDelay: view = %@", view);
	
	return (0.1);
}

- (void)view:(id)view handleTapWithCount:(int)count event:(struct __GSEvent *)event
{
	NSLog(@"MobileTwitterrificApp: view:handleTapWithCount:event: view = %@, count = %d", view, count);
}

/*
#pragma mark HACKING AWAY AT THE DELEGATE

- (BOOL)respondsToSelector:(SEL)aSelector
{
	//NSLog(@"MobileTwitterrificApp: respondsToSelector: selector = %@", NSStringFromSelector(aSelector));
	return [super respondsToSelector:aSelector];
}
*/

@end
