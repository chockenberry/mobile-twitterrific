//
//  IFSoundController.h
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 8/23/07.
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AVItem;
@class AVController;
@class AVQueue;

@interface IFSoundController : NSObject
{
	AVItem *notify;
	AVQueue *queue;
	AVController *controller;
}

-(void)playNotification;

-(void)stop;

@end