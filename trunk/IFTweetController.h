//
//  IFTweetController.h
//  MobileTwitterrific
//
//  Created by Martin Gordon on 8/21/07.
//  Copyright 2007 Martin Gordon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UITextField.h>
#import <UIKit/UITextView.h>

#import "MobileTwitterrificApp.h"


@interface IFTweetController : NSObject
{
	MobileTwitterrificApp *controller;
	UIView *_oldContentView;
	int currentIndex;
}

- (id)initWithAppController:(MobileTwitterrificApp *)appController;

- (void)showTweet:(int)tweetIndex;
- (void)hideTweet;

@end
