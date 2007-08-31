//
//  IFAvatarModel.m
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 8/27/07.
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//

#import "IFAvatarModel.h"


#define MAX_AVATAR_COUNT 10


@implementation IFAvatarModel

#pragma mark Singleton

static IFAvatarModel *avatarModel;

+ (IFAvatarModel *)sharedAvatarModel
{
	NSLog(@"IFAvatarModel: sharedAvatarModel");

//	@synchronized(self)
	{
		if (avatarModel == nil)
		{
			[[self alloc] init]; // assignment not done here
			NSLog(@"IFAvatarModel: sharedAvatarModel: avatarModel = %@", avatarModel);
		}
	}
	
	return avatarModel;
}

+ (id)allocWithZone:(NSZone *)zone
{
//	@synchronized(self)
	{
		if (avatarModel == nil) {
			avatarModel = [super allocWithZone:zone];
			return avatarModel;  // assignment and return on first allocation
		}
	}
	return nil; //on subsequent allocation attempts return nil
}
 
- (id)copyWithZone:(NSZone *)zone
{
	return self;
}
 
- (id)retain
{
	return self;
}
 
- (unsigned)retainCount
{
	return UINT_MAX;  //denotes an object that cannot be released
}
 
- (void)release
{
	//do nothing
}
 
- (id)autorelease
{
	return self;
}


- (id)init
{
	NSLog(@"IFAvatarModel: init");
	self = [super init];
	if (self != nil)
	{
		_avatars = [[NSMutableArray alloc] init];
		_cache = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[_avatars release];
	[_cache release];
	
	[super dealloc];
}

- (UIImage *)avatarForScreenName:(NSString *)screenName fromURL:(NSURL *)url
{
	//NSLog(@"IFAvatarModel: avatarForScreenName:fromURL: screenName = %@, url = %@", screenName, [url resourceSpecifier]);

#if 0
/*
NOTE: Yeah, this could be considered premature optimization. But considering there really
aren't any tools to monitor memory usage, I'm going to guess that managing a bounded collection
of UIImage objects for the avatars is going to be a good idea.
*/

	BOOL avatarFound = NO;
	UIImage *result = nil;
	
	// check for an avatar in the cache
	NSEnumerator *enumerator = [_avatars objectEnumerator];
	NSDictionary *avatar = nil;
	unsigned avatarIndex = 0;
	while ((avatar = [enumerator nextObject]))
	{
		//NSLog(@"IFAvatarModel: avatarForScreenName:fromURL: checking avatar at index = %d, avatar = %@", avatarIndex, avatar);
		NSString *avatarScreenName = [avatar valueForKey:@"screenName"];
		if ([screenName isEqualToString:avatarScreenName])
		{
			// found the avatar in the cache
			result = [avatar valueForKey:@"image"];
			avatarFound = YES;
			NSLog(@"IFAvatarModel: avatarForScreenName:fromURL: found avatar at index = %d", avatarIndex);
			break;
		}
		
		avatarIndex += 1;
	}
	if (avatarFound)
	{
		// found the avatar, so move it to the top of the array (so that the end of the
		// array contains the least recently used avatar)
		if (avatarIndex > 0)
		{
			NSDictionary *movingAvatar = [[_avatars objectAtIndex:avatarIndex] retain];
			NSLog(@"IFAvatarModel: avatarForScreenName:fromURL: moving avatar to index 0 = %@", movingAvatar);			
			[_avatars removeObjectAtIndex:avatarIndex];
			[_avatars insertObject:movingAvatar atIndex:0];
			[movingAvatar release];
		}
	}
	else
	{
		// didn't find an avatar, so add a new one to the cache
		NSError *error = nil;
/*
TODO: Check if options should be set to 2 = NSUncachedRead.
*/
		NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
		if (error)
		{
			NSLog(@"IFAvatarModel: avatarForScreenName:fromURL: error retrieving data: %@", [error localizedFailureReason]);
			result = nil;
		}
		else
		{
			UIImage *image = [[[UIImage alloc] initWithData:data cache:NO] autorelease];
			if ([_avatars count] > MAX_AVATAR_COUNT)
			{
				// make room for the new avatar by removing the least recently used one
				NSLog(@"IFAvatarModel: avatarForScreenName:fromURL: removing least recently used avatar");
				[_avatars removeLastObject];
			}
			NSLog(@"IFAvatarModel: avatarForScreenName:fromURL: creating new avatar");		
			NSDictionary *newAvatar = [NSDictionary dictionaryWithObjectsAndKeys:image, @"image", screenName, @"screenName", nil];
			[_avatars insertObject:newAvatar atIndex:0];
			
			NSLog(@"IFAvatarModel: avatarForScreenName:fromURL: added new avatar = %@", newAvatar);
			
			result = image;
		}
	}
	
	return result;
#else
#if 0
	// use the built-in cache for UIImage
	
	NSError *error = nil;
/*
TODO: Check if options should be set to 2 = NSUncachedRead.
*/
	NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
	if (error)
	{
		NSLog(@"IFAvatarModel: avatarForScreenName:fromURL: error retrieving data: %@", [error localizedFailureReason]);
		return nil;
	}
	else
	{
		UIImage *image = [[[UIImage alloc] initWithData:data cache:YES] autorelease];
		return image;
	}
#else
#if 1
	UIImage *image = [_cache objectForKey:screenName];
	if (! image)
	{
		NSError *error = nil;
		
		NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
		if (error)
		{
			NSLog(@"IFAvatarModel: avatarForScreenName:fromURL: error retrieving data: %@", [error localizedFailureReason]);
			return nil;
		}
		else
		{
			UIImage *image = [[[UIImage alloc] initWithData:data cache:YES] autorelease];
			[_cache setValue:image forKey:screenName];
			
			NSLog(@"IFAvatarModel: avatarForScreenName:fromURL: cached avatar for '%@'", screenName);
			return image;
		}
	}
	NSLog(@"IFAvatarModel: avatarForScreenName:fromURL: found avatar for '%@'", screenName);
	return image;
#else
	return nil;
#endif
#endif
#endif
}

#if 0
#pragma mark NSURLConnection delegate

        _imageURL = [imageURL copy];
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:_imageURL];
        _imageURLConnection = [[NSURLConnection alloc] initWithRequest:imageRequest delegate:self];


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_imageData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [_imageURLConnection release];
    _imageURLConnection = nil;
    
    [_imageData release];
    _imageData = nil;
    [self setImage:nil];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [_imageURLConnection release];
    _imageURLConnection = nil;
    
    UIImage *newImage = [[[UIImage alloc] initWithData:_imageData cache:NO] autorelease];
    [self setImage:newImage];
}

#endif

@end
