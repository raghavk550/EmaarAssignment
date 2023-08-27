//
//  ViewController.h
//  EmaarTestRaghav
//
//  Created by apple on 26/08/23.
//

#import <UIKit/UIKit.h>
#import "ViewModel.h"

@class ViewModel;

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) ViewModel *viewModel;

@end

