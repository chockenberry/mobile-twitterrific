//
//  IFSoundController.m
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 8/23/07.
//  Derived from Jonathan Saggau's Pong application
//  http://www.jonathansaggau.com/blog/2007/08/iphone_native_pong_application.html
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//

#import "IFSoundController.h"

#import <Celestial/AVItem.h>
#import <Celestial/AVController.h>
#import <Celestial/AVQueue.h>

@interface IFSoundController (Private)

-(void)play:(AVItem *)item;

@end

@implementation IFSoundController

- (id)init
{
	self = [super init];
	if (self)
	{
		NSError *err;
		NSString *path = [[NSBundle mainBundle] pathForResource:@"notify" ofType:@"wav" inDirectory:@"/"];
		notify = [[AVItem alloc] initWithPath:path error:&err];
		if (err)
		{
			NSLog(@"IFSoundController: init: Could not initialize AVItem, error = %@", err); 
			notify = nil;
		}
		else
		{
			controller = [[AVController alloc] init];
			[controller setDelegate:self];
			
			queue = [[AVQueue alloc] init];
			[queue appendItem:notify error:&err];
			if (err)
			{
				NSLog(@"IFSoundController: init: Could not initialize AVQueue, error = %@", err);
				[notify release];
				notify = nil;
				[queue release];
				queue = nil;
			}
		}
	}

	return self;
}

- (void)dealloc
{
	[notify release];
	notify = nil;

	[queue release];
	queue = nil;

	[controller release];
	controller = nil;

	[super dealloc];
}



-(void)playNotification
{
	if (notify)
	{
		[self play:notify];
	}
}

-(void)play:(AVItem *)item;
{
	[controller setCurrentItem:item];

	// play immediately

	[controller setCurrentTime:(double)0.0];

	//should probably check this eventually, too.
	//- (BOOL)isCurrentItemReady;

	NSError *err;
	[controller play:&err];
	if (err)
	{
		NSLog(@"IFSoundController: init: Could not play AVController, error = %@", err);
	}
}

-(void)stop;
{
	[controller pause];
}

@end



