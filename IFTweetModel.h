//
//  IFTweetModel.h
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 8/22/07.
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IFTweetModel : NSObject
{
	NSMutableArray *_tweets;
	int _selectionIndex;
}

- (NSArray *)tweets;
- (void)setTweets:(NSArray *)newTweets;

- (void)selectTweetWithIndex:(int)index;
- (void)selectTweetWithId:(NSString *)tweetId;
- (int)selectionIndex;

- (NSMutableDictionary *)selectedTweet;

- (BOOL)addTweet:(NSMutableDictionary *)tweet;

- (int)indexForId:(NSString *)tweetId;

- (NSMutableDictionary *)tweetAtIndex:(int)index;

- (int)tweetCount;

@end
