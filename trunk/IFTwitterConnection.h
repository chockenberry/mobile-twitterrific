//
//  IFTwitterConnection.h
//  Twitterrific
//
//  Created by Craig Hockenberry on 7/30/07.
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface IFTwitterConnection : NSObject
{
	@private
		// callbacks when loading is complete and when authentication fails
		id _delegate;
		SEL _completedCallbackSelector;
		SEL _authenticationCallbackSelector;
		
		// login and password used for connection
		NSString *_login;
		NSString *_password;
		BOOL _firstLogin;
		
		// connection instances
		NSURLResponse *_response;
		NSMutableData *_responseData;
		NSURLConnection *_connection;
		
		// data from last connection
		BOOL _didSucceed;
		NSData *_downloadData;
		NSError *_error;
		NSString *_errorType;

	@protected
		// debugging
		BOOL _connectionLogging;
}

- (id)initWithLogin:(NSString *)login password:(NSString *)password delegate:(id)delegate completedCallbackSelector:(SEL)completedSelector authenticationCallbackSelector:(SEL)authenticationCallbackSelector;

- (NSString *)type;

- (void)setLogin:(NSString *)login;
- (NSString *)login;
- (void)setPassword:(NSString *)password;
- (NSString *)password;
- (BOOL)didSucceed;
- (NSData *)downloadData;
- (NSURLConnection *)connection;
- (NSURLResponse *)response;
- (NSError *)error;
- (NSString *)errorType;

@end

@interface IFTwitterConnection (Protected)
- (void)_setConnection:(NSURLConnection *)connection;
- (void)_setError:(NSError *)error;
- (void)_setErrorType:(NSString *)errorType;
@end

