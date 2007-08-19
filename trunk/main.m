#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MobileTwitterrificApp.h"

int main(int argc, char *argv[])
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int ret = UIApplicationMain(argc, argv, [MobileTwitterrificApp class]);
	[pool release];
	return ret;
}
