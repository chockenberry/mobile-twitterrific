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

#define LINE_HEIGHT 16.0f


- (id)initWithFrame:(struct CGRect)frame;
{
	struct CGRect contentRect = [UIHardware fullScreenApplicationContentRect];
	contentRect.origin.x = 0.0f;
	contentRect.origin.y = 0.0f;

    self = [super initWithFrame:frame];
    if (self)
	{
//		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

#if 1
		_userNameLabel = [[UITextLabel alloc] initWithFrame:CGRectMake(LEFT_OFFSET + AVATAR_SIZE + PADDING, TOP_OFFSET, contentRect.size.width - LEFT_OFFSET - AVATAR_SIZE - PADDING - RIGHT_OFFSET, 22.0f)];
		[_userNameLabel setWrapsText:NO];
		[_userNameLabel setBackgroundColor:[UIView colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.0]];
		struct __GSFont *userNameFont = [NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:2 size:18.0f];
		[_userNameLabel setFont:userNameFont];
		[self addSubview:_userNameLabel];

		_textLabel = [[UITextLabel alloc] initWithFrame:CGRectMake(LEFT_OFFSET + AVATAR_SIZE + PADDING, TOP_OFFSET + 18.0f, contentRect.size.width - LEFT_OFFSET - AVATAR_SIZE - PADDING - RIGHT_OFFSET, 60.0f)];
		[_textLabel setWrapsText:YES];
		[_textLabel setBackgroundColor:[UIView colorWithRed:0.0f green:1.0f blue:0.0f alpha:0.0]];
		struct __GSFont *textFont = [NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:2 size:16.0f];
		[_textLabel setFont:textFont];
		[_textLabel setEllipsisStyle:2];
		[_textLabel setCentersHorizontally:NO];		
		[self addSubview:_textLabel];

#if 1
//		_avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_OFFSET, TOP_OFFSET, AVATAR_SIZE, AVATAR_SIZE)];
		_avatarImageView = [[IFURLImageView alloc] initWithFrame:CGRectMake(LEFT_OFFSET, TOP_OFFSET, AVATAR_SIZE, AVATAR_SIZE)];
		[self addSubview:_avatarImageView];
#else
#if 0
		_avatarTextView = [[UITextView alloc] initWithFrame:CGRectMake(LEFT_OFFSET, TOP_OFFSET, AVATAR_SIZE, AVATAR_SIZE)];
		[_avatarTextView setEditable:NO];
		[_avatarTextView setTextSize:12.0f];
		[_avatarTextView setTextColor:CGColorCreate(colorSpace, whiteComponents)];
		[_avatarTextView setBackgroundColor:CGColorCreate(colorSpace, transparentComponents)];
		[self addSubview:_avatarTextView];
#else
		_avatarImageView2 = [[IFURLImageView alloc] initWithFrame:CGRectMake(LEFT_OFFSET, TOP_OFFSET, AVATAR_SIZE, AVATAR_SIZE)];
		[self addSubview:_avatarImageView2];
#endif
#endif

/*
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
*/

#else
		_avatarTextView = [[UITextView alloc] initWithFrame:CGRectMake(LEFT_OFFSET, TOP_OFFSET, contentRect.size.width - LEFT_OFFSET - RIGHT_OFFSET, 80.0)];
		[_avatarTextView setEditable:NO];
		[_avatarTextView setTextSize:16.0f];
		[_avatarTextView setTextColor:CGColorCreate(colorSpace, whiteComponents)];
		[_avatarTextView setBackgroundColor:CGColorCreate(colorSpace, transparentComponents)];
		[self addSubview:_avatarTextView];	
#endif

//		[self setTapDelegate:self];

//		CFRelease(colorSpace);
		
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
#if 1
	[_avatarImageView release];
	_avatarImageView = nil;
#else
#if 0
	[_avatarTextView release];
	_avatarTextView = nil;
#else
	[_avatarImageView2 release];
	_avatarImageView2 = nil;
#endif
#endif
//	[_detailButton release];
//	_detailButton = nil;
	
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

/*
- (void)setAvatarImage:(UIImage *)newImage
{
	[_avatarImageView setImage:newImage];
}
*/

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
	
	//CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

	CGColorRef gray = [UIView colorWithRed:0.75f green:0.75f blue:0.75f alpha:1.0f];
	CGColorRef white = [UIView colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
	
#if 1
#if 1
	if (selected)
	{
		[_userNameLabel setColor:gray];
		[_textLabel setColor:white];

		CGContextSetStrokeColorWithColor(UICurrentContext(), white);
	}
	else
	{
		[_userNameLabel setColor:white];
		[_textLabel setColor:gray];

		CGContextSetStrokeColorWithColor(UICurrentContext(), [UIView colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f]);
	}
#else
	[_userNameLabel setColor:CGColorCreate(colorSpace, whiteComponents)];
	[_textLabel setColor:CGColorCreate(colorSpace, whiteComponents)];
#endif	

//	[_userNameLabel setText:[_content objectForKey:@"userName"]];
//	[_textLabel setText:[_content objectForKey:@"text"]];
	
//	struct CGSize textSize = [_textLabel ellipsizedTextSize];
//	struct CGRect textFrame = CGRectMake(LEFT_OFFSET + AVATAR_SIZE + PADDING, TOP_OFFSET + 16.0f, textSize.width, textSize.height);
//	[_textLabel setFrame:textFrame];
	
#if 1
	//[_avatarImageView setImage:[_content objectForKey:@"userAvatarImage"]];
//	if (! [_avatarImageView image])
//	{
//		[_avatarImageView setURLString:[_content objectForKey:@"userAvatarUrl"]];
//	}
#else
#if 0
	NSString *html = [[[NSString alloc] initWithString:[NSString stringWithFormat:@"<div style=\"padding:0;margin:-8px\"><a href=\"http://google.com\"><img src=\"%@\" width=\"48\" height=\"48\" style=\"padding:0;margin:0;\"></a><br/>59 min</div>",
			[_content objectForKey:@"userAvatarUrl"]]] autorelease];
	[_avatarTextView setHTML:html];
//	[_avatarTextView setNeedsDisplay];
#else
	[_avatarImageView2 setURLString:[_content objectForKey:@"userAvatarUrl"]];
#endif
#endif

#else
	if (selected)
	{
		[_avatarTextView setTextColor:CGColorCreate(colorSpace, whiteComponents)];

		const float strokeComponents[4] = {1, 1, 1, 1};
		CGContextSetStrokeColor(UICurrentContext(), strokeComponents);
	}
	else
	{
		[_avatarTextView setTextColor:CGColorCreate(colorSpace, grayComponents)];

		const float strokeComponents[4] = {1, 1, 1, 0.50};
		CGContextSetStrokeColor(UICurrentContext(), strokeComponents);
	}

	NSString *html = [[[NSString alloc] initWithString:[NSString stringWithFormat:@"<div style=\"padding:0;margin:-8px\"><a href=\"http://google.com\"><img src=\"%@\" width=\"48\" height=\"48\" style=\"padding:0;margin:0\"></a><b>%@</b><br/>%@</div>",
			[_content objectForKey:@"userAvatarUrl"], [_content objectForKey:@"userName"], [_content objectForKey:@"text"]]] autorelease];
	[_avatarTextView setHTML:html];
#endif

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

//	path = [UIBezierPath roundedRectBezierPath:rect withRoundedCorners:15 withCornerRadius:8.0];
	path = [UIBezierPath bezierPath];
	[path appendBezierPathWithRect:rect];

//	const float backgroundComponents[4] = {0, 0, 0, 0.7};
	CGContextSetFillColorWithColor(UICurrentContext(), [UIView colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.75f]);
	[path fill];
	
	path = [UIBezierPath roundedRectBezierPath:innerRect withRoundedCorners:15 withCornerRadius:8.0];
//	const float strokeComponents[4] = {1, 1, 1, 0.50};
//	CGContextSetStrokeColor(UICurrentContext(), strokeComponents);
	[path setLineWidth:2.0f];
	[path stroke];

/*
	struct CGRect clipRect = CGRectInset(rect, 10.0, 10.0);
	path = [UIBezierPath roundedRectBezierPath:clipRect withRoundedCorners:15 withCornerRadius:8.0];
	CGContextAddPath(UICurrentContext(), [path _pathRef]);
	CGContextClip(UICurrentContext());
*/
	
	[super drawContentInRect:rect selected:selected];
	
	//CFRelease(colorSpace);
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
