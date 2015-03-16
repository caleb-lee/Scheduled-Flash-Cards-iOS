//
//  ScheduleController.h
//  Scheduled Flash Cards
//
//  Created by Caleb Lee on 2015/03/16.
//  Copyright (c) 2015年 Caleb Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface ScheduleController : NSObject

// this method schedules a card to a new time when handed the card and its difficulty
//  difficulty can range 0-3; 0 is wrong, 1 is hard, 2 is reasonable, 3 is easy
- (void)scheduleCard:(Card*)card withDifficulty:(NSInteger)difficulty;

// note: currently schedule controller uses fake values and is not actually based on the forgetting curve
//  this program is only a proof-of-concept

@end
