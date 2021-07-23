#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FacebookUser : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;

+ (FacebookUser *)createUserWithFirstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email;

@end

NS_ASSUME_NONNULL_END
