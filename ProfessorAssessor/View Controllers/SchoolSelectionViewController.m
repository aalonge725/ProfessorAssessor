@import DGActivityIndicatorView;
#import "SchoolSelectionViewController.h"
#import "SchoolCell.h"
#import "Networker.h"

@interface SchoolSelectionViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSArray<School *> *schools;
@property (nonatomic, strong) NSArray<School *> *filteredSchools;
@property (nonatomic, strong) DGActivityIndicatorView *activityIndicator;

@end

@implementation SchoolSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpActivityIndicator];

    [self fetchSchools];
}

- (void)fetchSchools {
    [self.activityIndicator startAnimating];

    __weak typeof(self) weakSelf = self;

    [Networker
     fetchSchoolsWithCompletion:^(NSArray<School *> *_Nullable schools,
                                  NSError *_Nullable error) {
        if (schools) {
            weakSelf.schools = schools;
            weakSelf.filteredSchools = self.schools;
            [weakSelf.tableView reloadData];
            [weakSelf.activityIndicator stopAnimating];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredSchools.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SchoolCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SchoolCell" forIndexPath:indexPath];

    School *school = self.filteredSchools[indexPath.row];
    [cell setSchool:school];
    [cell configureBackground];

    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate
                                  predicateWithBlock:^
                                  BOOL(id _Nullable evaluatedObject, NSDictionary<NSString *,id>
                                       *_Nullable bindings) {
            return [((School *)evaluatedObject).name containsString:searchText];
        }];
        self.filteredSchools = [self.schools filteredArrayUsingPredicate:predicate];
    } else {
        self.filteredSchools = self.schools;
    }
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    School *school = self.filteredSchools[indexPath.row];

    [self.delegate didSelectSchool:school];
}

- (void)setUpActivityIndicator {
    CGFloat width = self.view.bounds.size.width / 5.0f;
    self.activityIndicator = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallClipRotateMultiple tintColor:[UIColor systemTealColor] size:width];

    self.activityIndicator.frame = CGRectMake(self.view.center.x - width / 2, self.view.center.y - width / 2, width, width);

    [self.view addSubview:self.activityIndicator];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
}

@end
