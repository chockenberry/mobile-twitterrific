//
//  IFTweetModel.h
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 8/22/07.
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IFTweetModel : NSObject
{
	NSMutableArray *_tweets;
	int _selectionIndex;
}

- (NSArray *)tweets;

- (void)selectTweetWithIndex:(int)index;
- (void)selectTweetWithId:(NSString *)tweetId;
- (int)selectionIndex;

- (NSDictionary *)selectedTweet;

- (BOOL)addTweet:(NSDictionary *)tweet;

- (int)indexForId:(NSString *)tweetId;

- (NSDictionary *)tweetAtIndex:(int)index;

- (int)tweetCount;

@end
