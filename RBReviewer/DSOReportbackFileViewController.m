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
@property (weak, nonatomic) IBOutlet UILabel *rbfCaption;

@end

@implementation DSOReportbackFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [DSODoSomethingAPIClient getSingleInboxReportbackCompletionHandler:^(NSArray *response){
        NSLog(@"%@", response);
        [self updateDisplay:(NSDictionary *)response[0]];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateDisplay:(NSDictionary *)rbf
{
    self.rbfCaption.text = rbf[@"caption"];
    NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:rbf[@"src"]]];
    UIImage* image = [[UIImage alloc] initWithData:imageData];
    [self.rbfImage setImage:image];
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
