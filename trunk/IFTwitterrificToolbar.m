//
//  IFTwitterrificToolbar.m
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 8/29/07.
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <UIKit/UIBezierPath.h>

#import "IFTwitterrificToolbar.h"

#define BUTTON_COUNT 6

@implementation IFTwitterrificToolbar

- (id)initWithFrame:(struct CGRect)frame;
{
	struct CGRect contentRect = [UIHardware fullScreenApplicationContentRect];
	contentRect.origin.x = 0.0f;
	contentRect.origin.y = 0.0f;

    self = [super initWithFrame:frame];
    if (self)
	{
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

		float buttonWidth = contentRect.size.width / BUTTON_COUNT;
		
		_refreshButton = [[UIPushButton alloc] initWithFrame:CGRectMake(buttonWidth * 0.0f, 0.0f, buttonWidth, 44.0f)];
		[_refreshButton setAutosizesToFit:NO];
		[_refreshButton setImage:[UIImage imageNamed:@"refresh.png"] forState:0]; // normal state
		[_refreshButton addTarget:self action:@selector(buttonDown) forEvents:1]; // mouse down
//		[_refreshButton addTarget:self action:@selector(buttonUp) forEvents:2]; // mouse up
		[_refreshButton setShowPressFeedback:YES];
		[_refreshButton setEnabled:YES];
		[self addSubview:_refreshButton];

		_postButton = [[UIPushButton alloc] initWithFrame:CGRectMake(buttonWidth * 1.0f, 0.0f, buttonWidth, 44.0f)];
		[_postButton setAutosizesToFit:NO];
		[_postButton setImage:[UIImage imageNamed:@"post.png"] forState:0]; // normal state
		[_postButton addTarget:self action:@selector(buttonDown) forEvents:1]; // mouse down
//		[_postButton addTarget:self action:@selector(buttonUp) forEvents:2]; // mouse up
		[_postButton setShowPressFeedback:YES];
		[_postButton setEnabled:YES];
		[self addSubview:_postButton];

		_replyButton = [[UIPushButton alloc] initWithFrame:CGRectMake(buttonWidth * 2.0f, 0.0f, buttonWidth, 44.0f)];
		[_replyButton setAutosizesToFit:NO];
		[_replyButton setImage:[UIImage imageNamed:@"reply.png"] forState:0]; // normal state
		[_replyButton addTarget:self action:@selector(buttonDown) forEvents:1]; // mouse down
//		[_replyButton addTarget:self action:@selector(buttonUp) forEvents:2]; // mouse up
		[_replyButton setShowPressFeedback:YES];
		[_replyButton setEnabled:YES];
		[self addSubview:_replyButton];

		_messageButton = [[UIPushButton alloc] initWithFrame:CGRectMake(buttonWidth * 3.0f, 0.0f, buttonWidth, 44.0f)];
		[_messageButton setAutosizesToFit:NO];
		[_messageButton setImage:[UIImage imageNamed:@"message.png"] forState:0]; // normal state
		[_messageButton addTarget:self action:@selector(buttonDown) forEvents:1]; // mouse down
//		[_messageButton addTarget:self action:@selector(buttonUp) forEvents:2]; // mouse up
		[_messageButton setShowPressFeedback:YES];
		[_messageButton setEnabled:YES];
		[self addSubview:_messageButton];


		_detailButton = [[UIPushButton alloc] initWithFrame:CGRectMake(buttonWidth * 4.0f, 0.0f, buttonWidth, 44.0f)];
		[_detailButton setAutosizesToFit:NO];
		[_detailButton setImage:[UIImage imageNamed:@"detail.png"] forState:0]; // normal state
		[_detailButton addTarget:self action:@selector(buttonDown) forEvents:1]; // mouse down
//		[_detailButton addTarget:self action:@selector(buttonUp) forEvents:2]; // mouse up
		[_detailButton setShowPressFeedback:YES];
		[_detailButton setEnabled:YES];
		[self addSubview:_detailButton];

		_configureButton = [[UIPushButton alloc] initWithFrame:CGRectMake(buttonWidth * 5.0f, 0.0f, buttonWidth, 44.0f)];
		[_configureButton setAutosizesToFit:NO];
		[_configureButton setImage:[UIImage imageNamed:@"configure.png"] forState:0]; // normal state
		[_configureButton addTarget:self action:@selector(buttonDown) forEvents:1]; // mouse down
//		[_configureButton addTarget:self action:@selector(buttonUp) forEvents:2]; // mouse up
		[_configureButton setShowPressFeedback:YES];
		[_configureButton setEnabled:YES];
		[self addSubview:_configureButton];


//		[self setTapDelegate:self];

		CFRelease(colorSpace);
	}
    return self;
}

- (void)dealloc
{
	[_refreshButton release];
	_refreshButton = nil;
	[_postButton release];
	_postButton = nil;
	[_replyButton release];
	_replyButton = nil;
	[_messageButton release];
	_messageButton = nil;
	[_detailButton release];
	_detailButton = nil;
	[_configureButton release];
	_configureButton = nil;
		
	[super dealloc];
}

- (void)buttonDown
{
	NSLog(@"IFTwitterrificToolbar: buttonDown");
}

- (void)buttonUp
{
	NSLog(@"IFTwitterrificToolbar: buttonUp");
}


#if 0
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

- (BOOL)isOpaque
{
	return NO;
}

- (void)drawRect:(struct CGRect)rect
{
	NSLog(@"IFTwitterrificToolbar: drawRect:");

	UIBezierPath *path = [UIBezierPath roundedRectBezierPath:rect withRoundedCorners:15 withCornerRadius:22.0];
	const float backgroundComponents[4] = {0, 0, 0, 0.7};
	CGContextSetFillColor(UICurrentContext(), backgroundComponents);
	[path fill];

	[super drawRect:rect];
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
	NSLog(@"IFTwitterrificToolbar: respondsToSelector: selector = %@", NSStringFromSelector(aSelector));
	return [super respondsToSelector:aSelector];
}

@end