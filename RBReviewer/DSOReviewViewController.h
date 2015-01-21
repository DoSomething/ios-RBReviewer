//
//  DSOReportbackFileViewController.h
//  RBReviewer
//
//  Created by Aaron Schachter on 12/22/14.
//  Copyright (c) 2014 DoSomething.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSOReviewViewController : UIViewController

@property (strong, nonatomic) NSMutableDictionary *reportbackFile;
@property (strong, nonatomic) NSMutableDictionary *taxonomyTerm;
- (IBAction)unwindToList:(UIStoryboardSegue *)segue;
@end
