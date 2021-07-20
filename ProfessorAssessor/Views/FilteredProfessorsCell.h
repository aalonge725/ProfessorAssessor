#import <UIKit/UIKit.h>
#import "Professor.h"

NS_ASSUME_NONNULL_BEGIN

@interface FilteredProfessorsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *professorName;
@property (strong, nonatomic) IBOutlet UILabel *departmentName;
@property (strong, nonatomic) IBOutlet UIView *averageRating;

- (void)setProfessor:(Professor *)professor;

@end

NS_ASSUME_NONNULL_END
