//
//  IFTweetView.m
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 9/4/07.
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//

#import "IFTweetView.h"

#import <CoreGraphics/CGGeometry.h>
//#import <WebCore/WebFontCache.h>
//#import <AppKit/NSFontManager.h>

#import <WebKit/WebView.h>

#import "IFTweetEditTextView.h"

#import <UIKit/NSString-UIStringDrawing.h>

#import "UIView-Color.h"
#import "NSDate-Relative.h"

#import "IFUIKitAdditions.h"

#define LEFT_OFFSET 6.0f
#define RIGHT_OFFSET 6.0f
#define TOP_OFFSET 6.0f
#define BOTTOM_OFFSET 6.0f
#define PADDING 2.0f

#define AVATAR_SIZE 48.0f

#define LINE_HEIGHT 16.0f

@implementation IFTweetView

- (id)initWithFrame:(struct CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self)
	{
		// create the text view
		_tweetTextView = [[UITextView alloc] initWithFrame:CGRectMake(LEFT_OFFSET + AVATAR_SIZE + PADDING, TOP_OFFSET, frame.size.width - LEFT_OFFSET - AVATAR_SIZE - PADDING - RIGHT_OFFSET, frame.size.height - TOP_OFFSET - BOTTOM_OFFSET)];
//		_tweetTextView = [[IFTweetEditTextView alloc] initWithFrame:CGRectMake(LEFT_OFFSET + AVATAR_SIZE + PADDING, TOP_OFFSET, frame.size.width - LEFT_OFFSET - AVATAR_SIZE - PADDING - RIGHT_OFFSET, frame.size.height - TOP_OFFSET - BOTTOM_OFFSET)];
		[_tweetTextView setTextColor:[UIView colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0]];
		[_tweetTextView setBackgroundColor:[UIView colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.0]];
		[_tweetTextView setMarginTop:0];
		[_tweetTextView setEditable:NO];
		[_tweetTextView setTextSize:18.0f];
		[_tweetTextView setDelegate:self];
		[_tweetTextView setTapDelegate:self];
//		[_tweetTextView becomeFirstResponder];
		[_tweetTextView setScrollerIndicatorStyle:kUIScrollerIndicatorWhite];
		[_tweetTextView setBottomBufferHeight:0.0f];
		[self addSubview:_tweetTextView];	

		_avatarImageView = [[IFURLImageView alloc] initWithFrame:CGRectMake(LEFT_OFFSET, TOP_OFFSET, AVATAR_SIZE, AVATAR_SIZE)];
		[self addSubview:_avatarImageView];

		[self setTapDelegate:self];

		_content = nil;
	}
    return self;
}

- (void)dealloc
{
	[_tweetTextView release];
	_tweetTextView = nil;
	[_avatarImageView release];
	_avatarImageView = nil;
	
	[_content release];
	_content = nil;
	
	[super dealloc];
}

- (void)setContent:(NSDictionary *)newContent
{
	NSLog(@"IFTweetView: setContent:");
    [_content release];
    _content = [newContent retain];

#if 0
	[_userNameLabel setText:[_content objectForKey:@"userName"]];
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
	NSLog(@"IFTweetView: setContent: size = %f, %f", frame.size.width, frame.size.height);
	float numberOfLines = 8.0;
	frame.size.width = 258.0f;
	frame.size.height = frame.size.height * numberOfLines;
	[_textLabel setFrame:frame];
	
//	[_textLabel sizeToFit];
#else
//	NSString *html = [[[NSString alloc] initWithString:[NSString stringWithFormat:@"<b>%@</b><br/>%@<br/><span style=\"font-size:14px;color:orange;\">12 hours ago <a href=\"http://google.com\">Link</a></span>",
	NSString *html = [[[NSString alloc] initWithString:[NSString stringWithFormat:@"<b>%@</b><br/>%@<br/><span style=\"font-size:14px;color:orange;\">%@ ago",
			[_content objectForKey:@"userName"], [_content objectForKey:@"text"], [[_content objectForKey:@"date"] relativeDate]]] autorelease];
	[_tweetTextView setHTML:html];

#if 0
	struct CGSize size = [html sizeWithMarkupForWidth:100.0f];
	NSLog(@"text size = %f x %f", size.width, size.height);
#endif

/*
	[_tweetTextView updateWebViewObjects];

	NSLog(@"_webView = %@", [_tweetTextView _webView]);

	UIWebView *webView = [_tweetTextView _webView];
	[[webView webView] setPolicyDelegate:self];
	[webView makeWKFirstResponder];
	[webView setEnabledGestures:YES];
*/
#endif

	[_avatarImageView setURLString:[_content objectForKey:@"userAvatarUrl"]];
}

#if 0
- (void)webView:(WebView *)sender decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id)listener
{
	NSLog(@"IFTweetView: webView:decidePolicyForNavigationAction:");
	[listener ignore];
}

- (void)webView:(WebView *)sender decidePolicyForNewWindowAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request newFrameName:(NSString *)frameName decisionListener:(id)listener
{
	NSLog(@"IFTweetView: webView:decidePolicyForNewWindowAction:");
	[listener ignore];
}
#endif

- (BOOL)isOpaque
{
	return NO;
}

- (void)drawRect:(struct CGRect)rect
{
	CGColorRef white = [UIView colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
	CGColorRef black75 = [UIView colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.75f];

	CGContextSetStrokeColorWithColor(UICurrentContext(), white);
	CGContextSetFillColorWithColor(UICurrentContext(), black75);

	// stroke an inset and rounded rect
	struct CGRect innerRect = CGRectInset(rect, 1.0, 1.0);
	UIBezierPath *path = [UIBezierPath roundedRectBezierPath:innerRect withRoundedCorners:kUIBezierPathAllCorners withCornerRadius:8.0];
	[path setLineWidth:2.0f];
	[path fill];
	[path stroke];

	// draw the subviews
	[super drawRect:rect];
}	

#pragma mark UIView delegate

- (BOOL)view:(id)view handleTapWithCount:(int)count event:(struct __GSEvent *)event
{
	NSLog(@"IFTweetView: view:handleTapWithCount:event: view = %@, count = %d", view, count);
	
	return YES;
}


#pragma mark HACKING AWAY AT THE DELEGATE

- (BOOL)respondsToSelector:(SEL)aSelector
{
	NSLog(@"IFTweetView: respondsToSelector: selector = %@", NSStringFromSelector(aSelector));
	return [super respondsToSelector:aSelector];
}


@end
