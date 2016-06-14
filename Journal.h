//
//  Journal.h
//  Journal
//
//  Created by Adam on 1/4/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entry.h"

@interface Journal : NSObject

@property (copy, nonatomic, readonly) NSArray *entries;

- (void)addEntry:(Entry *)entry;
- (void)updateEntry:(Entry *)entry;

@end
