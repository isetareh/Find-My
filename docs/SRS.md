# Requirements and User Stories

## 1. Introduction

### 1.1 Purpose

Find My is a system designed to help students find lost items at the university. It allows users to report items they have lost or found and search through existing reports.

The main goal is to make the lost-and-found process easier, faster, and more organized while protecting item owners from false ownership claims and preventing the disclosure of confidential item details.

### 1.2 Scope

The system will focus on reporting, searching for, and managing lost and found items within the university.

Users will be able to create reports, search for items, view publicly available report information, and update their own reports when necessary. Users who believe they own a found item will be able to submit an ownership claim by providing identifying characteristics or other relevant evidence.

The system will distinguish between public item information and confidential identifying details. Confidential details will be used to support ownership verification and will not be disclosed to ordinary users. Authorized university staff will be able to review reports, evaluate ownership claims, and manage the return of items.

## 2. Overall Description

### 2.1 Product Perspective

Find My is a proposed system for managing lost and found items at the university. It aims to provide a centralized place where students can report missing belongings and check whether someone has found them.

To reduce false ownership claims, the system will support separate public and confidential information for found-item reports. Public information will help users identify potentially relevant items, while selected identifying characteristics will remain confidential and be used during ownership verification.

Users who believe they own an item will submit their own identifying information or evidence. The system will evaluate the claim without revealing the correct confidential details or indicating which individual answers match. Claims that cannot be confidently verified through the defined verification process will be referred to authorized university staff.

The system will enforce access controls so that confidential details and ownership evidence are available only to authorized users and processes.

### 2.2 User Classes

The main user classes of the system are:

- **Students:** Students can report lost and found items, browse and search public listings, view publicly available report details, edit or delete their own reports, and check report statuses. Students who believe they own a found item can submit ownership claims by providing identifying characteristics or relevant evidence. Students who report found items can provide confidential identifying details to support ownership verification.

- **University Staff:** Authorized university staff can review and manage reports, access confidential item details when necessary, evaluate ownership claims, handle suspicious or disputed cases, and oversee the return of items. Their access to confidential information shall be limited to what is necessary for their assigned responsibilities.

### 2.3 Assumptions and Constraints

- Users are expected to provide accurate information when creating reports and submitting ownership claims.
- The system will mainly be used for items lost or found within the university.
- The interface should be simple enough for students and university staff to use without difficulty.
- Found-item reports may contain both public information and confidential identifying details.
- The person reporting a found item is responsible for providing relevant identifying details when creating the report.
- Confidential details must not be disclosed through public listings, search results, ordinary report views, notifications, or unauthorized requests.
- Ownership claims must be evaluated using information supplied by the claimant and the confidential information recorded for the item.
- The system must not reveal the correct confidential details or provide answer-by-answer feedback that could help a claimant guess the identifying characteristics.
- Claims that cannot be confidently verified must be referred to authorized university staff when necessary.
- An item must not be considered successfully returned through the system's ownership verification workflow until the claim has been sufficiently verified and the return has been confirmed.
- Access to confidential information and ownership evidence must be controlled by the system's authorization rules.

## 3. Functional Requirements

The system shall provide the following functions:

- **FR-01 — Reporting Lost Items:** The system shall allow users to report an item they have lost.

- **FR-02 — Reporting Found Items:** The system shall allow users to report an item they have found and provide information that may help its owner identify it.

- **FR-03 — Entering Item Details:** The system shall allow users to enter item details, such as name, category, description, location, and date. For found-item reports, the system shall distinguish between public information and confidential identifying details. Confidential details may include exact color, size, brand, serial number, distinctive marks, contents, or other characteristics that can help verify ownership.

- **FR-04 — Displaying Item Listings:** The system shall display lists of lost and found reports while showing only information designated for public viewing.

- **FR-05 — Searching for Items:** The system shall allow users to search for items using names, categories, dates, and other publicly available details. The search function shall not expose confidential identifying details to unauthorized users.

