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
#import "DSODoSomethingAPIClient.h"

@interface DSODetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) NSMutableDictionary *reportbackFile;
@end

@implementation DSODetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    self.title = self.taxonomyTerm[@"name"];
    
    // @todo: Remove this once API is fixed to return numeric tid.
    NSString *tidString = (NSString *)self.taxonomyTerm[@"tid"];
    NSInteger tid = [tidString integerValue];
    
    DSODoSomethingAPIClient *client = [DSODoSomethingAPIClient sharedClient];
    [client getSingleInboxReportbackWithCompletionHandler:^(NSMutableArray *response){
        if ([response count] > 0) {
            self.reportbackFile = (NSMutableDictionary *)response[0];
            [self.tableView reloadData];
        }
        else {
            //[self updateDisplay:nil];
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
            cell.excludeButton.tag = 0;
            [cell.excludeButton addTarget:self action:@selector(review:) forControlEvents:UIControlEventTouchUpInside];
            cell.approveButton.tag = 10;
            [cell.approveButton addTarget:self action:@selector(review:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
    }
    return nil;
}

-(void)review:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    NSString *status = @"approved";
    if (senderButton.tag == 0) {
        status = @"excluded";
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
        [self viewDidLoad];
    } :values];
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
