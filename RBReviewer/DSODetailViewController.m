//
//  DSODetailViewController.m
//  RBReviewer
//
//  Created by Aaron Schachter on 1/22/15.
//  Copyright (c) 2015 DoSomething.org. All rights reserved.
//

#import "DSODetailViewController.h"
#import "DSOCaptionTableViewCell.h"
#import "DSOQuantityTableViewCell.h"
#import "DSOTitleTableViewCell.h"
#import "DSODynamicTextTableViewCell.h"
#import "DSOImageTableViewCell.h"
#import "DSOFlagViewController.h"
#import "DSOInboxZeroView.h"

#import <SlothKit/DSOClient.h>
#import <TSMessage.h>

@interface DSODetailViewController ()
@property (strong, nonatomic) DSOClient *client;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *approveButton;
@property (weak, nonatomic) IBOutlet UIButton *excludeButton;
@property (weak, nonatomic) IBOutlet UIButton *flagButton;
@property (weak, nonatomic) IBOutlet UIButton *promoteButton;
@property (strong, nonatomic) NSMutableArray *actionButtons;
@property (strong, nonatomic) NSMutableDictionary *reportbackFile;
@property (weak, nonatomic) IBOutlet DSOInboxZeroView *inboxZeroView;
- (IBAction)excludeTapped:(id)sender;
- (IBAction)approveTapped:(id)sender;
- (IBAction)promoteTapped:(id)sender;

@end

@implementation DSODetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.client = [DSOClient sharedClient];
    self.inboxZeroView.hidden = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;

    self.screenName = self.taxonomyTerm[@"name"];
    [self updateTitle];
    [self updateTableView];
    [TSMessage setDelegate:self.navigationController];
    self.actionButtons = [[NSMutableArray alloc] initWithObjects:self.approveButton,self.excludeButton,self.flagButton,self.promoteButton, nil];
    [self hideButtons:YES];
}

- (void) updateTitle {
    self.title = [NSString stringWithFormat:@"%@ (%li)", self.taxonomyTerm[@"name"], self.inboxCount];
}

- (void) hideButtons:(BOOL)isHidden {
    for (UIButton *button in self.actionButtons) {
        button.hidden = isHidden;
    }
}

- (void)updateTableView {
    NSString *tidString = (NSString *)self.taxonomyTerm[@"tid"];
    NSInteger tid = [tidString integerValue];

    [self.client getSingleInboxReportbackForTid:tid completionHandler:^(NSMutableArray *response){
        if ([response count] > 0) {
            self.reportbackFile = (NSMutableDictionary *)response[0];
            [self.tableView reloadData];
            self.inboxZeroView.hidden = YES;
            self.tableView.hidden = NO;
            [self hideButtons:NO];
        }
        else {
            self.tableView.hidden = YES;
            self.inboxZeroView.hidden = NO;
            [self hideButtons:YES];
        }
    } errorHandler:^(NSError *error){
        [TSMessage showNotificationInViewController:self
                                              title:@"Aw, shit"
                                           subtitle:error.localizedDescription
                                               type:TSMessageNotificationTypeError];
    }];

    // Set TableFooterView to avoid repeating seperator lines.
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.row) {
        case 0: {
            DSOTitleTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"titleCell" forIndexPath:indexPath];
            cell.titleLabel.text = self.reportbackFile[@"title"];
            cell.titleLabel.textAlignment = NSTextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }

        case 2: {
            DSOImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell" forIndexPath:indexPath];
            NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:self.reportbackFile[@"src"]]];
            UIImage* image = [[UIImage alloc] initWithData:imageData];
            cell.fullSizeImageView.image = image;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        case 3: {
            DSOCaptionTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"captionCell" forIndexPath:indexPath];
            
            if ([self.reportbackFile[@"caption"] isEqualToString:@""]) {
                cell.captionLabel.text = @"(No caption)";
            } else {
                cell.captionLabel.text = self.reportbackFile[@"caption"];
            }
            
            cell.captionLabel.textAlignment = NSTextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        case 1: {
            DSOQuantityTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"quantityCell" forIndexPath:indexPath];
            cell.quantityLabel.text = nil;
            if (self.reportbackFile[@"quantity"] != nil) {
                cell.quantityLabel.text = [NSString stringWithFormat:@"%@ %@", self.reportbackFile[@"quantity"], self.reportbackFile[@"quantity_label"]];
            }
            cell.quantityLabel.textAlignment = NSTextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }

        case 4: {
            DSODynamicTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"whyParticipatedCell" forIndexPath:indexPath];
            cell.dynamicTextLabel.text = self.reportbackFile[@"why_participated"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    return nil;
}

- (IBAction)unwindToDetail:(UIStoryboardSegue *)segue {
    DSOFlagViewController *source = [segue sourceViewController];
    NSDictionary *values = @{
                             @"fid":self.reportbackFile[@"fid"],
                             @"status":@"flagged",
                             @"flagged_reason":source.flaggedReason,
                             @"delete":[NSNumber numberWithBool:source.deleteImage],
                             @"source":@"ios"
                             };

    [self.client postReportbackItemReviewWithValues:values completionHandler:^(NSArray *response){
        [self displayStatusMessage:@"flagged"];
        [self updateTableView];
        int newValue = (int)self.inboxCount;
        self.inboxCount = newValue - 1;
        [self updateTitle];
    }];
}

-(void)review:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    NSString *status = @"approved";
    if (senderButton.tag == 0) {
        status = @"excluded";
    }
    else if (senderButton.tag == 20) {
        status = @"promoted";
    }
    [self postReview:status];
}

- (void) postReview:(NSString *)status
{
    self.tableView.hidden = YES;
    [self hideButtons:YES];
    NSDictionary *values = @{
                             @"fid":self.reportbackFile[@"fid"],
                             @"status":status,
                             @"source":@"ios"
                             };

    [self.client postReportbackItemReviewWithValues:values completionHandler:^(NSArray *response){
        [self displayStatusMessage:status];
        int newValue = (int)self.inboxCount;
        self.inboxCount = newValue - 1;
        [self updateTitle];
        [self updateTableView];
    }];
}

- (void) displayStatusMessage:(NSString *)status {
    NSString *title = [NSString stringWithFormat:@"Reportback %@ %@.", self.reportbackFile[@"fid"], status];
    NSString *filename = [NSString stringWithFormat:@"%@.png", status];

    NSTimeInterval duration = 3;
    [TSMessage showNotificationInViewController:[TSMessage defaultViewController]
                                          title:title
                                       subtitle:nil
                                          image:[UIImage imageNamed:filename]
                                           type:TSMessageNotificationTypeSuccess
                                       duration:duration
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:TSMessageNotificationPositionTop
                           canBeDismissedByUser:YES];
    
    [self.tableView setContentOffset:CGPointZero animated:YES];
}

- (IBAction)excludeTapped:(id)sender {
    [self postReview:@"excluded"];
}

- (IBAction)approveTapped:(id)sender {
    [self postReview:@"approved"];
}

- (IBAction)promoteTapped:(id)sender {
    [self postReview:@"promoted"];
}
@end
