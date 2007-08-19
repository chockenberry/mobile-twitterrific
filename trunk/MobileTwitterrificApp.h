//
//  MobileTwitterrificApp.m
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 8/17/07.
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "IFTwitterTimelineConnection.h"

@interface MobileTwitterrificApp : UIApplication
{
	// network connections
	IFTwitterTimelineConnection *timelineConnection;

	// timers
	NSTimer *refreshTimer;

	// user interface
	NSMutableArray *tweets;
	NSMutableArray *rowCells;
	UITableCell *tableCell;
	UITable *table;
}
@end
