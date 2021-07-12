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
ProfessorAssessor lets students find the right professors and courses for them by allowing students to periodically share experiences in the courses. In doing so, students can give each other a better idea of what to expect when taking a specific course with a specific professor.

### App Evaluation
- **Category:** Education
- **Mobile:** Utilizes push notifications for periodic reminders to post experiences and alerts for when a post is made under a course that a student is following.
- **Story:** Makes it easier for students to pick the right professor and course options available.
- **Market:** Students, particularly college students.
- **Habit:** Users may periodically use this app when making posts, and may frequently use it at the beginning of a new semester when determining trying to make their ideal schedule.
- **Scope:** A stripped-down version would still be interesting to build and there are a couple of ways to expand the scope of the app (ex. special options for professors using the app).

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- [ ] User can login
- [ ] User can create a new account
- [ ] User can search for professor
- [ ] User can see reviews made about a professor
- [ ] User can compose a review for a professor

**Optional Nice-to-have Stories**

- [ ] User can filter reviews
- [ ] User can see a professor's profile page
- [ ] User can see their profile page
- [ ] User can see the profile page of other students, including a history of the students' reviews
- [ ] User can rate other students' reviews
- [ ] User can receive push notifications for new reviews and reminders for posting


### 2. Screen Archetypes

* Login screen
    * User can login
* Registration screen
    * User can create a new account
* Search
    * User can search for a professor
* Stream
    * User can see reviews made about a professor
* Create
    * User can compose a review for a professor


### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home
* Search
* Create

**Flow Navigation** (Screen to Screen)

* Login screen
    * Home
* Registration screen
    * Home
* Search
    * Stream
* Stream
    * Create
* Create
    * Stream

## Wireframes
<img src="https://github.com/aalonge725/ProfessorAssessor/blob/develop/wireframe.jpg" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models

#### User
   | Property    | Type                        | Description                                                    |
   | ----------- | --------------------------- | -------------------------------------------------------------- |
   | objectID    | String                      | Unique id for the user (default field)                         |
   | createdAt   | DateTime                    | Date when user is created (default field)                      |
   | updatedAt   | DateTime                    | Date when user is last updated (default field)                 |
   | username    | String                      | User’s username                                                |
   | firstName   | String                      | User’s first name                                              |
   | lastName    | String                      | User’s last name                                               |
   | password    | String                      | User’s password                                                |
   | school      | Pointer to School           | User’s school                                                  |
   | profList    | Array<Pointer to Professor> | List of professors a user has had or currently has             |
   | programs    | Array<String>               | Programs of study that user majors, minors, or has interest in |
   | reviewCount | Number                      | Number of reviews a user has posted                            |
   | reviews     | Array<Pointer to Review>    | List of reviews made by user                                   |

   
#### School

   | Property  | Type                        | Description                                      |
   | --------- | --------------------------- | ------------------------------------------------ |
   | objectID  | String                      | Unique id for the school (default field)         |
   | createdAt | DateTime                    | Date when school is created (default field)      |
   | updatedAt | DateTime                    | Date when school is last updated (default field) |
   | name      | String                      | School’s name                                    |
   | profList  | Array<Pointer to Professor> | List of school’s professors                      |
   | address   | String                      | School’s address                                 |
   | programs  | Array<String>               | Programs of study available at the school        |
   
#### Professor

   | objectID        | String                   | Unique id for the professor (default field)                 |
   | --------------- | ------------------------ | ----------------------------------------------------------- |
   | createdAt       | DateTime                 | Date when professor is created (default field)              |
   | updatedAt       | DateTime                 | Date when professor is last updated (default field)         |
   | name            | String                   | Professor’s name                                            |
   | reviewsByCourse | Array<Pointer to Course> | List of courses a professor has taught or currently teaches |
   | department      | String                   | Professor’s department                                      |
   | reviewCount     | Number                   | Number of reviews a professor has received                  |
   | avgRating       | Number                   | Average rating for professor from their reviews             |
   
#### Review

   | Property  | Type                 | Description                                      |
   | --------- | -------------------- | ------------------------------------------------ |
   | objectID  | String               | Unique id for the review (default field)         |
   | createdAt | DateTime             | Date when review is created (default field)      |
   | updatedAt | DateTime             | Date when review is last updated (default field) |
   | author    | Pointer to User      | User who made the review                         |
   | course    | String               | Course that the review is about                  |
   | rating    | Number               | Rating for a professor for a specific course     |
   | content   | String               | Text of a review made by a user                  |
   | professor | Pointer to Professor | The professor that a review is about             |
   
#### Course

   | Property  | Type          | Description                                      |
   | --------- | ------------- | ------------------------------------------------ |
   | objectID  | String        | Unique id for the course (default field)         |
   | createdAt | DateTime      | Date when course is created (default field)      |
   | updatedAt | DateTime      | Date when course is last updated (default field) |
   | name      | String        | Course’s name                                    |
   | reviews   | Array<Review> | Reviews made by users for a course               |

### Networking

* Reviews screen
    * (GET) Query all reviews where professor is the one selected by the user
    * (POST) Create a rating on a post
    * (DELETE) Delete an existing rating
* Create screen
    * (POST) Create a new review object
* Profile screen
    * (GET) Query logged in user object
   
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
