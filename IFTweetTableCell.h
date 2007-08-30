//
//  IFTweetTableCell.h
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 8/25/07.
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <UIKit/UITextView.h>

@interface IFTweetTableCell : UITableCell
{
	UITextLabel *_userNameLabel;
	UITextLabel *_textLabel;
#if 0
    UIImageView *_avatarImageView;
	
#else
	UITextView *_avatarTextView;
	
#endif
//	UIPushButton *_detailButton;
	
	NSDictionary *_content;
}

- (void)setContent:(NSDictionary *)newContent;
//- (void)setAvatarImage:(UIImage *)newImage;

@end
