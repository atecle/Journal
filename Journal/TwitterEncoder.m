//
//  TwitterEncoder.m
//  Journal
//
//  Created by Adam on 1/4/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import "TwitterEncoder.h"

@implementation TwitterEncoder

+ (NSInteger)characterCountForTextLength:(NSInteger)length numberOfPhotos:(NSInteger)numberOfPhotos
{
    return 140 - (length + (numberOfPhotos*22));
}

@end
