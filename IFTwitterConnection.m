//
//  IFTwitterConnection.m
//  Twitterrific
//
//  Created by Craig Hockenberry on 7/30/07.
//  Loosely based on BSTwitterAPICall from http://inessential.com/?comments=1&postid=3407
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//

#import "IFTwitterConnection.h"

@interface IFTwitterConnection (Private)
- (void)_setDidSucceed:(BOOL)flag;
- (void)_setDownloadData:(NSData *)data;
- (void)_notifyDelegateOfCompletion;
@end


@implementation IFTwitterConnection

#pragma mark Instance management

- (id)initWithLogin:(NSString *)login password:(NSString *)password delegate:(id)delegate completedCallbackSelector:(SEL)completedSelector authenticationCallbackSelector:(SEL)authenticationSelector
{
	if (! [super init])
	{
		return nil;
	}
	
	_login = [login copy];
	_password = [password copy];
	_delegate = delegate;
	_completedCallbackSelector = completedSelector;
	_authenticationCallbackSelector = authenticationSelector;

	_firstLogin = YES;
	_responseData = nil;
	_didSucceed = NO;
	_downloadData = nil;
	_error = nil;
	_errorType = nil;
	
	_connectionLogging = NO; // YES;

	return self;
}

- (void)dealloc
{
	[_login release];
	[_password release];
	[_response release];
	[_responseData release];
	[_connection release];
	[_downloadData release];
	[_error release];
	[_errorType release];

	[super dealloc];
}

#pragma mark Accessors

- (void)setLogin:(NSString *)login
{
	if (login != _login)
	{
		[_login release];
		_login = [login retain];
	}
}

- (NSString *)login
{
	return _login;
}

- (void)setPassword:(NSString *)password
{
	if (password != _password)
	{
		[_password release];
		_password = [password retain];
	}
}

- (NSString *)password
{
	return _password;
}

- (void)_setDidSucceed:(BOOL)flag
{
	_didSucceed = flag;
}

- (BOOL)didSucceed
{
	return _didSucceed;
}

- (void)_setDownloadData:(NSData *)data
{
	[_downloadData autorelease];
	_downloadData = [data retain];
}

- (NSData *)downloadData
{
	return _downloadData;
}

- (void)_setConnection:(NSURLConnection *)connection
{
	[_connection autorelease];
	_connection = [connection retain];
}

- (NSURLConnection *)connection
{
	return _connection;
}

- (void)_setResponse:(NSURLResponse *)response
{
	[_response autorelease];
	_response = [response retain];
}

- (NSURLResponse *)response
{
	return _response;
}

- (void)_setError:(NSError *)error
{
	[_error autorelease];
	_error = [error retain];
}

- (NSError *)error
{
	return _error;
}

- (void)_setErrorType:(NSString *)errorType
{
	if (errorType != _errorType)
	{
		[_errorType release];
		_errorType = [errorType retain];
	}
}

- (NSString *)errorType
{
	return _errorType;
}

#pragma mark Connection

// subclasses are responsible for initiating the connection using the API documentation at:
// http://groups.google.com/group/twitter-development-talk/web/api-documentation

// subclasses should override this to return a unique type (used to change how the content is rendered)
- (NSString *)type
{
	return @"undefined";
}

- (void)_notifyDelegateOfCompletion
{
	[_delegate performSelector:_completedCallbackSelector withObject:self];
}

