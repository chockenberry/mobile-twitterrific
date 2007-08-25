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

#import <WebCore/WebFontCache.h>

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

		_userNameLabel = [[UITextLabel alloc] initWithFrame:CGRectMake(4.0f, 4.0f, 200.0f, 18.0f)];
		[_userNameLabel setWrapsText:NO];
		[_userNameLabel setBackgroundColor:CGColorCreate(colorSpace, transparentComponents)];
		struct __GSFont *userNameFont = [NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:2 size:16.0f];
		[_userNameLabel setFont:userNameFont];
		[self addSubview:_userNameLabel];

		_textLabel = [[UITextLabel alloc] initWithFrame:CGRectMake(4.0f, 18.0f, contentRect.size.width - 40.0f, 70.0f)];
		[_textLabel setWrapsText:YES];
		[_textLabel setBackgroundColor:CGColorCreate(colorSpace, transparentComponents)];
		[_textLabel setEllipsisStyle:2];
		[_textLabel setCentersHorizontally:NO];		
		[self addSubview:_textLabel];

		_content = nil;
	}
    return self;
}

- (void)dealloc
{
	[_userNameLabel release];
	_userNameLabel = nil;
	
	[_content release];
	_content = nil;
	
	[super dealloc];
}

- (void)setContent:(NSDictionary *)newContent
{
    [_content release];
    _content = [newContent retain];
}

- (void)drawContentInRect:(struct CGRect)rect selected:(BOOL)selected
{
	NSLog(@"IFTweetTableCell: drawContentInRect:");
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

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
	
	[_userNameLabel setText:[_content objectForKey:@"userName"]];
	[_textLabel setText:[_content objectForKey:@"text"]];
	
	[super drawContentInRect:rect selected:selected];
}

/*
- (void)drawTitleInRect:(struct CGRect)rect selected:(BOOL)selected
{
	NSLog(@"IFTweetTableCell: drawTitleInRect:");
}
*/

@end
