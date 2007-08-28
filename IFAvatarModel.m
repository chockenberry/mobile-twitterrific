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

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		_avatars = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[_avatars release];
	
	[super dealloc];
}

- (UIImage *)avatarForScreenName:(NSString *)screenName fromURL:(NSURL *)url
{
	NSLog(@"IFAvatarModel: avatarForScreenName:fromURL: screenName = %@, url = %@", screenName, [url resourceSpecifier]);

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
#endif
}


@end
