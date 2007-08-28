//
//  IFTweetTableCell.m
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 8/25/07.
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <UIKit/UIBezierPath.h>
#import <WebCore/WebFontCache.h>
#import <CoreGraphics/CGGeometry.h>

#import "IFTweetTableCell.h"

@implementation IFTweetTableCell

const float transparentComponents[4] = {0, 0, 0, 0};
const float blackComponents[4] = {0, 0, 0, 1};
const float grayComponents[4] = {0.5, 0.5, 0.5, 1};
const float blueComponents[4] = {0.208, 0.482, 0.859, 1};
const float whiteComponents[4] = {1, 1, 1, 1};

- (id)initWithFrame:(struct CGRect)frame;
{
	struct CGRect contentRect = [UIHardware fullScreenApplicationContentRect];
	contentRect.origin.x = 0.0f;
	contentRect.origin.y = 0.0f;

    self = [super initWithFrame:frame];
    if (self)
	{
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

		_userNameLabel = [[UITextLabel alloc] initWithFrame:CGRectMake(56.0f, 4.0f, contentRect.size.width - 40.0f - 56.0f, 18.0f)];
		[_userNameLabel setWrapsText:NO];
		[_userNameLabel setBackgroundColor:CGColorCreate(colorSpace, transparentComponents)];
		struct __GSFont *userNameFont = [NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:2 size:16.0f];
		[_userNameLabel setFont:userNameFont];
		[self addSubview:_userNameLabel];

		_textLabel = [[UITextLabel alloc] initWithFrame:CGRectMake(56.0f, 18.0f, contentRect.size.width - 40.0f - 56.0f, 70.0f)];
		[_textLabel setWrapsText:YES];
		[_textLabel setBackgroundColor:CGColorCreate(colorSpace, transparentComponents)];
		[_textLabel setEllipsisStyle:2];
		[_textLabel setCentersHorizontally:NO];		
		[self addSubview:_textLabel];

		_avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4.0f, 4.0f, 48.0f, 48.0f)];
		[self addSubview:_avatarImageView];

		CFRelease(colorSpace);
		
		_content = nil;
	}
    return self;
}

- (void)dealloc
{
	[_userNameLabel release];
	_userNameLabel = nil;
	[_textLabel release];
	_textLabel = nil;
	[_avatarImageView release];
	_avatarImageView = nil;
	
	[_content release];
	_content = nil;
	
	[super dealloc];
}

- (void)setContent:(NSDictionary *)newContent
{
    [_content release];
    _content = [newContent retain];
}

enum {
    kUIBezierPathTopLeftCorner = 1,
    kUIBezierPathTopRightCorner = 1 << 1,
    kUIBezierPathBottomLeftCorner = 1 << 2,
    kUIBezierPathBottomRightCorner = 1 << 3,
    kUIBezierPathAllCorners = (kUIBezierPathTopLeftCorner | kUIBezierPathTopRightCorner | kUIBezierPathBottomLeftCorner | kUIBezierPathBottomRightCorner)
};

- (void)drawContentInRect:(struct CGRect)rect selected:(BOOL)selected
{
	//NSLog(@"IFTweetTableCell: drawContentInRect:");
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

#if 0
	if (selected)
	{
		[_userNameLabel setColor:CGColorCreate(colorSpace, whiteComponents)];
		[_textLabel setColor:CGColorCreate(colorSpace, whiteComponents)];
	}
	else
	{
		[_userNameLabel setColor:CGColorCreate(colorSpace, blackComponents)];
		[_textLabel setColor:CGColorCreate(colorSpace, grayComponents)];
	}
#else
	[_userNameLabel setColor:CGColorCreate(colorSpace, whiteComponents)];
	[_textLabel setColor:CGColorCreate(colorSpace, whiteComponents)];
#endif	

	[_userNameLabel setText:[_content objectForKey:@"userName"]];
	[_textLabel setText:[_content objectForKey:@"text"]];
	[_avatarImageView setImage:[_content objectForKey:@"userAvatarImage"]];
	
//	UIBezierPath *path = [UIBezierPath roundedRectBezierPath:rect withRoundedEdges:15];
	
	struct CGRect newRect = CGRectInset(rect, 0.0, 0.0);
//	struct CGRect newRect = GCRectMake(rect, 10.0, 10.0);
/*
NOTE: Corners are determined by OR-ing the following values. Use 15 for all four corners:
	1 = upper-left corner
	2 = upper-right corner
	4 = lower-left corner
	8 = lower-right corner
Radius is in number of pixels.
*/
	UIBezierPath *path = [UIBezierPath roundedRectBezierPath:newRect withRoundedCorners:15 withCornerRadius:8.0];

	const float backgroundComponents[4] = {0, 0, 0, 0.80};
	CGContextSetFillColor(UICurrentContext(), backgroundComponents);
	[path fill];
	const float strokeComponents[4] = {1, 1, 1, 0.80};
	CGContextSetStrokeColor(UICurrentContext(), strokeComponents);
	[path setLineWidth:1.0f];
	[path stroke];

	[super drawContentInRect:rect selected:selected];
	
	CFRelease(colorSpace);
}

/*
- (void)drawTitleInRect:(struct CGRect)rect selected:(BOOL)selected
{
	NSLog(@"IFTweetTableCell: drawTitleInRect:");
}
*/

@end