#pragma mark NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	if (_connectionLogging)
	{
		NSLog(@"IFTwitterConnection: connection:didReceiveAuthenticationChallenge:");
	}
	
	if (_connectionLogging)
	{
		NSURLProtectionSpace *protectionSpace = [challenge protectionSpace];
		NSLog(@"IFTwitterConnection: connection:didReceiveAuthenticationChallenge: protectionSpace: authenticationMethod = %@, host = %@, port = %d, protocol = %@, isProxy = %d, proxyType = %@, realm = %@, receivesCredentialSecurely = %d", [protectionSpace authenticationMethod], [protectionSpace host], [protectionSpace port], [protectionSpace protocol], [protectionSpace isProxy], [protectionSpace proxyType], [protectionSpace realm], [protectionSpace receivesCredentialSecurely]);
	}

	[_delegate performSelector:_authenticationCallbackSelector withObject:self];
	if (_connectionLogging)
	{
		NSLog(@"IFTwitterConnection: connection:didReceiveAuthenticationChallenge: login = %@, password = %@", [self login], [self password]);
	}
	NSURLCredential *urlCredential = [NSURLCredential credentialWithUser:[self login] password:[self password] persistence:NSURLCredentialPersistenceForSession];
	[[challenge sender] useCredential:urlCredential forAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	if (_connectionLogging)
	{
		NSLog(@"IFTwitterConnection: connection:didReceiveResponse:");
	}
	
	if ([response respondsToSelector:@selector(statusCode)])
	{
		int statusCode = [(NSHTTPURLResponse *)response statusCode];
		// ignore anything that doesn't come back as 200 (OK) -- mainly a 304 (Not Modified) or 400 (Bad Request = Rate limit exceeded)
		if (_connectionLogging)
		{
			NSLog(@"IFTwitterConnection: connection:didReceiveResponse: statusCode = %d", statusCode);
		}
		
		//statusCode = 400;
		
		if (statusCode == 200)
		{
			if (_connectionLogging)
			{
				NSLog(@"IFTwitterConnection: connection:didReceiveResponse: response MIMEType = %@", [response MIMEType]);
			}
			
			if (! [[response MIMEType] isEqualToString:@"application/xml"])
			{
				[self _setErrorType:@"FailedRetrievalInvalidMIMEType"];	
			}
			else
			{
				_responseData = [[NSMutableData alloc] init];
			}
		}
		else
		{
			[self _setError:[NSError errorWithDomain:@"HTTPErrorDomain" code:statusCode userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"HTTP %d response", statusCode] forKey:NSLocalizedDescriptionKey]]];
			[self _setErrorType:@"FailedRetrievalBadStatusCode"];	
		}
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	if (_connectionLogging)
	{
		//NSLog(@"IFTwitterConnection: connection:didReceiveData: length = %d", [data length]);
	}
	
	if (_responseData)
	{
		[_responseData appendData:data];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	if (_connectionLogging)
	{
		NSLog(@"IFTwitterConnection: connectionDidFinishLoading: response length = %d", [_responseData length]);
	}
	
	if ([connection isEqual:[self connection]])
	{
		if (_connectionLogging)
		{
			NSLog(@"IFTwitterConnection: connectionDidFinishLoading: connection cleared");
		}

		[self _setConnection:nil];
	}
	
	if (_responseData)
	{
		[self _setDownloadData:_responseData];
		[self _setDidSucceed:YES];
		
		[_responseData release];
		_responseData = nil;
	}
	else
	{
		[self _setDownloadData:nil];
		[self _setDidSucceed:NO];
	}

	if (_connectionLogging)
	{
		NSLog(@"IFTwitterConnection: connectionDidFinishLoading: didSucceed = %d", [self didSucceed]);
	}
	
	[self _notifyDelegateOfCompletion];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	if (_connectionLogging)
	{
		NSLog(@"IFTwitterConnection: connection:didFailWithError: error = %@", [error description]);
	}
	
	if ([connection isEqual:[self connection]])
	{
		if (_connectionLogging)
		{
			NSLog(@"IFTwitterConnection: didFailWithError: connection cleared");
		}

		[self _setConnection:nil];
	}	

	[self _setError:error];
	[self _setErrorType:@"FailedRetrievalConnectionFailed"];	
	[self _setDownloadData:nil];
	[self _setDidSucceed:NO];

	[_responseData release];
	_responseData = nil;

	[self _notifyDelegateOfCompletion];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
	if (_connectionLogging)
	{
		NSLog(@"IFTwitterConnection: connection:willCacheResponse");
	}
	
	// we don't want the connection to cache the response
	return nil;
}

-(NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse
{
	if (_connectionLogging)
	{
		NSLog(@"IFTwitterConnection: connection:willSendRequest:redirectResponse: request URL = %@, response URL = %@", [[request URL] description], [[redirectResponse URL] description]);
	}
	
	if (redirectResponse)
	{
		// we don't want to redirect if the Twitter API is not available, so cancel the appropriate connection (the redirect
		// is probably to the static maintenance page)
		if ([connection isEqual:[self connection]])
		{
			if (_connectionLogging)
			{
				NSLog(@"IFTwitterConnection: connection:willSendRequest:redirectResponse: connection cleared");
			}
			
			[self _setConnection:nil];
		}

		[self _setDownloadData:nil];
		[self _setDidSucceed:NO];

		[_responseData release];
		_responseData = nil;

		[connection cancel];
		
		[self _notifyDelegateOfCompletion];
		
		return nil;
	}
	else
	{
		// Leopard calls the delegate with a null redirectResponse, so just pass back the request to let the connection continue
		return request;
	}
}

@end
