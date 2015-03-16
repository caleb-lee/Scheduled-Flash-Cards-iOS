//
//  Card.h
//  Scheduled Flash Cards
//
//  Created by Caleb Lee on 2015/03/16.
//  Copyright (c) 2015年 Caleb Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Deck;

@interface Card : NSManagedObject

@property (nonatomic, retain) NSString * back;
@property (nonatomic, retain) NSString * front;
@property (nonatomic, retain) NSNumber * interval;
@property (nonatomic, retain) NSDate * lastSeenDate;
@property (nonatomic, retain) NSDate * nextSeeDate;
@property (nonatomic, retain) Deck *deck;

@end
