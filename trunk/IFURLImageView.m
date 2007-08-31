//
//  IFURLImageView.m
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 8/31/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "IFURLImageView.h"

#import <UIKit/UIBezierPath.h>
#import <WebCore/WebFontCache.h>
#import <CoreGraphics/CGGeometry.h>
#import <LayerKit/LKLayer.h>

#import "UIView-Color.h"

@implementation IFURLImageView

- (id)initWithFrame:(struct CGRect)frame;
{
//	struct CGRect contentRect = [UIHardware fullScreenApplicationContentRect];
//	contentRect.origin.x = 0.0f;
//	contentRect.origin.y = 0.0f;

    self = [super initWithFrame:frame];
    if (self)
	{
//		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

/*
		[self setEditable:NO];
		const float transparentComponents[4] = {0, 0, 0, 0};
		[self setBackgroundColor:CGColorCreate(colorSpace, transparentComponents)];
*/

//		CFRelease(colorSpace);
	}
    return self;
}

- (void)dealloc
{
	[_URLString release];
	_URLString = nil;
	
	[super dealloc];
}

- (NSString *)URLString;
{
	return _URLString;
}

- (void)setURLString:(NSString *)newURLString
{
	NSLog(@"IFURLImageView: setURLString: _URLString = %@, newURLString = %@", _URLString, newURLString);
	if (! [newURLString isEqualToString:_URLString])
	{
		[_URLString release];
		_URLString = [newURLString retain];

		NSLog(@"IFURLImageView: setURLString: loading new URL");
		NSURL *url = [NSURL URLWithString:_URLString];
		NSURLRequest *request = [NSURLRequest requestWithURL:url];
		_imageURLConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	}
}

- (UIImage *)image;
{
	return _image;
}

- (void)setImage:(UIImage *)newImage
{
    [_image release];
    _image = [newImage retain];
	
	[self setNeedsDisplay];
}

#if 0
//- (void)drawLayer:(LKLayer *)layer inContext:(CGContextRef)context
- (void)drawRect:(struct CGRect)rect
{
	NSLog(@"IFURLImageView: drawRect:");
	//NSLog(@"IFURLImageView: drawLayer:inContext: layer = %@", layer);

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

/*
	NSString *html = [NSString stringWithFormat:@"<div style=\"padding:0;margin:-8px\"><img src=\"%@\" width=\"48\" height=\"48\" style=\"padding:0;margin:0\"></div>", _URLString];
	[self setHTML:html];
*/

	CGContextRef context = UICurrentContext();
	
	//struct CGRect clipRect = CGRectInset(rect, 10.0, 10.0);
	struct CGRect clipRect = CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
	UIBezierPath *path = [UIBezierPath roundedRectBezierPath:clipRect withRoundedCorners:15 withCornerRadius:8.0];
	CGContextAddPath(context, [path _pathRef]);
	CGContextClip(context);

//	[layer renderInContext:context];
	[super drawRect:rect];
	
	const float fillComponents[4] = {1, 0, 0, 1};
	CGContextSetFillColor(context, fillComponents);
	[path fill];

	CFRelease(colorSpace);
}	

- (void)drawLayer:(LKLayer *)layer inContext:(CGContextRef)context
{
	NSLog(@"IFURLImageView: drawLayer:inContext: layer = %@", layer);
}
#else

- (BOOL)isOpaque
{
	return NO;
}

- (void)drawRect:(struct CGRect)rect
{
	NSLog(@"IFURLImageView: drawRect:");

	CGContextRef context = UICurrentContext();

/*	
	//struct CGRect clipRect = CGRectInset(rect, 10.0, 10.0);
	struct CGRect clipRect = CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
	UIBezierPath *path = [UIBezierPath roundedRectBezierPath:clipRect withRoundedCorners:15 withCornerRadius:8.0];
	CGContextAddPath(context, [path _pathRef]);
	CGContextClip(context);
*/

//	[layer renderInContext:context];
//	[super drawRect:rect];
	
	UIBezierPath *path = [UIBezierPath roundedRectBezierPath:rect withRoundedCorners:15 withCornerRadius:6.0];
	
	if (! _image)
	{
		CGContextSetFillColorWithColor(context, [UIView colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.25]);
		[path fill];
	}
	else
	{
		[path clip];
		[_image draw1PartImageInRect:rect];
	}
}	

#endif

#if 1
#pragma mark NSURLConnection delegate


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	if (! _imageData)
	{
		_imageData = [[NSMutableData alloc] init];
	}

	[_imageData appendData:data];
	//NSLog(@"IFURLImageView: connection:didReceiveData: data size = %d, total = %d", [data length], [_imageData length]);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	//NSLog(@"IFURLImageView: connection:didFailWithError: error = %@", error);
	[_imageURLConnection release];
	_imageURLConnection = nil;

	[_imageData release];
	_imageData = nil;
	[self setImage:nil];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	//NSLog(@"IFURLImageView: connectionDidFinishLoading: total = %d", [_imageData length]);
	[_imageURLConnection release];
	_imageURLConnection = nil;

	UIImage *newImage = [[[UIImage alloc] initWithData:_imageData cache:NO] autorelease];
	[_imageData release];
	_imageData = nil;
	
	//NSLog(@"IFURLImageView: connectionDidFinishLoading: image = %@", newImage);
	[self setImage:newImage];
}
#endif


#pragma mark HACKING AWAY AT THE DELEGATE

- (BOOL)respondsToSelector:(SEL)aSelector
{
	//NSLog(@"IFURLImageView: respondsToSelector: selector = %@", NSStringFromSelector(aSelector));
	return [super respondsToSelector:aSelector];
}


@end
