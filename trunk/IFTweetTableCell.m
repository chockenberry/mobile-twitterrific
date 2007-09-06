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
#import <CoreGraphics/CGGeometry.h>
#import <WebCore/WebFontCache.h>
#import <AppKit/NSFontManager.h>

#import <UIKit/NSString-UIStringDrawing.h>

#import "UIView-Color.h"

#import "IFTweetTableCell.h"

#import "IFUIKitAdditions.h"

@implementation IFTweetTableCell

#define LEFT_OFFSET 6.0f
#define RIGHT_OFFSET 6.0f
#define TOP_OFFSET 6.0f
#define BOTTOM_OFFSET 6.0f
#define PADDING 2.0f

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
		_userNameLabel = [[UITextLabel alloc] initWithFrame:CGRectMake(LEFT_OFFSET + AVATAR_SIZE + PADDING, TOP_OFFSET - 5.0f, contentRect.size.width - LEFT_OFFSET - AVATAR_SIZE - PADDING - RIGHT_OFFSET, 22.0f)];
		[_userNameLabel setWrapsText:NO];
		[_userNameLabel setBackgroundColor:[UIView colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.0]];
		struct __GSFont *userNameFont = [NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:NSBoldFontMask size:16.0f];
		[_userNameLabel setFont:userNameFont];
		[self addSubview:_userNameLabel];

		_textLabel = [[UITextLabel alloc] initWithFrame:CGRectMake(LEFT_OFFSET + AVATAR_SIZE + PADDING, TOP_OFFSET + 18.0f - 3.0f, contentRect.size.width - LEFT_OFFSET - AVATAR_SIZE - PADDING - RIGHT_OFFSET, 80.0f)];
		[_textLabel setWrapsText:YES];
		[_textLabel setBackgroundColor:[UIView colorWithRed:0.0f green:1.0f blue:0.0f alpha:0.0]];
		struct __GSFont *textFont = [NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:0 size:16.0f];
		[_textLabel setFont:textFont];
		[_textLabel setEllipsisStyle:kUITextLabelEllipsisEnd];
		[_textLabel setCentersHorizontally:NO];		
		[self addSubview:_textLabel];

		_avatarImageView = [[IFURLImageView alloc] initWithFrame:CGRectMake(LEFT_OFFSET, TOP_OFFSET, AVATAR_SIZE, AVATAR_SIZE)];
		[self addSubview:_avatarImageView];

		[self setTapDelegate:self];

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
	//NSLog(@"IFTweetTableCell: setContent:");
    [_content release];
    _content = [newContent retain];

#if 0
	NSAttributedString *fancyString = [[NSAttributedString alloc] initWithString:[_content objectForKey:@"userName"] attributes:[NSDictionary dictionaryWithObjectsAndKeys:nil]];
	[_userNameLabel setText:fancyString];
#else	
	[_userNameLabel setText:[_content objectForKey:@"userName"]];
#endif
	NSString *text = [_content objectForKey:@"text"];
	
	[_textLabel setText:text];

	[_textLabel sizeToFit];
/*
NOTE: Calling methods in the NSString-UIStringDrawing category causes segmentation faults.
May be an issue with the toolchain, I don't know. Calculating the size based on the
length of the line does not take into account differing line lengths due to font pitch.
*/
//	struct __GSFont *textFont = [NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:0 size:16.0f];
//	struct CGSize size = [text sizeInRect:[_textLabel bounds] withFont:textFont];
//	struct CGSize size = [@"This is a test of the emergency broadcasting system" sizeWithFont:textFont forWidth:260.0f ellipsis:YES];
	struct CGRect frame = [_textLabel frame];
	//NSLog(@"IFTweetTableCell: setContent: size = %f, %f", frame.size.width, frame.size.height);
	float numberOfLines = ceil(frame.size.width / 258.0f);
	frame.size.width = 258.0f;
	frame.size.height = frame.size.height * numberOfLines;
	[_textLabel setFrame:frame];
	
//	[_textLabel sizeToFit];
	 
	[_avatarImageView setURLString:[_content objectForKey:@"userAvatarUrl"]];
}

- (void)drawContentInRect:(struct CGRect)rect selected:(BOOL)selected
{
//	NSLog(@"IFTweetTableCell: drawContentInRect:selected: text = %@", [_textLabel text]);
//	struct CGRect frame = [_textLabel frame];
//	NSLog(@"IFTweetTableCell: drawContentInRect:selected: frame = %f, %f, %f, %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
//	struct CGSize size = [_textLabel ellipsizedTextSize];
//	NSLog(@"IFTweetTableCell: drawContentInRect:selected: size = %f, %f", size.width, size.height);

	CGColorRef white = [UIView colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
	CGColorRef black = [UIView colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];

//	CGColorRef gray25 = [UIView colorWithRed:0.25f green:0.25f blue:0.25f alpha:1.0f];
	CGColorRef gray75 = [UIView colorWithRed:0.75f green:0.75f blue:0.75f alpha:1.0f];
	CGColorRef gray65 = [UIView colorWithRed:0.65f green:0.65f blue:0.65f alpha:1.0f];
	CGColorRef gray50 = [UIView colorWithRed:0.65f green:0.65f blue:0.65f alpha:1.0f];
	
	CGColorRef white25 = [UIView colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.25f];
	CGColorRef white50 = [UIView colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f];
	CGColorRef black75 = [UIView colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.75f];

	CGColorRef transparent = [UIView colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
	
	if (selected)
	{
		[_userNameLabel setColor:gray50];
		[_textLabel setColor:white];

		CGContextSetStrokeColorWithColor(UICurrentContext(), white);
		CGContextSetFillColorWithColor(UICurrentContext(), black);
	}
	else
	{
		[_userNameLabel setColor:white];
		[_textLabel setColor:gray75];
//		[_textLabel setColor:white];

		CGContextSetStrokeColorWithColor(UICurrentContext(), white25);
		CGContextSetFillColorWithColor(UICurrentContext(), black75);
//		CGContextSetFillColorWithColor(UICurrentContext(), transparent);
	}
	
	UIBezierPath *path;

	// fill the entire rect
	path = [UIBezierPath bezierPath];
	[path appendBezierPathWithRect:rect];
	[path fill];
	
	// stroke an inset and rounded rect
	struct CGRect innerRect = CGRectInset(rect, 1.0, 1.0);
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

#pragma mark UIView delegate

- (BOOL)view:(id)view handleTapWithCount:(int)count event:(struct __GSEvent *)event
{
	NSLog(@"IFTweetTableCell: view:handleTapWithCount:event: view = %@, count = %d", view, count);
	
	return YES;
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
