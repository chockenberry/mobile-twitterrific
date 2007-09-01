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

#import "UIView-Color.h"

#import "IFTweetTableCell.h"

@implementation IFTweetTableCell

#define LEFT_OFFSET 4.0f
#define RIGHT_OFFSET 4.0f
#define TOP_OFFSET 4.0f
#define BOTTOM_OFFSET 4.0f
#define PADDING 4.0f

#define AVATAR_SIZE 48.0f

#define LINE_HEIGHT 16.0f


- (id)initWithFrame:(struct CGRect)frame;
{
	struct CGRect contentRect = [UIHardware fullScreenApplicationContentRect];
	contentRect.origin.x = 0.0f;
	contentRect.origin.y = 0.0f;

    self = [super initWithFrame:frame];
    if (self)
	{
		_userNameLabel = [[UITextLabel alloc] initWithFrame:CGRectMake(LEFT_OFFSET + AVATAR_SIZE + PADDING, TOP_OFFSET, contentRect.size.width - LEFT_OFFSET - AVATAR_SIZE - PADDING - RIGHT_OFFSET, 22.0f)];
		[_userNameLabel setWrapsText:NO];
		[_userNameLabel setBackgroundColor:[UIView colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.0]];
		struct __GSFont *userNameFont = [NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:2 size:18.0f];
		[_userNameLabel setFont:userNameFont];
		[self addSubview:_userNameLabel];

		_textLabel = [[UITextLabel alloc] initWithFrame:CGRectMake(LEFT_OFFSET + AVATAR_SIZE + PADDING, TOP_OFFSET + 18.0f, contentRect.size.width - LEFT_OFFSET - AVATAR_SIZE - PADDING - RIGHT_OFFSET, 62.0f)];
		[_textLabel setWrapsText:YES];
		[_textLabel setBackgroundColor:[UIView colorWithRed:0.0f green:1.0f blue:0.0f alpha:0.0]];
		struct __GSFont *textFont = [NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:2 size:16.0f];
		[_textLabel setFont:textFont];
		[_textLabel setEllipsisStyle:2];
		[_textLabel setCentersHorizontally:NO];		
		[self addSubview:_textLabel];

		_avatarImageView = [[IFURLImageView alloc] initWithFrame:CGRectMake(LEFT_OFFSET, TOP_OFFSET, AVATAR_SIZE, AVATAR_SIZE)];
		[self addSubview:_avatarImageView];

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
	NSLog(@"IFTweetTableCell: setContent:");
    [_content release];
    _content = [newContent retain];

	[_userNameLabel setText:[_content objectForKey:@"userName"]];
	[_textLabel setText:[_content objectForKey:@"text"]];
	[_avatarImageView setURLString:[_content objectForKey:@"userAvatarUrl"]];
}

- (void)drawContentInRect:(struct CGRect)rect selected:(BOOL)selected
{
	CGColorRef white = [UIView colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
	CGColorRef black = [UIView colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];

	//CGColorRef darkgray = [UIView colorWithRed:0.25f green:0.25f blue:0.25f alpha:1.0f];
	CGColorRef lightgray = [UIView colorWithRed:0.75f green:0.75f blue:0.75f alpha:1.0f];
	
	CGColorRef white50 = [UIView colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f];
	CGColorRef black75 = [UIView colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.75f];
	
	if (selected)
	{
		[_userNameLabel setColor:lightgray];
		[_textLabel setColor:white];

		CGContextSetStrokeColorWithColor(UICurrentContext(), white);
		CGContextSetFillColorWithColor(UICurrentContext(), black);
	}
	else
	{
		[_userNameLabel setColor:white];
		[_textLabel setColor:lightgray];

		CGContextSetStrokeColorWithColor(UICurrentContext(), white50);
		CGContextSetFillColorWithColor(UICurrentContext(), black75);
	}
	
	UIBezierPath *path;

	// fill the entire rect
	path = [UIBezierPath bezierPath];
	[path appendBezierPathWithRect:rect];
	[path fill];
	
	// stroke an inset and rounded rect
	struct CGRect innerRect = CGRectInset(rect, 1.5, 1.5);
	path = [UIBezierPath roundedRectBezierPath:innerRect withRoundedCorners:kUIBezierPathAllCorners withCornerRadius:8.0];
	[path setLineWidth:2.0f];
	[path stroke];

	// draw the views of the cell
	[super drawContentInRect:rect selected:selected];
}

/*
NOTE: Overriding superclass implementation of drawRect: allows us to do our own
selection highlight.
*/
- (void)drawRect:(struct CGRect)rect
{
	//NSLog(@"IFTweetTableCell: drawRect:");
	[self drawContentInRect:rect selected:[self isSelected]];
}	

/*
#pragma mark HACKING AWAY AT THE DELEGATE

- (BOOL)respondsToSelector:(SEL)aSelector
{
	//NSLog(@"IFTweetTableCell: respondsToSelector: selector = %@", NSStringFromSelector(aSelector));
	return [super respondsToSelector:aSelector];
}
*/

@end