- **FR-06 — Viewing Report Details:** The system shall allow users to view publicly available report details. Confidential identifying details shall be accessible only to authorized users and processes with appropriate permissions.

- **FR-07 — Filtering Search Results:** The system shall allow users to filter search results by category, date, or other supported public attributes without exposing confidential information.

- **FR-08 — Editing Reports:** The system shall allow users to edit their own reports, subject to appropriate access controls. Editing a found-item report shall preserve the distinction between public information and confidential identifying details.

- **FR-09 — Deleting Reports:** The system shall allow users to delete their own reports, subject to appropriate access controls and applicable record-management rules.

- **FR-10 — Contacting the Item Finder:** The system shall provide a way for users to contact the person who reported finding an item or initiate an ownership claim without unnecessarily disclosing private contact information or confidential item details.

- **FR-11 — Verifying Ownership Before Return:** The system shall require an ownership claim to be sufficiently verified before the item is marked as returned through the ownership verification workflow. Submitting a claim alone shall not be considered proof of ownership or confirmation that the item has been returned.

- **FR-12 — Checking Report and Claim Status:** The system shall allow users to check the status of their reports and ownership claims, including relevant states such as submitted, under review, approved, rejected, or returned, as applicable to the workflow.

- **FR-13 — Sending Notifications:** The system may notify users when there is new information about their reports or ownership claims. Notifications shall not contain confidential identifying details or ownership evidence.

- **FR-14 — Reporting Suspicious Listings:** The system should allow users to report incorrect or suspicious listings so that they can be reviewed by authorized university staff.

- **FR-15 — Staff Review and Management:** The system shall allow authorized university staff to review and manage reports, access confidential identifying details when necessary, evaluate ownership claims, investigate suspicious or disputed cases, and manage the return process according to their permissions.

- **FR-16 — Submitting and Evaluating Ownership Claims:** The system shall allow users who believe they own a found item to submit an ownership claim by providing identifying characteristics or other relevant evidence. The system shall compare the submitted information with the confidential details recorded for the item through the defined verification process. It shall not reveal the correct confidential details or provide answer-by-answer feedback that could help claimants guess them. Claims that cannot be confidently verified shall be referred to authorized university staff when necessary. The system shall record claim statuses and restrict access to submitted evidence and verification information according to user permissions.

## 4. Non-Functional Requirements

The system shall also meet the following non-functional requirements:

- **NFR-01 — Usability:** The system should provide a simple and clear interface that students and university staff can use easily. Reporting items, searching for reports, and submitting ownership claims should be understandable without unnecessary complexity.

- **NFR-02 — Performance:** The system should return search results and process ordinary report operations within a reasonable amount of time under normal usage. Ownership claim submission and status retrieval should also perform reliably under normal usage.

- **NFR-03 — Privacy:** The system shall protect users' personal information and shall not display private contact details without appropriate permission. It shall also protect confidential identifying details of found items and evidence submitted in ownership claims. Such information shall not be exposed through public listings, ordinary report views, search results, notifications, or responses to unauthorized requests.

- **NFR-04 — Reliability:** The system shall save reports and ownership claims correctly and make their information available to authorized users when needed. Changes to report statuses, claim statuses, and return confirmations shall be recorded consistently.

- **NFR-05 — Data Accuracy:** The system should present public report information clearly and maintain the accuracy of confidential identifying details used for ownership verification. Verification should consider the available characteristics and evidence rather than automatically rejecting a claim solely because of one discrepancy. Claims with insufficient or conflicting evidence should be referred for authorized review when appropriate.

- **NFR-06 — Maintainability:** The system should be organized so that future changes and improvements can be made more easily, including changes to reporting, ownership verification, status management, and access-control rules.

