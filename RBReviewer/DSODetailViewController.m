//
//  DSODetailViewController.m
//  RBReviewer
//
//  Created by Aaron Schachter on 1/22/15.
//  Copyright (c) 2015 DoSomething.org. All rights reserved.
//

#import "DSODetailViewController.h"
#import "DSODynamicTextTableViewCell.h"
#import "DSOImageTableViewCell.h"

@interface DSODetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DSODetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row==0)
//    {
//        return 300;
//    } else
//    {
//        return 44;
//    }
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row ==0) {
        DSOImageTableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:@"imageCell" forIndexPath:indexPath];
        return imageCell;
    } else
    {
        DSODynamicTextTableViewCell *textcell = [tableView dequeueReusableCellWithIdentifier:@"whyParticipatedCell" forIndexPath:indexPath];
        textcell.dynamicTextLabel.text = @"Lorem ipsum dolor sit amet, regione legimus his ei, tacimates definitiones ei qui, at vis velit debet liberavisse. Eu veri minim scripta eum. Et clita aeterno omittantur duo, convenire accusamus ex per. Vim in option aliquid assentior, ea civibus periculis maiestatis nam.Lorem ipsum dolor sit amet, regione legimus his ei, tacimates definitiones ei qui, at vis velit debet liberavisse. Eu veri minim scripta eum. Et clita aeterno omittantur duo, convenire accusamus ex per. Vim in option aliquid assentior, ea civibus periculis maiestatis nam.Lorem ipsum dolor sit amet, regione legimus his ei, tacimates definitiones ei qui, at vis velit debet liberavisse. Eu veri minim scripta eum. Et clita aeterno omittantur duo, convenire accusamus ex per. Vim in option aliquid assentior, ea civibus periculis maiestatis nam.Lorem ipsum dolor sit amet, regione legimus his ei, tacimates definitiones ei qui, at vis velit debet liberavisse. Eu veri minim scripta eum. Et clita aeterno omittantur duo, convenire accusamus ex per. Vim in option aliquid assentior, ea civibus periculis maiestatis nam.Lorem ipsum dolor sit amet, regione legimus his ei, tacimates definitiones ei qui, at vis velit debet liberavisse. Eu veri minim scripta eum. Et clita aeterno omittantur duo, convenire accusamus ex per. Vim in option aliquid assentior, ea civibus periculis maiestatis nam.Lorem ipsum dolor sit amet, regione legimus his ei, tacimates definitiones ei qui, at vis velit debet liberavisse. Eu veri minim scripta eum. Et clita aeterno omittantur duo, convenire accusamus ex per. Vim in option aliquid assentior, ea civibus periculis maiestatis nam.Lorem ipsum dolor sit amet, regione legimus his ei, tacimates definitiones ei qui, at vis velit debet liberavisse. Eu veri minim scripta eum. Et clita aeterno omittantur duo, convenire accusamus ex per. Vim in option aliquid assentior, ea civibus periculis maiestatis nam.";
        return textcell;
    }
   
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
