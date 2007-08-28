//
//  IFTestDictionary.m
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 8/24/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "IFTestDictionary.h"


@implementation IFTestDictionary

- (id)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if (self)
	{
		NSLog(@"IFTestDictionary: initWithDictionary: dictionary = %@", dictionary);
		_dictionary = [dictionary retain];
	}
	return self;
}

- (void)dealloc
{
	NSLog(@"IFTestDictionary: dealloc");
	[_dictionary release];
	[super dealloc];
}

- (id)objectForKey:(id)key
{
	id value = [_dictionary objectForKey:key];
	NSLog(@"IFTestDictionary: objectForKey: key = %@, value = %@", key, value);
	return value;
}

+ (void)setObject:(id)anObject forKey:(id)aKey
{
	NSLog(@"IFTestDictionary: + setObject:forKey: value = %@ (%@), key = %@", anObject, [anObject description], aKey);
}

- (void)setObject:(id)anObject forKey:(id)aKey
{
	NSLog(@"IFTestDictionary: setObject:forKey: value = %@, key = %@", anObject, aKey);
	[_dictionary setObject:anObject forKey:aKey];
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
//	return [IFTestDictionary mutableCopyWithZone:zone];
	return [[IFTestDictionary allocWithZone:zone] initWithDictionary:[NSMutableDictionary dictionaryWithDictionary:_dictionary]];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
	NSLog(@"IFTestDictionary: request for selector: %@", NSStringFromSelector(aSelector));
	return [super respondsToSelector:aSelector];
}


@end
