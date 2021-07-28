#import <UIKit/UIKit.h>
#import "Professor.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfessorSelectionCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UILabel *departmentName;

- (void)setProfessor:(Professor *)professor;

@end

NS_ASSUME_NONNULL_END
