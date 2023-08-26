//
//  UsersListTableViewCell.h
//  EmaarTestRaghav
//
//  Created by apple on 26/08/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UsersListTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *userImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *emailLabel;
@property (nonatomic, weak) IBOutlet UILabel *countryLabel;
@property (nonatomic, weak) IBOutlet UILabel *registeredDateLabel;

@end

NS_ASSUME_NONNULL_END
