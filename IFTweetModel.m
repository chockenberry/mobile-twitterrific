//
//  IFTweetModel.m
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 8/22/07.
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//

#import "IFTweetModel.h"


#define MAX_TWEET_COUNT 200


@implementation IFTweetModel

#pragma mark Instance management

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		_tweets = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[_tweets release];
	
	[super dealloc];
}

- (NSArray *)tweets
{
	return _tweets;
}

- (void)setTweets:(NSArray *)newTweets
{
    [_tweets release];

	// create a mutable array with mutable dictionaries from immutable data (from NSUserDefaults, for example)
	_tweets = [[NSMutableArray arrayWithCapacity:[newTweets count]] retain];
	NSEnumerator *newTweetsEnumerator = [newTweets objectEnumerator];
	NSDictionary *newTweet;
	while ((newTweet = [newTweetsEnumerator nextObject]))
	{
		NSMutableDictionary *tweet = [NSMutableDictionary dictionaryWithDictionary:newTweet];
		[_tweets addObject:tweet];
	}
}

- (int)indexForId:(NSString *)tweetId
{
	BOOL tweetIdExists = NO;
	int index = 0;
	NSEnumerator *tweetEnumerator = [[self tweets] objectEnumerator];
	NSDictionary *tweet;
	while ((tweet = [tweetEnumerator nextObject]))
	{
		if ([tweetId isEqualToString:[tweet objectForKey:@"id"]])
		{
			tweetIdExists = YES;
			break;
		}
		index += 1;
	}

	return (tweetIdExists ? index : -1);
}

NSComparisonResult tweetSortFunction(id tweet, id anotherTweet, void *context)
{
	NSComparisonResult result = [[tweet objectForKey:@"date"] compare:[anotherTweet objectForKey:@"date"]];

	// reverse sort by multiplying by -1
	return (result * -1);
}

- (void)_sortTweets
{
	[_tweets sortUsingFunction:tweetSortFunction context:NULL];
}

- (BOOL)addTweet:(NSMutableDictionary *)tweet
{
	BOOL tweetWasAdded = NO;
	
	// check if the tweet has already been recorded (duplicates can happen because the XML feed is accessed many times
	// and may return the same id multiple times.
	NSString *newTweetId = [tweet objectForKey:@"id"];
	int tweetIndex = [self indexForId:newTweetId];
	if (tweetIndex == -1)
	{
		// the tweet has not been recorded

		// add an avatar image, then add it to the array
		[_tweets addObject:tweet];

		// now re-sort the tweets; index 0 has the newest tweet
		[self _sortTweets];
		
		// and remove any tweets past the save threshold
/*
TODO: Make the threshold a preference.
*/
		if ([_tweets count] > MAX_TWEET_COUNT)
		{
			[_tweets removeLastObject];
		}
		
		tweetWasAdded = YES;
		
		//NSLog(@"IFTweetModel: addTweet: newTweetId = %@, tweets = %@", newTweetId, _tweets);
	}
	
	return tweetWasAdded;
}

- (void)selectTweetWithIndex:(int)index
{
	if (index >= 0 && index < [[self tweets] count])
	{
		_selectionIndex = index;
	}
	else
	{
		_selectionIndex = -1;
	}
}

- (void)selectTweetWithId:(NSString *)tweetId
{
	[self selectTweetWithIndex:[self indexForId:tweetId]];
}

- (int)selectionIndex
{
	return _selectionIndex;
}


- (NSMutableDictionary *)selectedTweet
{
	if ([self selectionIndex] >= 0)
	{
		return [[self tweets] objectAtIndex:_selectionIndex];
	}
	else
	{
		return nil;
	}
}

- (NSMutableDictionary *)tweetAtIndex:(int)index
{
	if (index >= 0)
	{
		return [[self tweets] objectAtIndex:index];
	}
	else
	{
		return nil;
	}
}

- (int)tweetCount
{
	return [[self tweets] count];
}

@end
