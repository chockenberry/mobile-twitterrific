//
//  IFURLImageView.h
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 8/31/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <UIKit/UITextView.h>

@interface IFURLImageView : UIView
{
	NSString *_URLString;
	UIImage *_image;

	NSURLConnection *_imageURLConnection;
	NSMutableData *_imageData;
}

- (NSString *)URLString;
- (void)setURLString:(NSString *)newURLString;

- (UIImage *)image;
- (void)setImage:(UIImage *)newImage;

@end
