//
//  NSDate-Relative.m
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 9/6/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "NSDate-Relative.h"


@implementation NSDate(Relative)

- (NSString *)relativeDate
{
#if 0
	return @"N/A";
#else
	NSTimeInterval timeSinceNow = fabsf([self timeIntervalSinceNow]);
	
	NSTimeInterval delta = timeSinceNow;

	if (delta < 60.0)
	{
		if (roundf(delta) == 0.0)
		{
			return NSLocalizedString(@"JustNow", nil);
		}
		else if (roundf(delta) == 1.0)
		{
			return [NSString stringWithFormat:NSLocalizedString(@"Second", nil), delta];
		}
		else
		{
			return [NSString stringWithFormat:NSLocalizedString(@"Seconds", nil), delta];
		}
	}
	
	delta = delta / 60.0;
	if (delta < 60.0)
	{
		if (roundf(delta) == 1.0)
		{
			return [NSString stringWithFormat:NSLocalizedString(@"Minute", nil), delta];
		}
		else
		{
			return [NSString stringWithFormat:NSLocalizedString(@"Minutes", nil), delta];
		}
	}

	delta = delta / 60.0;
	if (delta < 24.0)
	{
		if (roundf(delta) == 1.0)
		{
			return [NSString stringWithFormat:NSLocalizedString(@"Hour", nil), delta];
		}
		else
		{
			return [NSString stringWithFormat:NSLocalizedString(@"Hours", nil), delta];
		}
	}

	delta = delta / 24.0;
	if (delta < 7.0)
	{
		if (roundf(delta) == 1.0)
		{
			return [NSString stringWithFormat:NSLocalizedString(@"Day", nil), delta];
		}
		else
		{
			return [NSString stringWithFormat:NSLocalizedString(@"Days", nil), delta];
		}
	}

	delta = delta / 7.0;
	if (roundf(delta) == 1.0)
	{
		return [NSString stringWithFormat:NSLocalizedString(@"Week", nil), delta];
	}
	else
	{
		return [NSString stringWithFormat:NSLocalizedString(@"Weeks", nil), delta];
	}
#endif
}


@end
