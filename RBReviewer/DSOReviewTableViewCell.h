//
//  DSOReviewTableViewCell.h
//  RBReviewer
//
//  Created by Aaron Schachter on 1/26/15.
//  Copyright (c) 2015 DoSomething.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSOReviewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *approveButton;
@property (weak, nonatomic) IBOutlet UIButton *excludeButton;
@property (weak, nonatomic) IBOutlet UIButton *flagButton;
@property (weak, nonatomic) IBOutlet UIButton *promoteButton;

@end
