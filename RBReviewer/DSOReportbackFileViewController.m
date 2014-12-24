//
//  DSOReportbackFileViewController.m
//  RBReviewer
//
//  Created by Aaron Schachter on 12/22/14.
//  Copyright (c) 2014 DoSomething.org. All rights reserved.
//

#import "DSOReportbackFileViewController.h"
#import "DSODoSomethingAPIClient.h"

@interface DSOReportbackFileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *rbfImage;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *fidLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *participatedText;

- (IBAction)approveTapped:(id)sender;
- (IBAction)excludeTapped:(id)sender;

@end

@implementation DSOReportbackFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"All campaigns";
    DSODoSomethingAPIClient *client = [DSODoSomethingAPIClient sharedClient];
    [client getSingleInboxReportbackCompletionHandler:^(NSMutableArray *response){
        self.reportbackFile = (NSMutableDictionary *)response[0];
        [self updateDisplay];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateDisplay
{
    self.captionLabel.text = self.reportbackFile[@"caption"];
    self.fidLabel.text = [NSString stringWithFormat:@"rb/%@", self.reportbackFile[@"fid"]];
    self.participatedText.text = self.reportbackFile[@"why_participated"];
    self.quantityLabel.text = [NSString stringWithFormat:@"%@", self.reportbackFile[@"quantity"]];
    self.titleLabel.text = self.reportbackFile[@"title"];
    
    NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:self.reportbackFile[@"src"]]];
    UIImage* image = [[UIImage alloc] initWithData:imageData];
    [self.rbfImage setImage:image];
}


- (IBAction)approveTapped:(id)sender {
    [self postReview:@"approved"];
}

- (IBAction)excludeTapped:(id)sender {
    [self postReview:@"excluded"];
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
@end
