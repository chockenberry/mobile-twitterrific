//
//  IFTwitterrificToolbar.h
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 8/29/07.
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IFTwitterrificToolbar : UIView
{
	UIPushButton *_refreshButton;
	UIPushButton *_postButton;
	UIPushButton *_replyButton;
	UIPushButton *_detailButton;
	UIPushButton *_configureButton;
	
	id _delegate;
}

- (void)setDelegate:(id)object;
- (id)delegate;

@end
