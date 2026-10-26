# Requirements and User Stories

## 1. Introduction

### 1.1 Purpose

Find My is a system designed to help students find lost items at the university. It allows users to report items they have lost or found and search through existing reports.

The main goal is to make the lost-and-found process easier, faster, and more organized while reducing false ownership claims and protecting private item details.

### 1.2 Scope

The system will focus on reporting, searching for, and managing lost and found items within the university.

Users will be able to add information about items, view reports, and update their reports when necessary. Some item details will only be visible to authorized users or the person who submitted the report. University staff will also be able to review reports and help verify ownership claims.

## 2. Overall Description

### 2.1 Product Perspective

Find My is a proposed system for managing lost and found items at the university. It aims to provide one place where students can report missing belongings and check whether someone has found them.

To reduce false ownership claims, the system will not display all item details publicly. Some details can be kept private and used to help check whether a person claiming an item is its real owner.

### 2.2 User Classes

The main users of the system are:

- **Students:** They can report lost or found items, search for items, and view publicly available report details.
- **University Staff:** They can review and manage reports and help check ownership claims when necessary.

### 2.3 Assumptions and Constraints

- Users are expected to provide accurate information when creating a report.
- The system will mainly be used for items lost or found within the university.
- The system should be simple enough for students and staff to use without difficulty.
- Not all details about a reported item should be publicly visible.
- Private item details should only be accessible to authorized users when needed to verify ownership.
- The system can help reduce false ownership claims, but it cannot guarantee that every ownership claim will be correct.

## 3. Functional Requirements

The system should provide the following functions:

- **FR-01:** The system shall allow users to report an item they have lost.
- **FR-02:** The system shall allow users to report an item they have found.
- **FR-03:** The system shall allow users to enter item details, such as name, color, description, location, and date.
- **FR-04:** The system shall display a list of reported lost and found items.
- **FR-05:** The system shall allow users to search for items by name or other publicly available details.
- **FR-06:** The system shall allow users to view the publicly available details of a report.
- **FR-07:** The system shall allow users to filter search results by category or date.
- **FR-08:** The system shall allow users to edit their own reports.
- **FR-09:** The system shall allow users to delete their own reports.
- **FR-10:** The system should provide a way for users to contact the person who reported finding an item.
- **FR-11:** The system shall allow a report to be marked as returned when the item has been given back to its owner.
- **FR-12:** The system shall allow users to check the status of their reports.
- **FR-13:** The system may notify users when there is new information about their reports.
- **FR-14:** The system should allow users to report incorrect or suspicious listings.
- **FR-15:** The system shall allow university staff to review and manage reports.
- **FR-16:** The system shall allow users reporting a found item to keep selected details private instead of displaying all information publicly.
- **FR-17:** The system shall allow a person claiming an item to provide identifying details that can be checked against the private information in the report.
- **FR-18:** The system should allow university staff or another authorized person to review ownership claims when necessary before an item is returned.
- **FR-19:** The system shall limit access to private item details to authorized users.

## 4. Non-Functional Requirements

The system should also meet the following requirements:

- **NFR-01 — Usability:** The system should have a simple and clear interface that students and staff can use easily.
- **NFR-02 — Performance:** The system should return search results within a reasonable amount of time under normal usage.
- **NFR-03 — Privacy:** The system should protect users' personal information and private item details from unauthorized access.
- **NFR-04 — Reliability:** The system should save reports correctly and make saved information available when authorized users need it.
- **NFR-05 — Data Accuracy:** The system should display report information clearly so users can identify items as accurately as possible.
- **NFR-06 — Maintainability:** The system should be organized so that future changes and improvements can be made more easily.
- **NFR-07 — Security:** The system should prevent unauthorized users from accessing or changing private information about reported items.

## 5. User Stories

### User Story 1: Reporting a Lost Item

As a student, I want to report an item I have lost so that I can have a better chance of finding it.

### User Story 2: Reporting a Found Item

As a student, I want to report an item I have found so that its owner can find it.

### User Story 3: Adding Item Details

As a user, I want to add details such as an item's name, color, description, and location so that others can recognize it more easily.

### User Story 4: Searching for an Item

As a user, I want to search for an item by its name so that I can quickly find related reports.

### User Story 5: Filtering Search Results

As a user, I want to filter items by category or date so that I can find the items I am looking for more easily.

### User Story 6: Viewing Item Details

As a user, I want to view the public details of a reported item so that I can check whether it matches the item I lost or found.

### User Story 7: Browsing All Reports

As a user, I want to see a list of lost and found items so that I can check the latest reports.

### User Story 8: Updating a Report

As a user, I want to edit my report so that I can correct mistakes or add new details.

### User Story 9: Deleting a Report

As a user, I want to delete my report if it is no longer needed so that outdated information does not remain in the system.

### User Story 10: Contacting the Item Finder

As a student, I want to contact the person who found my item so that I can arrange to get it back.

### User Story 11: Marking an Item as Returned

As a user, I want to mark an item as returned so that others know it has been given back to its owner.

### User Story 12: Checking Report Status

As a user, I want to check the status of my report so that I know whether there has been any progress.

### User Story 13: Receiving Updates

As a user, I want to receive updates about my report so that I do not miss important information.

### User Story 14: Reporting Incorrect Information

As a user, I want to report an incorrect or suspicious listing so that the system can remain useful and reliable.

### User Story 15: Managing Reports

As a university staff member, I want to review and manage item reports so that the lost-and-found system stays organized.

### User Story 16: Keeping Item Details Private

As a student who reports a found item, I want to keep some details private so that people cannot easily make false claims about owning the item.

### User Story 17: Verifying Item Ownership

As a student claiming a lost item, I want to provide details that help identify my item so that the person managing the report can check whether it belongs to me.

### User Story 18: Reviewing Ownership Claims

As a university staff member, I want to review ownership claims when necessary so that items are less likely to be returned to the wrong person.

## 6. Appendices and Notes

These requirements and user stories represent the initial plan for Find My. Some details may change as the team discusses the system and learns more about users' needs.

Private details can be used to help check ownership claims. However, the exact verification process and the staff members responsible for it will be decided during further analysis.
