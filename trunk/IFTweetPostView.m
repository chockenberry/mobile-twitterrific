//
//  IFTweetPostView.m
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 9/10/07.
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//

#import "IFTweetPostView.h"

#import <CoreGraphics/CGGeometry.h>


#import "IFTweetEditTextView.h"

#import "UIView-Color.h"
#import "NSDate-Relative.h"

#import "IFUIKitAdditions.h"

#define LEFT_OFFSET 6.0f
#define RIGHT_OFFSET 6.0f
#define TOP_OFFSET 6.0f
#define BOTTOM_OFFSET 6.0f
#define PADDING 2.0f

#define COUNTER_SIZE 48.0f

#define LINE_HEIGHT 16.0f

@implementation IFTweetPostView

- (id)initWithFrame:(struct CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self)
	{
	 	// create the text view for editing
		_editingTextView = [[IFTweetEditTextView alloc] initWithFrame:CGRectMake(LEFT_OFFSET + COUNTER_SIZE + PADDING, TOP_OFFSET, frame.size.width - LEFT_OFFSET - COUNTER_SIZE - PADDING - RIGHT_OFFSET, frame.size.height - TOP_OFFSET - BOTTOM_OFFSET)];
		[_editingTextView setEditable:YES];
		//[_editingTextView setText:@"This is a test of the emergency broadcasting system. In the event of a real emergency, you would have been instructed where to tune in your area for further information. This concludes this test of the emergency broadcasting system."];
		[_editingTextView setText:@""];
		[_editingTextView setBackgroundColor:[UIView colorWithRed:1.0f green:0.0f blue:1.0f alpha:0.0]];
		[_editingTextView setTextColor:[UIView colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0]];
		[_editingTextView setCaretColor:[UIView colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0]];
		[_editingTextView setTextSize:18.0f];
		[_editingTextView setDelegate:self];
		[_editingTextView setMarginTop:0];
//		[_editingTextView setBottomBufferHeight:0.0f];
	
		[self addSubview:_editingTextView];

		// create the text view for counting characters in the editing view
		_counterTextLabel = [[UITextLabel alloc] initWithFrame:CGRectMake(LEFT_OFFSET, TOP_OFFSET, COUNTER_SIZE, COUNTER_SIZE)];
		[_counterTextLabel setCentersHorizontally:YES];
		[_counterTextLabel setText:@""];
		[_counterTextLabel setBackgroundColor:[UIView colorWithRed:1.0f green:1.0f blue:0.0f alpha:1.0]];
		[_counterTextLabel setColor:[UIView colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0]];
		GSFontRef font = GSFontCreateWithName("Helvetica", 0, 16.0f);
		[_counterTextLabel setFont:font];
		CFRelease(font);

		[self addSubview:_counterTextLabel];

		[_editingTextView becomeFirstResponder];

		[self setTapDelegate:self];
	}
    return self;
}

- (void)dealloc
{
	[_editingTextView release];
	_editingTextView = nil;
	[_counterTextLabel release];
	_counterTextLabel = nil;
	
	[super dealloc];
}

- (NSString *)message
{
	return [_editingTextView text];
}

- (BOOL)isOpaque
{
	return NO;
}

- (void)drawRect:(struct CGRect)rect
{
	CGColorRef white75 = [UIView colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.75f];
	CGColorRef black = [UIView colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];

	CGContextSetStrokeColorWithColor(UICurrentContext(), black);
	CGContextSetFillColorWithColor(UICurrentContext(), white75);

	// stroke an inset and rounded rect
	struct CGRect innerRect = CGRectInset(rect, 1.0, 1.0);
	UIBezierPath *path = [UIBezierPath roundedRectBezierPath:innerRect withRoundedCorners:kUIBezierPathAllCorners withCornerRadius:8.0];
	[path setLineWidth:2.0f];
	[path fill];
	[path stroke];

	// draw the subviews
	[super drawRect:rect];
}	

/*
- (void)drawRect:(struct CGRect)rect
{
	NSLog(@"IFTwitterrificToolbar: drawRect:");

	//CGRectMake(10.0f, 54.0f, contentRect.size.width - 20.0f, 90.0f)

	UIBezierPath *path = [UIBezierPath roundedRectBezierPath:rect withRoundedCorners:(kUIBezierPathTopLeftCorner | kUIBezierPathTopRightCorner) withCornerRadius:8.0];
	CGContextSetFillColorWithColor(UICurrentContext(), [UIView colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.90f]);
	[path fill];

	[super drawRect:rect];
}	
*/

#pragma mark IFTweetEditTextView delgate

- (void)editTextViewDidChange:(IFTweetEditTextView *)view
{
	int textLength = [[view text] length];
	NSLog(@"IFTweetPostView: editTextViewDidChange: view = %@, textLength = %d", view, textLength);
	[_counterTextLabel setText:[[NSNumber numberWithInt:(140 - textLength)] stringValue]];
	
}

#pragma mark UIView delegate

- (BOOL)view:(id)view handleTapWithCount:(int)count event:(struct __GSEvent *)event
{
	NSLog(@"IFTweetPostView: view:handleTapWithCount:event: view = %@, count = %d", view, count);
	
	return YES;
}


#pragma mark HACKING AWAY AT THE DELEGATE

- (BOOL)respondsToSelector:(SEL)aSelector
{
	NSLog(@"IFTweetPostView: respondsToSelector: selector = %@", NSStringFromSelector(aSelector));
	return [super respondsToSelector:aSelector];
}


@end
