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

@interface IFTweetTableCell : UITableCell
{
	UITextLabel *_userNameLabel;
	UITextLabel *_textLabel;
    UIImageView *_avatarImageView;
	NSDictionary *_content;
	
}

- (void)setContent:(NSDictionary *)newContent;

@end
