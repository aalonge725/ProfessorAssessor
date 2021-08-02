#import <UIKit/UIKit.h>
#import "School.h"

NS_ASSUME_NONNULL_BEGIN

@interface SchoolCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UIView *background;

- (void)setSchool:(School *)school;
- (void)configureBackground;

@end

NS_ASSUME_NONNULL_END
