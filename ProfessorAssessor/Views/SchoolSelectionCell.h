#import <UIKit/UIKit.h>
#import "School.h"

NS_ASSUME_NONNULL_BEGIN

@interface SchoolSelectionCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *address;

- (void)setSchool:(School *)school;

@end

NS_ASSUME_NONNULL_END