- **NFR-07 — Access Control and Security:** The system shall enforce server-side authentication and authorization controls to ensure that confidential item details, ownership claim evidence, and restricted report information are accessible only to authorized users and processes. Access restrictions shall be enforced by the backend and shall not rely solely on hiding information in the user interface.

- **NFR-08 — Confidentiality of Verification:** The ownership verification process shall not disclose the correct confidential answers, individual field matches, or other information that would enable unauthorized users to infer protected item characteristics. Verification results shall reveal only the information necessary to communicate the claim's status or request further evidence.

## 5. User Stories

### User Story 1: Reporting a Lost Item

As a student, I want to report an item I have lost so that I can have a better chance of finding it.

### User Story 2: Reporting a Found Item

As a student, I want to report an item I have found and provide both public information and confidential identifying details so that its owner can find it without exposing all identifying characteristics to the public.

### User Story 3: Adding Item Details

As a user, I want to add details such as an item's name, category, description, location, and date so that others can identify potentially relevant items. For found items, I also want to record distinctive characteristics privately so they can be used to verify ownership.

### User Story 4: Searching for an Item

As a user, I want to search for an item by its name or other publicly available details so that I can quickly find related reports without accessing confidential information.

### User Story 5: Filtering Search Results

As a user, I want to filter items by category or date so that I can find the items I am looking for more easily.

### User Story 6: Viewing Item Details

As a user, I want to view the publicly available details of a reported item so that I can check whether it may match the item I lost, while confidential identifying details remain protected.

### User Story 7: Browsing All Reports

As a user, I want to see a list of lost and found items so that I can check the latest reports without seeing confidential identifying details.

### User Story 8: Updating a Report

As a user, I want to edit my report so that I can correct mistakes or add new details while preserving the distinction between public and confidential information.

### User Story 9: Deleting a Report

As a user, I want to delete my report if it is no longer needed so that outdated information does not remain available in the system.

### User Story 10: Contacting the Item Finder

As a student, I want to contact the person who found my item or initiate an ownership claim so that I can arrange to get it back without unnecessarily exposing private contact information.

### User Story 11: Marking an Item as Returned

As a user, I want an item to be marked as returned only after ownership has been sufficiently verified and the return has been confirmed so that the system does not incorrectly record an item as returned to the wrong person.

### User Story 12: Checking Report Status

As a user, I want to check the status of my report or ownership claim so that I know whether there has been any progress.

### User Story 13: Receiving Updates

As a user, I want to receive updates about my report or ownership claim so that I do not miss important information, without receiving confidential identifying details in notifications.

### User Story 14: Reporting Incorrect Information

As a user, I want to report an incorrect or suspicious listing so that the system can remain useful and reliable.

### User Story 15: Managing Reports

As an authorized university staff member, I want to review and manage reports, access confidential identifying details when necessary, and evaluate ownership claims so that items can be returned to their rightful owners.

### User Story 16: Claiming Ownership of a Found Item

As a student who believes they own a found item, I want to submit identifying characteristics or relevant evidence privately so that my ownership can be evaluated without the system revealing the confidential details of the item.

### User Story 17: Reviewing an Ownership Claim

As an authorized university staff member, I want to review claims that cannot be confidently verified through the normal process so that I can assess the available evidence and help prevent incorrect handovers.

## 6. Appendices and Notes

These requirements and user stories represent the initial plan for Find My. Some details may change as the team discusses the system and learns more about users' needs.

The system should reveal enough public information to help users identify potentially relevant reports while keeping selected identifying characteristics confidential for ownership verification.

Confidential details should be collected and stored only when necessary. Access to these details and to ownership evidence should be restricted according to user permissions. The verification process should avoid revealing correct answers or individual field matches to claimants.

A submitted ownership claim does not, by itself, establish ownership. Claims should be evaluated using the available identifying characteristics and evidence. Cases that cannot be confidently verified should be reviewed by authorized university staff before the item is handed over. The system should record the relevant claim and return statuses so that the process remains clear and traceable.