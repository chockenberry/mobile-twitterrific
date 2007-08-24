//
//  IFTestDictionary.h
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 8/24/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IFTestDictionary : NSObject {
	NSMutableDictionary *_dictionary;
}

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (id)objectForKey:(id)key;

@end
