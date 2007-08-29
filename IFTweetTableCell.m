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
const float grayComponents[4] = {0.75, 0.75, 0.75, 1};
const float blueComponents[4] = {0.208, 0.482, 0.859, 1};
const float whiteComponents[4] = {1, 1, 1, 1};

#define LEFT_OFFSET 4.0f
//#define RIGHT_OFFSET 40.0f
#define RIGHT_OFFSET 4.0f
#define TOP_OFFSET 4.0f
#define BOTTOM_OFFSET 4.0f
#define PADDING 4.0f

#define AVATAR_SIZE 48.0f

#define LINE_HEIGHT 20.0f

- (id)initWithFrame:(struct CGRect)frame;
{
	struct CGRect contentRect = [UIHardware fullScreenApplicationContentRect];
	contentRect.origin.x = 0.0f;
	contentRect.origin.y = 0.0f;

    self = [super initWithFrame:frame];
    if (self)
	{
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

		_userNameLabel = [[UITextLabel alloc] initWithFrame:CGRectMake(LEFT_OFFSET + AVATAR_SIZE + PADDING, TOP_OFFSET, contentRect.size.width - LEFT_OFFSET - AVATAR_SIZE - PADDING - RIGHT_OFFSET, LINE_HEIGHT)];
		[_userNameLabel setWrapsText:NO];
		[_userNameLabel setBackgroundColor:CGColorCreate(colorSpace, transparentComponents)];
		struct __GSFont *userNameFont = [NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:2 size:16.0f];
		[_userNameLabel setFont:userNameFont];
		[self addSubview:_userNameLabel];

		_textLabel = [[UITextLabel alloc] initWithFrame:CGRectMake(LEFT_OFFSET + AVATAR_SIZE + PADDING, LINE_HEIGHT + PADDING, contentRect.size.width - LEFT_OFFSET - AVATAR_SIZE - PADDING - RIGHT_OFFSET, LINE_HEIGHT * 3)];
		[_textLabel setWrapsText:YES];
		[_textLabel setBackgroundColor:CGColorCreate(colorSpace, transparentComponents)];
		[_textLabel setEllipsisStyle:2];
		[_textLabel setCentersHorizontally:NO];		
		[self addSubview:_textLabel];

		_avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_OFFSET, TOP_OFFSET, AVATAR_SIZE, AVATAR_SIZE)];
		[self addSubview:_avatarImageView];

#if 0
		_detailButton = [[UIPushButton alloc] initWithFrame:CGRectMake(contentRect.size.width - RIGHT_OFFSET, 0.0f, RIGHT_OFFSET, 88.0f)];
		[_detailButton setAutosizesToFit:NO];
		[_detailButton setImage:[UIImage imageNamed:@"detail.png"] forState:0]; // normal state
#endif
		[_detailButton addTarget:self action:@selector(buttonDown) forEvents:1]; // mouse down
		[_detailButton addTarget:self action:@selector(buttonUp) forEvents:2]; // mouse up
		[_detailButton setShowPressFeedback:YES];
		[_detailButton setEnabled:YES];
		[self addSubview:_detailButton];

//		[self setTapDelegate:self];

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
	[_detailButton release];
	_detailButton = nil;
	
	[_content release];
	_content = nil;
	
	[super dealloc];
}

- (void)setContent:(NSDictionary *)newContent
{
    [_content release];
    _content = [newContent retain];
}

- (void)buttonDown
{
	NSLog(@"IFTweetTableCell: buttonDown");
}

- (void)buttonUp
{
	NSLog(@"IFTweetTableCell: buttonUp");
}


#if 1
- (void)drawContentInRect:(struct CGRect)rect selected:(BOOL)selected
{
	//NSLog(@"IFTweetTableCell: drawContentInRect:");
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

#if 1
	if (selected)
	{
		[_userNameLabel setColor:CGColorCreate(colorSpace, whiteComponents)];
		[_textLabel setColor:CGColorCreate(colorSpace, whiteComponents)];

		const float strokeComponents[4] = {1, 1, 1, 1};
		CGContextSetStrokeColor(UICurrentContext(), strokeComponents);
	}
	else
	{
		[_userNameLabel setColor:CGColorCreate(colorSpace, whiteComponents)];
		[_textLabel setColor:CGColorCreate(colorSpace, grayComponents)];

		const float strokeComponents[4] = {1, 1, 1, 0.50};
		CGContextSetStrokeColor(UICurrentContext(), strokeComponents);
	}
#else
	[_userNameLabel setColor:CGColorCreate(colorSpace, whiteComponents)];
	[_textLabel setColor:CGColorCreate(colorSpace, whiteComponents)];
#endif	

	[_userNameLabel setText:[_content objectForKey:@"userName"]];
	[_textLabel setText:[_content objectForKey:@"text"]];
	[_avatarImageView setImage:[_content objectForKey:@"userAvatarImage"]];
	
//	UIBezierPath *path = [UIBezierPath roundedRectBezierPath:rect withRoundedEdges:15];
	
	struct CGRect innerRect = CGRectInset(rect, 1.5, 1.5);
//	struct CGRect newRect = GCRectMake(rect, 10.0, 10.0);
/*
NOTE: Corners are determined by OR-ing the following values. Use 15 for all four corners:
	1 = upper-left corner
	2 = upper-right corner
	4 = lower-left corner
	8 = lower-right corner
Radius is in number of pixels.
*/
	UIBezierPath *path;

	path = [UIBezierPath roundedRectBezierPath:rect withRoundedCorners:15 withCornerRadius:8.0];
	const float backgroundComponents[4] = {0, 0, 0, 0.7};
	CGContextSetFillColor(UICurrentContext(), backgroundComponents);
	[path fill];
	
	path = [UIBezierPath roundedRectBezierPath:innerRect withRoundedCorners:15 withCornerRadius:8.0];
//	const float strokeComponents[4] = {1, 1, 1, 0.50};
//	CGContextSetStrokeColor(UICurrentContext(), strokeComponents);
	[path setLineWidth:2.0f];
	[path stroke];

	[super drawContentInRect:rect selected:selected];
	
	CFRelease(colorSpace);
}
#endif

- (void)drawRect:(struct CGRect)rect
{
	//NSLog(@"IFTweetTableCell: drawRect:");
#if 0
	if (! [self isSelected])
	{
		[super drawRect:rect];
	}
#else
	[self drawContentInRect:rect selected:[self isSelected]];
#endif
}	

/*
- (void)drawTitleInRect:(struct CGRect)rect selected:(BOOL)selected
{
	NSLog(@"IFTweetTableCell: drawTitleInRect:");
}
*/

#pragma mark HACKING AWAY AT THE DELEGATE

- (BOOL)respondsToSelector:(SEL)aSelector
{
	//NSLog(@"IFTweetTableCell: respondsToSelector: selector = %@", NSStringFromSelector(aSelector));
	return [super respondsToSelector:aSelector];
}


@end
