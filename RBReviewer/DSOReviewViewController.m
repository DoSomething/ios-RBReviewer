//
//  DSOReportbackFileViewController.m
//  RBReviewer
//
//  Created by Aaron Schachter on 12/22/14.
//  Copyright (c) 2014 DoSomething.org. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "DSOReviewViewController.h"
#import "DSODoSomethingAPIClient.h"

@interface DSOReviewViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *rbfImage;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *fidLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *participatedText;
@property (weak, nonatomic) IBOutlet UIButton *excludeButton;
@property (weak, nonatomic) IBOutlet UIButton *approveButton;
@property (weak, nonatomic) IBOutlet UIButton *flagButton;
@property (weak, nonatomic) IBOutlet UIButton *promoteButton;

- (IBAction)approveTapped:(id)sender;
- (IBAction)excludeTapped:(id)sender;
- (IBAction)flagTapped:(id)sender;
- (IBAction)promoteTapped:(id)sender;

@end

@implementation DSOReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _approveButton.layer.cornerRadius = 10;
    _approveButton.clipsToBounds = YES;
    _excludeButton.layer.cornerRadius = 10;
    _excludeButton.clipsToBounds = YES;
    _flagButton.layer.cornerRadius = 10;
    _flagButton.clipsToBounds = YES;
    _promoteButton.layer.cornerRadius = 10;
    _promoteButton.clipsToBounds = YES;
    self.title = self.taxonomyTerm[@"name"];

    // @todo: Remove this once API is fixed to return numeric tid.
    NSString *tidString = (NSString *)self.taxonomyTerm[@"tid"];
    NSInteger tid = [tidString integerValue];
    
    DSODoSomethingAPIClient *client = [DSODoSomethingAPIClient sharedClient];
    [client getSingleInboxReportbackWithCompletionHandler:^(NSMutableArray *response){
        if ([response count] > 0) {
            [self updateDisplay:(NSMutableDictionary *)response[0]];
        }
        else {
            [self updateDisplay:nil];
        }
    } andTid:tid];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateDisplay:(NSMutableDictionary *)values
{
    if (values == nil) {
        self.participatedText.text = @"No pending reportbacks.";
        return;
    }
    NSString *caption = (NSString *)values[@"caption"];
    if (caption == (id)[NSNull null] || caption.length == 0) {
        self.captionLabel.text = @"(No caption)";
    }
    else {
        self.captionLabel.text = caption;
    }

    self.fidLabel.text = [NSString stringWithFormat:@"rb/%@", values[@"fid"]];
    self.participatedText.text = values[@"why_participated"];
    self.quantityLabel.text = [NSString stringWithFormat:@"%@", values[@"quantity"]];
    self.titleLabel.text = values[@"title"];
    
    NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:values[@"src"]]];
    UIImage* image = [[UIImage alloc] initWithData:imageData];
    [self.rbfImage setImage:image];
}


- (IBAction)approveTapped:(id)sender {
    [self postReview:@"approved"];
}

- (IBAction)excludeTapped:(id)sender {
    [self postReview:@"excluded"];
}

- (IBAction)flagTapped:(id)sender {
    [self postReview:@"flagged"];
}

- (IBAction)promoteTapped:(id)sender {
    [self postReview:@"promoted"];
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
