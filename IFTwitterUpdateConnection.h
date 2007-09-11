//
//  IFTwitterUpdateConnection.h
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 7/30/07.
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "IFTwitterConnection.h"

@interface IFTwitterUpdateConnection : IFTwitterConnection

- (void)post:(NSString *)message;

@end
