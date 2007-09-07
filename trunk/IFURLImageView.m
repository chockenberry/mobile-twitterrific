//
//  IFURLImageView.m
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 8/31/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "IFURLImageView.h"

#import <UIKit/UIBezierPath.h>
//#import <WebCore/WebFontCache.h>
#import <CoreGraphics/CGGeometry.h>
//#import <LayerKit/LKLayer.h>

#import "UIView-Color.h"

@implementation IFURLImageView

- (void)dealloc
{
	[_URLString release];
	_URLString = nil;
	[_image release];
	_image = nil;

	[_imageURLConnection cancel];
	[_imageURLConnection release];
	_imageURLConnection = nil;
	[_imageData release];
	_imageData = nil;
	
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


- (BOOL)isOpaque
{
	return NO;
}

- (void)drawRect:(struct CGRect)rect
{
	NSLog(@"IFURLImageView: drawRect:");

	CGContextRef context = UICurrentContext();

	UIBezierPath *path = [UIBezierPath roundedRectBezierPath:rect withRoundedCorners:kUIBezierPathAllCorners withCornerRadius:6.0];
	
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
	// setting the image has the side effect of marking the view for display
}

/*
#pragma mark HACKING AWAY AT THE DELEGATE

- (BOOL)respondsToSelector:(SEL)aSelector
{
	//NSLog(@"IFURLImageView: respondsToSelector: selector = %@", NSStringFromSelector(aSelector));
	return [super respondsToSelector:aSelector];
}
*/

@end
