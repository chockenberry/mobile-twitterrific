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

@interface IFTwitterrificToolbar (Private)

- (void)refreshPressed;
- (void)postPressed;
- (void)replyPressed;
- (void)messagePressed;
- (void)detailPressed;
- (void)configurePressed;

@end

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
		[_refreshButton addTarget:self action:@selector(refreshPressed) forEvents:1]; // mouse down
		[_refreshButton setShowPressFeedback:YES];
		[_refreshButton setEnabled:YES];
		[self addSubview:_refreshButton];

		_postButton = [[UIPushButton alloc] initWithFrame:CGRectMake(buttonWidth * 1.0f, 0.0f, buttonWidth, 44.0f)];
		[_postButton setAutosizesToFit:NO];
		[_postButton setImage:[UIImage imageNamed:@"post.png"] forState:0]; // normal state
		[_postButton addTarget:self action:@selector(postPressed) forEvents:1]; // mouse down
		[_postButton setShowPressFeedback:YES];
		[_postButton setEnabled:YES];
		[self addSubview:_postButton];

		_replyButton = [[UIPushButton alloc] initWithFrame:CGRectMake(buttonWidth * 2.0f, 0.0f, buttonWidth, 44.0f)];
		[_replyButton setAutosizesToFit:NO];
		[_replyButton setImage:[UIImage imageNamed:@"reply.png"] forState:0]; // normal state
		[_replyButton addTarget:self action:@selector(replyPressed) forEvents:1]; // mouse down
		[_replyButton setShowPressFeedback:YES];
		[_replyButton setEnabled:YES];
		[self addSubview:_replyButton];

		_messageButton = [[UIPushButton alloc] initWithFrame:CGRectMake(buttonWidth * 3.0f, 0.0f, buttonWidth, 44.0f)];
		[_messageButton setAutosizesToFit:NO];
		[_messageButton setImage:[UIImage imageNamed:@"message.png"] forState:0]; // normal state
		[_messageButton addTarget:self action:@selector(messagePressed) forEvents:1]; // mouse down
		[_messageButton setShowPressFeedback:YES];
		[_messageButton setEnabled:YES];
		[self addSubview:_messageButton];


		_detailButton = [[UIPushButton alloc] initWithFrame:CGRectMake(buttonWidth * 4.0f, 0.0f, buttonWidth, 44.0f)];
		[_detailButton setAutosizesToFit:NO];
		[_detailButton setImage:[UIImage imageNamed:@"detail.png"] forState:0]; // normal state
		[_detailButton addTarget:self action:@selector(detailPressed) forEvents:1]; // mouse down
		[_detailButton setShowPressFeedback:YES];
		[_detailButton setEnabled:YES];
		[self addSubview:_detailButton];

		_configureButton = [[UIPushButton alloc] initWithFrame:CGRectMake(buttonWidth * 5.0f, 0.0f, buttonWidth, 44.0f)];
		[_configureButton setAutosizesToFit:NO];
		[_configureButton setImage:[UIImage imageNamed:@"configure.png"] forState:0]; // normal state
		[_configureButton addTarget:self action:@selector(configurePressed) forEvents:1]; // mouse down
		[_configureButton setShowPressFeedback:YES];
		[_configureButton setEnabled:YES];
		[self addSubview:_configureButton];

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

- (void)setDelegate:(id)object
{
	_delegate = object;
}

- (id)delegate
{
	return _delegate;
}

- (BOOL) isValidDelegateForSelector:(SEL)selector
{
	return (([self delegate] != nil) && [[self delegate] respondsToSelector:selector]);
}

- (void)refreshPressed
{
	NSLog(@"IFTwitterrificToolbar: refreshPressed");
	
	if ([self isValidDelegateForSelector:@selector(refreshPressed)])
	{
		[[self delegate] performSelector:@selector(refreshPressed)];
	}
}

- (void)postPressed
{
	NSLog(@"IFTwitterrificToolbar: postPressed");
	
	if ([self isValidDelegateForSelector:@selector(postPressed)])
	{
		[[self delegate] performSelector:@selector(postPressed)];
	}
}

- (void)replyPressed
{
	NSLog(@"IFTwitterrificToolbar: replyPressed");
	
	if ([self isValidDelegateForSelector:@selector(replyPressed)])
	{
		[[self delegate] performSelector:@selector(replyPressed)];
	}
}

- (void)messagePressed
{
	NSLog(@"IFTwitterrificToolbar: messagePressed");
	
	if ([self isValidDelegateForSelector:@selector(messagePressed)])
	{
		[[self delegate] performSelector:@selector(messagePressed)];
	}
}

- (void)detailPressed
{
	NSLog(@"IFTwitterrificToolbar: detailPressed");
	
	if ([self isValidDelegateForSelector:@selector(detailPressed)])
	{
		[[self delegate] performSelector:@selector(detailPressed)];
	}
}

- (void)configurePressed
{
	NSLog(@"IFTwitterrificToolbar: configurePressed");
	
	if ([self isValidDelegateForSelector:@selector(configurePressed)])
	{
		[[self delegate] performSelector:@selector(configurePressed)];
	}
}


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
#pragma mark HACKING AWAY AT THE DELEGATE

- (BOOL)respondsToSelector:(SEL)aSelector
{
	NSLog(@"IFTwitterrificToolbar: respondsToSelector: selector = %@", NSStringFromSelector(aSelector));
	return [super respondsToSelector:aSelector];
}
*/

@end
