#import "FacebookUser.h"

@implementation FacebookUser

+ (FacebookUser *)createUserWithFirstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email {
    FacebookUser *user = [FacebookUser new];

    user.firstName = firstName;
    user.lastName = lastName;
    user.email = email;

    return user;
}

@end
