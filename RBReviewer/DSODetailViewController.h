//
//  DSODetailViewController.h
//  RBReviewer
//
//  Created by Aaron Schachter on 1/22/15.
//  Copyright (c) 2015 DoSomething.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface DSODetailViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableDictionary *taxonomyTerm;
@property (assign, nonatomic) NSInteger inboxCount;

- (IBAction)unwindToDetail:(UIStoryboardSegue *)segue;
@end
