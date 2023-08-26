//
//  ViewController.h
//  EmaarTestRaghav
//
//  Created by apple on 26/08/23.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

- (void)callUserListApi;

@end

