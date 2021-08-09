Original App Design Project
===

# ProfessorAssessor

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
ProfessorAssessor lets students find the right professors and courses for them by allowing students to read about the experiences of others and write about their own. In doing so, students can give each other a better idea of what to expect when taking a specific course with a specific professor.

### Video Walkthrough

<img src="https://github.com/aalonge725/ProfessorAssessor/blob/main/signup.gif" width="300">

<img src="https://github.com/aalonge725/ProfessorAssessor/blob/main/home.gif" width="300">

<img src="https://github.com/aalonge725/ProfessorAssessor/blob/main/professor-and-review-detail.gif" width="300">

<img src="https://github.com/aalonge725/ProfessorAssessor/blob/main/compose.gif" width="300">

<img src="https://github.com/aalonge725/ProfessorAssessor/blob/main/profile.gif" width="300">

### App Evaluation
- **Category:** Education
- **Mobile:** Used a flow that feels more proper for an app than a website.
- **Story:** Makes it easier for students to pick the right professor and course options available.
- **Market:** Students, particularly college students.
- **Habit:** Users may periodically use this app when making posts, and may frequently use it at the beginning of a new semester when trying to make their ideal schedule.
- **Scope:** A stripped-down version would still be interesting to build and there are a couple of ways to expand the scope of the app (ex. special options for professors using the app).

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- [x] User can log in
- [x] User can create a new account
- [x] User can search for professor
- [x] User can see reviews made about a professor
- [x] User can compose a review for a professor
- [x] User can see a professor's detail page that includes reviews made about the professor

**Optional Nice-to-have Stories**

- [x] User can log in with Facebook
- [x] User can sort professors
- [x] User can filter reviews for a professor by course
- [x] User can see their profile page
- [x] User can see a review's detail page
- [x] User can like or dislike other students' reviews


### 2. Screen Archetypes

* Login screen
    * User can login
* Registration screen
    * User can create a new account
* Search
    * User can search for a school or professor
* Stream
    * User can see reviews made about a professor
* Create
    * User can compose a review for a professor


### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home
* Profile

**Flow Navigation** (Screen to Screen)

* Authentication screen
    * Login
    * Signup
* Login screen
    * Home
* Signup screen
    * Home
* Home
    * Search
    * Create
* Search
    * Stream
* Stream
    * Detail
    * Create
* Detail
    * Stream
* Create
    * Stream
* Profile
    * Detail

## Wireframes
<img src="https://github.com/aalonge725/ProfessorAssessor/blob/develop/wireframe.JPG" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models

#### User
   | Property        | Type                        | Description                                                    |
   | --------------- | --------------------------- | -------------------------------------------------------------- |
   | objectID        | String                      | Unique id for the user (default field)                         |
   | createdAt       | DateTime                    | Date when user is created (default field)                      |
   | updatedAt       | DateTime                    | Date when user is last updated (default field)                 |
   | username        | String                      | User’s username                                                |
   | firstName       | String                      | User’s first name                                              |
   | lastName        | String                      | User’s last name                                               |
   | password        | String                      | User’s password                                                |
   | email           | String                      | User's email                                                   |
   | school          | Pointer to School           | User’s school                                                  |
   | reviews         | Array<Pointer to Review>    | List of reviews made by user                                   |
   | likedReviews    | Array<Pointer to Review>    | User’s liked reviews                                           |
   | dislikedReviews | Array<Pointer to Review>    | User’s disliked reviews                                        |

   
#### School

   | Property    | Type                        | Description                                      |
   | ----------- | --------------------------- | ------------------------------------------------ |
   | objectID    | String                      | Unique id for the school (default field)         |
   | createdAt   | DateTime                    | Date when school is created (default field)      |
   | updatedAt   | DateTime                    | Date when school is last updated (default field) |
   | name        | String                      | School’s name                                    |
   | professors  | Array<Pointer to Professor> | List of school’s professors                      |
   | city        | String                      | School’s city                                    |
   | state       | String                      | School’s state                                   |
   
#### Professor

   | Property            | Type                     | Description                                                 |
   | ------------------- | ------------------------ | ----------------------------------------------------------- |
   | objectID            | String                   | Unique id for the professor (default field)                 |
   | createdAt           | DateTime                 | Date when professor is created (default field)              |
   | updatedAt           | DateTime                 | Date when professor is last updated (default field)         |
   | name                | String                   | Professor’s name                                            |
   | courses             | Array<Pointer to Course> | List of courses a professor has taught or currently teaches |
   | departmentName      | String                   | Professor’s department                                      |
   | averageRating       | Number                   | Average rating for professor from their reviews             |
   
#### Review

   | Property  | Type                 | Description                                      |
   | --------- | -------------------- | ------------------------------------------------ |
   | objectID  | String               | Unique id for the review (default field)         |
   | createdAt | DateTime             | Date when review is created (default field)      |
   | updatedAt | DateTime             | Date when review is last updated (default field) |
   | reviewer  | Pointer to User      | User who made the review                         |
   | course    | Course               | Course that the review is about                  |
   | rating    | Number               | Rating for a professor for a specific course     |
   | content   | String               | Text of a review made by a user                  |
   | professor | Pointer to Professor | The professor that a review is about             |
   | likes     | Number               | Number of likes a review has                     |
   | dislikes  | Number               | Number of dislikes a review has                  |
   
#### Course

   | Property  | Type          | Description                                      |
   | --------- | ------------- | ------------------------------------------------ |
   | objectID  | String        | Unique id for the course (default field)         |
   | createdAt | DateTime      | Date when course is created (default field)      |
   | updatedAt | DateTime      | Date when course is last updated (default field) |
   | name      | String        | Course’s name                                    |
   | reviews   | Array<Review> | Reviews made by users for a course               |

### Networking

* Signup screen
    * (GET) Query list of schools in the database
* Home screen
    * (GET) Query professors that teach at the school selected by the user
* Reviews screen
    * (GET) Query reviews where professor is the one selected by the user
    * (POST) Create a rating on a post
* Create screen
    * (POST) Create a new review object
* Profile screen
    * (GET) Query logged in user object
   
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
