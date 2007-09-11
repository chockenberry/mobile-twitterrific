//
//  IFTwitterTimelineConnection.m
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 7/30/07.
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//

#import "IFTwitterTimelineConnection.h"

@implementation IFTwitterTimelineConnection

- (NSString *)type
{
	return @"timeline";
}

- (void)refresh
{
	if (_connectionLogging)
	{
		NSLog(@"IFTwitterTimelineConnection: refresh");
	}
	
	if (! [self connection])
	{
		NSString *baseUrl = @"twitter.com";

		NSString *urlString = nil;

		if ([self login] && [self password])
		{
			// read user's timeline
			NSString *encodedLogin = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)[self login], NULL, CFSTR("@"), kCFStringEncodingUTF8);
			[encodedLogin autorelease];
			NSString *encodedPassword = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)[self password], NULL, CFSTR("@"), kCFStringEncodingUTF8);
			[encodedPassword autorelease];

			urlString = [NSString stringWithFormat:@"http://%@:%@@%@/statuses/friends_timeline.xml", encodedLogin, encodedPassword, baseUrl];
		}
		else
		{
			// read public timeline
			urlString = [NSString stringWithFormat:@"http://%@/statuses/public_timeline.xml", baseUrl];
		}
		if (_connectionLogging)
		{
			NSLog(@"IFTwitterTimelineConnection: refresh: urlString = %@", urlString);
		}

		NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
		[request setURL:[NSURL URLWithString:urlString]];
		[request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
		[request setTimeoutInterval:55.0];

		// clear out the session state in the cookie -- if we don't, and the authentication in the URL is invalid, then 
		// the session's authentication will be used and there will be a disconnect between what was in the login/password
		// fields and what's returned by the Twitter API.
		[request setValue:@"" forHTTPHeaderField:@"Cookie"];

		[self _setError:nil];
		[self _setErrorType:nil];	
		[self _setConnection:[NSURLConnection connectionWithRequest:request delegate:self]];

		if (_connectionLogging)
		{
			NSLog(@"IFTwitterTimelineConnection: refresh: connection created");
		}		
	}
}

@end
