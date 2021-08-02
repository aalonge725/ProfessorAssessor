#import <UIKit/UIKit.h>
#import "Professor.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfessorSelectionCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UILabel *departmentName;
@property (strong, nonatomic) IBOutlet UIView *background;

- (void)setProfessor:(Professor *)professor;
- (void)configureBackground;

@end

NS_ASSUME_NONNULL_END
