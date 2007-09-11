//
//  IFTwitterUpdateConnection.m
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 7/30/07.
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//

#import "IFTwitterUpdateConnection.h"

@implementation IFTwitterUpdateConnection

- (NSString *)type
{
	return @"update";
}

- (NSString *)urlEncodeValue:(NSString *)string
{
	NSString *result = (NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR("?=&+{}<>;"), kCFStringEncodingUTF8);
	return [result autorelease];
}

// API documentation: http://groups.google.com/group/twitter-development-talk/web/api-documentation

- (void)post:(NSString *)message
{
	if (_connectionLogging)
	{
		NSLog(@"IFTwitterUpdateConnection: post: message = %@", message);
	}
	
	if (! [self connection])
	{
		NSString *baseUrl = @"twitter.com";
		
		NSString *urlString = nil;
		if ([self login] && [self password])
		{
			NSString *encodedLogin = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)[self login], NULL, CFSTR("@"), kCFStringEncodingUTF8);
			[encodedLogin autorelease];
			NSString *encodedPassword = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)[self password], NULL, CFSTR("@"), kCFStringEncodingUTF8);
			[encodedPassword autorelease];

			urlString = [NSString stringWithFormat:@"http://%@:%@@%@/statuses/update.xml", encodedLogin, encodedPassword, baseUrl];
		}
		else
		{
			urlString = [NSString stringWithFormat:@"http://:@%@/statuses/update.xml", baseUrl];
		}
		if (_connectionLogging)
		{
			NSLog(@"IFTwitterUpdateConnection: postUpdate: urlString = %@", urlString);
		}

		NSString *post = [NSString stringWithFormat:@"source=twitterrific&status=%@", [self urlEncodeValue:message]];
		NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
		NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];

		NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
		[request setURL:[NSURL URLWithString:urlString]];
		[request setHTTPMethod:@"POST"];
		[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
		[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
		[request setHTTPBody:postData];
		[request setCachePolicy:NSURLRequestReloadIgnoringCacheData];

		BOOL clearCookie = NO;
		if (clearCookie)
		{
			// This is a quick and dirty way to remove the cookie from the request -- by default, the request picks up the same cookie that's used
			// by the browser. At one point, the caused problems for Twitter, so we're leaving this code here in case it happens again. To enable
			// cookie clearing you'd use the command line: defaults write com.iconfactory.Twitterrific clearCookie -bool true
			[request setValue:@"" forHTTPHeaderField:@"Cookie"];
			//NSLog(@"IFMainController: postUpdate: cleared cookie"); 
		}

		[self _setError:nil];
		[self _setErrorType:nil];	
		[self _setConnection:[NSURLConnection connectionWithRequest:request delegate:self]];

		if (_connectionLogging)
		{
			NSLog(@"IFTwitterUpdateConnection: post: connection created");
		}		
	}
}

@end
