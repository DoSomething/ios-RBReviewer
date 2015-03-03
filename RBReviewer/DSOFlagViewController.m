//
//  DSOFlagViewController.m
//  RBReviewer
//
//  Created by Aaron Schachter on 1/21/15.
//  Copyright (c) 2015 DoSomething.org. All rights reserved.
//

#import "DSOFlagViewController.h"
#import <TSMessage.h>

@interface DSOFlagViewController ()
@property (strong, nonatomic) NSMutableArray *options;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationItem *saveButton;

@end

@implementation DSOFlagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.deleteImage = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.options = [[NSMutableArray alloc] init];
    NSMutableDictionary *d1 = [[NSMutableDictionary alloc] init];
    d1[@"label"] = @"Irrelevant";
    d1[@"key"] = @"irrelevant";
    d1[@"checked"] = [NSNumber numberWithInt:0];
    [self.options addObject:d1];
    NSMutableDictionary *d2 = [[NSMutableDictionary alloc] init];
    d2[@"label"] = @"Inappropriate";
    d2[@"key"] = @"inappropriate";
    d2[@"checked"] = [NSNumber numberWithInt:0];
    [self.options addObject:d2];
    NSMutableDictionary *d3 = [[NSMutableDictionary alloc] init];
    d3[@"label"] = @"Unrealistic quantity";
    d3[@"key"] = @"inappropriate";
    d3[@"checked"] = [NSNumber numberWithInt:0];
    [self.options addObject:d3];
    NSMutableDictionary *d4 = [[NSMutableDictionary alloc] init];
    d4[@"label"] = @"Delete this image";
    d4[@"key"] = @"delete";
    d4[@"checked"] = [NSNumber numberWithInt:0];
    [self.options addObject:d4];
    self.screenName = @"Flag";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.options count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    NSDictionary *option = [self.options objectAtIndex:indexPath.row];
    cell.textLabel.text = option[@"label"];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    NSMutableDictionary *option = (NSMutableDictionary *)self.options[indexPath.row];
    NSString *key = [option objectForKey:@"key"];


    cell.accessoryType = UITableViewCellAccessoryCheckmark;

    BOOL checked = [[option objectForKey:@"checked"] boolValue];
    if (!checked) {
        cell.imageView.image = [UIImage imageNamed:@"approved.png"];
        option[@"checked"] = [NSNumber numberWithInt:1];
        if ([key isEqualToString:@"delete"]) {
            [TSMessage showNotificationInViewController:self
                                                  title:@"Delete Image"
                                               subtitle:@"Are you sure? This cannot be undone."
                                                  image:nil
                                                   type:TSMessageNotificationTypeWarning
                                               duration:TSMessageNotificationDurationAutomatic
                                               callback:nil
                                            buttonTitle:@"Ok"
                                         buttonCallback:nil
                                             atPosition:TSMessageNotificationPositionBottom
                                   canBeDismissedByUser:YES];
            self.deleteImage = YES;
        }
    }
    else {
        cell.imageView.image = nil;
        option[@"checked"] = [NSNumber numberWithInt:0];
        if ([key isEqualToString:@"delete"]) {
            self.deleteImage = NO;
        }
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSMutableArray *reasons = [[NSMutableArray alloc] init];
    // Get the new view controller using [segue destinationViewController].
    // Loop through all of the options to see which were checked.
    for (NSMutableDictionary *option in self.options) {
        if ([[option objectForKey:@"checked"] boolValue]) {
            [reasons addObject:option[@"key"]];
        }
    }
    self.flaggedReason = [reasons componentsJoinedByString:@", "];
}


@end
