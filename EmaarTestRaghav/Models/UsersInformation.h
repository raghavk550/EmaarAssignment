//
//  UsersInformation.h
//  EmaarTestRaghav
//
//  Created by apple on 26/08/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UsersInformation : NSObject

@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *postCode;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *dobDate;
@property (nonatomic, strong) NSNumber *dobAge;
@property (nonatomic, strong) NSString *registeredDate;
@property (nonatomic, strong) NSString *pictureLarge;
@property (nonatomic, strong) NSString *pictureMedium;

@end

NS_ASSUME_NONNULL_END
