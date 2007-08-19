
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

#import "MobileTwitterrificApp.h"

@implementation MobileTwitterrificApp

/*
TODO: Figure out how to manage user preferences. NSUserDefaults may work.
*/

/*
TODO: Figure out how to handle errors and/or alerts. UIAlertSheet looks promising.
*/

#pragma mark Instance management

- (id)init
{
	self = [super init];
	if (self)
	{
		timelineConnection = [[IFTwitterTimelineConnection alloc] initWithLogin:nil password:nil delegate:self completedCallbackSelector:@selector(twitterStatusComplete:) authenticationCallbackSelector:@selector(twitterAuthenticate:)];
	}
	
	return self;
}

- (void)dealloc
{
	[timelineConnection release];

	[super dealloc];
}

#pragma mark UITable delegate and data source

- (int) numberOfRowsInTable: (UITable *)table
{
	return [rowCells count];
}

- (UITableCell *)table:(UITable *)table cellForRow:(int)row column:(int)column
{
	return [rowCells objectAtIndex:row];
}

- (UITableCell *)table:(UITable *)table cellForRow:(int)row column:(int)col reusing:(BOOL)reusing
{
	return [rowCells objectAtIndex:row];
}

#pragma mark User interface

- (int)indexForId:(NSString *)id
{
	BOOL idExists = NO;
	int index = 0;
	NSEnumerator *tweetEnumerator = [tweets objectEnumerator];
	NSDictionary *tweet;
	while ((tweet = [tweetEnumerator nextObject]))
	{
		if ([id isEqualToString:[tweet objectForKey:@"id"]])
		{
			idExists = YES;
			break;
		}
		index += 1;
	}

	return (idExists ? index : -1);
}

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
		
		NSString *id = [content objectForKey:@"id"];
		if (id)
		{
			//NSLog(@"MobileTwitterrificApp: parseXMLDocument: content id = %@, type = %@", id, [content objectForKey:@"type"]);

			// check to see if id already exists
			int index = [self indexForId:id];
			if (index == -1)
			{
				// add the content to the user interface
				UIImageAndTextTableCell *imageAndTextTableCell = [[UIImageAndTextTableCell alloc] init];
				[imageAndTextTableCell setTitle:[content objectForKey:@"userName"]];
				[rowCells addObject:imageAndTextTableCell];
		
				// add the content to the model
				[tweets addObject:content];
				
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
	}
}

- (void)setupUserInterface
{
	rowCells = [[NSMutableArray alloc] init];

	UIWindow *window = [[UIWindow alloc] initWithContentRect: [UIHardware fullScreenApplicationContentRect]];

/*
	UIPushButton *button = [[UIThreePartButton alloc] initWithTitle:@"Navigation"];
	tableCell = [[UITableCell alloc] init];
	[tableCell addSubview:button];
	[button sizeToFit];
*/
	table = [[UITable alloc] initWithFrame:CGRectMake(0.0f, 48.0f, 320.0f, 480.0f - 16.0f - 32.0f)];
	UITableColumn *tableColumn = [[UITableColumn alloc] initWithTitle:@"Twitterrific" identifier:@"twitterrific" width: 320.0f];

	[window orderFront:self];
	[window makeKey:self];
	[window _setHidden:NO];

	[table addTableColumn:tableColumn]; 
	[table setDataSource:self];
	[table setDelegate:self];
	[table reloadData];

	UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 48.0f)];
	[navigationBar showButtonsWithLeftTitle:@"Setup" rightTitle:@"Done" leftBack:YES];
	[navigationBar setBarStyle:0];

	struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin.x = rect.origin.y = 0.0f;
	UIView *mainView = [[UIView alloc] initWithFrame:rect];
	[mainView addSubview:navigationBar]; 
	[mainView addSubview:table]; 

	[window setContentView:mainView]; 
}

#pragma mark Timers

- (void)refresh
{
	[timelineConnection refresh];
}

- (void)startRefreshTimer
{
	// if necessary, stop the current timer
	if (refreshTimer)
	{
		[refreshTimer invalidate];
		[refreshTimer release];
		refreshTimer = nil;
	}

	refreshTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
	[refreshTimer retain];
}

#pragma mark Application delegate

- (void)applicationDidFinishLaunching:(id)unused
{
	NSLog(@"MobileTwitterrificApp: applicationDidFinishLaunching: unused = %@", [unused description]);
	
	[self setupUserInterface];
	
	[self startRefreshTimer];
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
			NSLog(@"MobileTwitterrificApp: twitterStatusComplete: rootElementName = %@", rootElementName);
			
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
		//[self processConnectionFailure:[object errorType] withError:[object error]];
	}
}

@end
