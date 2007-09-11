//
//  IFTweetPostView.h
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 9/10/07.
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <UIKit/UITextView.h>
#import <UIKit/UITextLabel.h>

@interface IFTweetPostView : UIView
{
	UITextView *_editingTextView;
	UITextLabel *_counterTextLabel;
}

- (NSString *)message;

@end

/*
@interface IFTweetView : UIView
{
#if 0
	UITextLabel *_userNameLabel;
	UITextLabel *_textLabel;
#else
	UITextView *_tweetTextView;
#endif
	IFURLImageView *_avatarImageView;

	NSDictionary *_content;
}

- (void)setContent:(NSDictionary *)newContent;

@end
*/