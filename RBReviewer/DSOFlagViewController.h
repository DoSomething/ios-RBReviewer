//
//  DSOFlagViewController.h
//  RBReviewer
//
//  Created by Aaron Schachter on 1/21/15.
//  Copyright (c) 2015 DoSomething.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSOFlagViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSString *flaggedReason;
@property(nonatomic, assign) BOOL deleteImage;

@end
