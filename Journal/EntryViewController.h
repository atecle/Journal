//
//  EntryViewController.h
//  Journal
//
//  Created by Adam on 1/4/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Journal.h"
#import "Entry.h"
#import "TwitterEncoder.h"

extern NSString *const EntryViewControllerIdentifier;

@class EntryViewController;

@protocol EntryViewControllerDelegate <NSObject>

- (void)entryViewController:(EntryViewController *)viewController didCreateEntry:(Entry *)entry;
- (void)entryViewController:(EntryViewController *)viewController didUpdateEntry:(Entry *)entry;
- (void)entryViewControllerDidCancel:(EntryViewController *)viewController;

@end


@interface EntryViewController : UIViewController

@property (copy, nonatomic) Entry *entry;
@property (weak, nonatomic) id<EntryViewControllerDelegate> delegate;

@end
