//
//  MobileTwitterrificApp.m
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 8/17/07.
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "IFTwitterTimelineConnection.h"
#import "IFTweetModel.h"
#import "IFAvatarModel.h"
#import "IFTweetTable.h"

@class IFPreferencesController;
@class IFTweetController;
@class IFSoundController;
@class IFInputController;

@interface MobileTwitterrificApp : UIApplication
{
	// network connections
	BOOL firstLogin;
	IFTwitterTimelineConnection *timelineConnection;

	// timers
	NSTimer *refreshTimer;

	// models
	IFTweetModel *_tweetModel;
	
	// user interface
	IFTweetTable *table;
	UIWindow *_mainWindow;
	
	// preferences
	IFPreferencesController *preferencesController;
  
	// tweets
	IFTweetController *tweetController;
	
	// sounds
	IFSoundController *soundController;

	// keyboard
	IFInputController *inputController;
}

- (IFTweetModel *)tweetModel;

- (UIWindow *)mainWindow;
- (void)setMainWindow:(UIWindow *)newMainWindow;

@end
