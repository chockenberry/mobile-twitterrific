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
