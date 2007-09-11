//
//  IFInputController.h
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 8/24/07.
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UITextField.h>
#import <UIKit/UITextView.h>

#import "IFTweetPostView.h"

#import "MobileTwitterrificApp.h"

#import "IFTwitterUpdateConnection.h"

@interface IFInputController : NSObject
{
	MobileTwitterrificApp *controller;

	IFTweetPostView *_tweetPostView;
	IFTwitterUpdateConnection *updateConnection;

	UIView *_oldContentView;
}

- (id)initWithAppController:(MobileTwitterrificApp *)appController;

- (void)showInput;
- (void)hideInput;

// Notifications
//#define TWEET_SELECTION_CHANGED @"IFTweetSelectionChanged"

@end
