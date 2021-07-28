#import <UIKit/UIKit.h>
#import "Professor.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ProfessorSelectionViewControllerDelegate

- (void)didSelectProfessor:(Professor *)professor;

@end

@interface ProfessorSearchViewController : UIViewController

@property (nonatomic, weak) id<ProfessorSelectionViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray<Professor *> *professors;

@end

NS_ASSUME_NONNULL_END
