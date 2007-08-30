//
//  IFAvatarModel.h
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 8/27/07.
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface IFAvatarModel : NSObject
{
	NSMutableArray *_avatars;
	NSMutableDictionary *_cache;
}

+ (IFAvatarModel *)sharedAvatarModel;

- (UIImage *)avatarForScreenName:(NSString *)screenName fromURL:(NSURL *)url;

@end
