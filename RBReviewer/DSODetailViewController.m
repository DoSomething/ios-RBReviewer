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
#import "DSOReviewTableViewCell.h"
#import "DSOTitleTableViewCell.h"
#import "DSODynamicTextTableViewCell.h"
#import "DSOImageTableViewCell.h"
#import "DSOFlagViewController.h"
#import "DSODoSomethingAPIClient.h"
#import "DSOInboxZeroView.h"
#import <TSMessage.h>

@interface DSODetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary *reportbackFile;
@property (weak, nonatomic) IBOutlet DSOInboxZeroView *inboxZeroView;

@end

@implementation DSODetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inboxZeroView.hidden = TRUE;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = TRUE;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    self.title = self.taxonomyTerm[@"name"];
    self.screenName = self.title;
    [self updateTableView];
}

- (void)updateTableView {
    // @todo: Remove this once API is fixed to return numeric tid.
    NSString *tidString = (NSString *)self.taxonomyTerm[@"tid"];
    NSInteger tid = [tidString integerValue];

    DSODoSomethingAPIClient *client = [DSODoSomethingAPIClient sharedClient];
    [client getSingleInboxReportbackWithCompletionHandler:^(NSMutableArray *response){
        if ([response count] > 0) {
            self.reportbackFile = (NSMutableDictionary *)response[0];
            [self.tableView reloadData];
            self.inboxZeroView.hidden = TRUE;
            self.tableView.hidden = FALSE;
        }
        else {
            self.tableView.hidden = TRUE;
            self.inboxZeroView.hidden = FALSE;
        }
    } andTid:tid];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
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

        case 1: {
            DSOImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell" forIndexPath:indexPath];
            NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:self.reportbackFile[@"src"]]];
            UIImage* image = [[UIImage alloc] initWithData:imageData];
            cell.fullSizeImageView.image = image;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        case 2: {
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
        case 3: {
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
        case 5: {
            DSOReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reviewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            cell.excludeButton.tag = 0;
            [cell.excludeButton addTarget:self action:@selector(review:) forControlEvents:UIControlEventTouchUpInside];

            cell.approveButton.tag = 10;
            [cell.approveButton addTarget:self action:@selector(review:) forControlEvents:UIControlEventTouchUpInside];

            cell.promoteButton.tag = 20;
            [cell.promoteButton addTarget:self action:@selector(review:) forControlEvents:UIControlEventTouchUpInside];
            
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
    DSODoSomethingAPIClient *client = [DSODoSomethingAPIClient sharedClient];
    [client postReportbackReviewWithCompletionHandler:^(NSArray *response){
        [self displayStatusMessage:@"flagged"];
        [self updateTableView];
    } :values];
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
    NSDictionary *values = @{
                             @"fid":self.reportbackFile[@"fid"],
                             @"status":status,
                             @"source":@"ios"
                             };

    DSODoSomethingAPIClient *client = [DSODoSomethingAPIClient sharedClient];
    [client postReportbackReviewWithCompletionHandler:^(NSArray *response){
        [self displayStatusMessage:status];
        [self updateTableView];
    } :values];
}

- (void) displayStatusMessage:(NSString *)status {
    NSString *title = [NSString stringWithFormat:@"Reportback %@ %@.", self.reportbackFile[@"fid"], status];
    NSString *filename = [NSString stringWithFormat:@"%@.png", status];
    
    [TSMessage showNotificationInViewController:self
                                          title:title
                                       subtitle:nil
                                          image:[UIImage imageNamed:filename]
                                           type:TSMessageNotificationTypeSuccess
                                       duration:TSMessageNotificationDurationAutomatic
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:TSMessageNotificationPositionBottom
                           canBeDismissedByUser:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
