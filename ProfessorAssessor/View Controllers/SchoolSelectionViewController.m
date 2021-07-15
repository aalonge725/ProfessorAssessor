#import "SchoolSelectionViewController.h"
#import "Networker.h"
#import "SchoolSelectionCell.h"
#import "School.h"

@interface SchoolSelectionViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray<School *> *schools;
@property (strong, nonatomic) NSArray<School *> *filteredSchools;

@end

@implementation SchoolSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self fetchSchools];
}

- (void)fetchSchools {
    PFQuery *schoolQuery = [School query];

    [schoolQuery orderByAscending:@"name"];
    [schoolQuery includeKey:@"professors"];

    [schoolQuery findObjectsInBackgroundWithBlock:^(NSArray<School *> *_Nullable schools, NSError *_Nullable error) {
        if (schools) {
            self.schools = schools;
            self.filteredSchools = self.schools;
            [self.tableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredSchools.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SchoolSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SchoolSelectionCell" forIndexPath:indexPath];

    School *school = self.filteredSchools[indexPath.row];
    [cell setSchool:school];

    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id _Nullable evaluatedObject, NSDictionary<NSString *,id> *_Nullable bindings) {
            return [((School *)evaluatedObject).name containsString:searchText];
        }];
        self.filteredSchools = [self.schools filteredArrayUsingPredicate:predicate];

        for (School *school in self.filteredSchools) {
            NSLog(@"%@ :- %@", school.name, school.address);
        }
    } else {
        self.filteredSchools = self.schools;
    }
    [self.tableView reloadData];
}

@end
