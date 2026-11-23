# Find My — Software Requirements Specification (SRS)

## 1. Purpose

Find My is a university-based Lost and Found Management System designed to help Students report lost and found items, browse and search active listings, view listing details, and contact reporters through their university email addresses.

The system also allows Staff members to review and manage listings, mark items as returned, and remove inappropriate or invalid listings.

**Terminology:** In this document and in all related project documents, `Listing` refers to a single lost or found report. The name `Item` used in the architecture document refers to the same concept and shall be aligned with `Listing`.

## 2. Scope

The system supports the following core workflows:

- Login for pre-registered Student and Staff accounts, with automatic role detection.
- Lost listing creation by Students.
- Found listing creation by Students.
- Browsing and keyword-searching active listings.
- Viewing listing details and the reporter's university email.
- Student management of their own active listings by marking them as `RETURNED`.
- Staff listing management, including marking any active listing as `RETURNED` and soft-deleting inappropriate or invalid listings.

Physical item handover and ownership verification take place outside the application.

## 3. Users and Permissions

| Role | Permitted Actions | Prohibited Actions |
|---|---|---|
| **Student** | Log in, create LOST and FOUND listings, browse and search active listings, view active listing details and reporter email, mark their own active listings as `RETURNED`. | Cannot view returned or soft-deleted listings, change another Student's listing status, or soft-delete listings. |
| **Staff** | Log in, view and search all non-deleted listings (both `ACTIVE` and `RETURNED`), mark any active listing as `RETURNED`, and soft-delete inappropriate or invalid listings. | Cannot create LOST or FOUND listings. |

**Account and Role Policy:**

- Only registered university accounts can log in.
- Each account has a role stored in its associated `User` record.
- The system automatically detects the user's role (`STUDENT` or `STAFF`) after successful authentication.
- Users cannot change their assigned role through the application.

## 4. Functional Requirements

### 4.1 Authentication and Access Control

- **FR1 — User Authentication:** The system shall authenticate Students and Staff using their `university_email` and `password`. The user's role (`STUDENT` or `STAFF`) shall be automatically detected from their `User` record.

- **FR2 — Login Input Validation:** The system shall reject login submissions when the email or password is empty or contains only whitespace.

- **FR3 — Invalid Credentials:** The system shall reject login attempts with an unregistered email or incorrect password. The error message shall not reveal which credential was incorrect.

- **FR4 — Email Matching:** Login email matching shall be case-insensitive and shall ignore leading and trailing whitespace. The stored `university_email` shall be normalized in the same way (trimmed and lowercased), and uniqueness shall be enforced on the normalized value, so that two accounts cannot differ only by letter case.

- **FR5 — Protected Access:** The system shall prevent unauthenticated users from accessing protected pages and operations. Unauthenticated users attempting to access protected web pages shall be redirected to the login view. Unauthenticated requests to API endpoints shall instead receive HTTP `401 Unauthorized` (see FR33).

### 4.2 Listing Creation

- **FR6 — Report Lost Item:** The system shall allow authenticated Students to create lost item listings (`type = LOST`) by providing the required fields: `title`, `description`, `category`, `location`, and `item_date`.

- **FR7 — Report Found Item:** The system shall allow authenticated Students to create found item listings (`type = FOUND`) by providing the required fields: `title`, `description`, `category`, `location`, and `item_date`.

- **FR8 — Listing Validation and Initialization:** The system shall validate all required listing fields according to the following rules:

  - `title`: Required; 3 to 100 characters after trimming leading and trailing whitespace.
  - `description`: Required; 1 to 500 characters after trimming leading and trailing whitespace.
  - `category`: Required; must be one of the predefined categories:
    `Electronics`, `Documents`, `Clothing`, `Accessories`, or `Other`.
  - `location`: Required; 2 to 100 characters after trimming leading and trailing whitespace.
  - `item_date`: Required; must be a valid calendar date on or before the current date.

  If any required field is missing or invalid, the system shall reject the submission, display a validation error, and not save the listing.

  A valid listing shall be saved with:

  - `status = ACTIVE`
  - `is_deleted = false`
  - `created_at` set to the current timestamp
  - `reporter_id` linked to the authenticated Student

- **FR9 — Immediate Listing Visibility:** After successful creation, the new listing shall immediately appear in the Student's active listings.

- **FR10 — Listing Creation Authorization:** Only authenticated Students shall be allowed to create LOST and FOUND listings. Unauthenticated users and Staff accounts shall not be allowed to create listings.

### 4.3 Student Browsing and Searching

- **FR11 — Browse Active Listings:** The system shall allow authenticated Students to browse all listings where `status = ACTIVE` and `is_deleted = false`, including both `LOST` and `FOUND` listings.

- **FR12 — Keyword Search:** The system shall provide keyword search across the `title` and `description` fields of active, non-deleted listings.

- **FR13 — Search Normalization:** Search matching shall be case-insensitive and shall ignore leading and trailing whitespace in the search query.

- **FR14 — Empty Search Query:** When a Student submits an empty or whitespace-only search query, the system shall display all active, non-deleted listings.

- **FR15 — No Matching Results:** When no active listings match the search query, the system shall display the following message:

  `No matching items found.`

- **FR16 — Hidden Listings:** Listings with `status = RETURNED` or `is_deleted = true` shall never appear in Student browsing or search results.

### 4.4 Listing Details

- **FR17 — View Listing Details:** The system shall allow authenticated Students to view the details of an active, non-deleted listing.

  The details shall include:

  - `title`
  - `description`
  - `category`
  - `type` (`LOST` or `FOUND`)
  - `location`
  - `item_date`

- **FR18 — Display Reporter Email:** The system shall display the reporter's `university_email` on the listing details page. The email shall be retrieved from the associated `User` record through `reporter_id`.

- **FR19 — Protect Private Account Data:** The system shall never expose the reporter's password hash or other private account fields in listing details or user-facing responses.

- **FR20 — Unavailable Listing:** If a Student requests a listing that does not exist, has `is_deleted = true`, or has `status = RETURNED`, the system shall prevent access and display the following error message:

  `Listing not found or no longer available`

### 4.5 Staff Listing Management

- **FR21 — View and Search Listings:** The system shall allow authenticated Staff members to view and search all non-deleted listings (`is_deleted = false`), including both `ACTIVE` and `RETURNED` listings.

- **FR22 — Mark Listing as Returned:** The system shall allow authenticated Staff members to change the status of any active listing from `ACTIVE` to `RETURNED`.

- **FR23 — Already Returned Listing:** If Staff attempt to mark an already returned listing as returned, the system shall reject the operation and display an informative status error.

- **FR24 — Soft Delete Listing:** The system shall allow authenticated Staff members to remove inappropriate or invalid listings using Soft Delete. This operation shall set `is_deleted = true` without permanently deleting the database record.

- **FR25 — Soft-Deleted Listing Visibility:** Soft-deleted listings shall be hidden from all Student and Staff views and search results, while their records remain stored in the database.

- **FR26 — Invalid Management Requests:** Attempts to update the status of or soft-delete a non-existent listing or a listing that has already been soft-deleted shall be rejected with HTTP `404 Not Found`.

### 4.6 Student Listing Management

- **FR27 — Mark Own Listing as Returned:** The system shall allow an authenticated Student to change the status of their own active listing from `ACTIVE` to `RETURNED`.

- **FR28 — Listing Ownership Restriction:** A Student attempting to change the status of another Student's listing shall be rejected with HTTP `403 Forbidden`.

- **FR29 — Already Returned Listing:** If a Student attempts to mark an already returned listing as returned, the system shall reject the operation and display an informative status error.

- **FR30 — Invalid Student Status Update:** Attempts to change the status of a non-existent or soft-deleted listing shall be rejected with HTTP `404 Not Found`.

- **FR31 — Immediate Removal from Student Results:** After a listing is marked as `RETURNED`, it shall no longer appear in Student browsing or search results.

### 4.7 Authorization Rules

- **FR32 — Staff-Only Operations:** The system shall restrict Staff-only management operations to authenticated accounts with the `STAFF` role.

- **FR33 — Unauthorized Staff Operations:** An unauthenticated user attempting to perform Staff-only management operations shall receive HTTP `401 Unauthorized`.

- **FR34 — Student Access to Staff Operations:** An authenticated Student attempting to perform Staff-only management operations shall receive HTTP `403 Forbidden`.

- **FR35 — Student Interface Restrictions:** Student views shall not display Staff management controls. Direct requests by Students to Staff-only management operations shall be rejected.

## 5. Non-Functional Requirements

- **NFR1 — Security:** User passwords shall be stored securely as password hashes. Password hashes and private credentials shall never be exposed in API responses or user interface views. The specific password-hashing technology shall be selected during implementation.

- **NFR2 — Access Control:** Role-based permissions (`STUDENT` and `STAFF`) and listing ownership restrictions shall be enforced on the backend for every protected operation.

- **NFR3 — Usability:** Users should be able to submit a listing or execute a search in three or fewer clicks after login.

- **NFR4 — Reliability:** User and Listing records shall be stored persistently. The specific database technology shall be determined during implementation.

- **NFR5 — Input Validation:** The system shall validate user input on the backend. Incomplete, empty, out-of-range, or invalid data shall be rejected, and invalid submissions shall not be saved.

## 6. Data Requirements

The system uses two main entities: `User` and `Listing`.

A single `Listing` entity is used for both lost and found listings. Contact information is not stored directly in the `Listing` entity; it is retrieved through the relationship between `Listing.reporter_id` and `User.id`.

### 6.1 User Entity

| Attribute | Type / Constraints | Required? | Description |
|---|---|---|---|
| `id` | Integer, Primary Key | Required | Unique user identifier |
| `name` | String, maximum 100 characters | Required | User's full name |
| `university_email` | String, Unique (after normalization), maximum 255 characters | Required | University email used for login and listing contact. Stored trimmed and in lowercase. |
| `password_hash` | String | Required | Securely stored password hash. The `password` value entered at login is compared against this field and is never stored in plain text. |
| `role` | `STUDENT` or `STAFF` | Required | User role detected automatically upon login |

### 6.2 Listing Entity

| Attribute | Type / Constraints | Required? | Description |
|---|---|---|---|
| `id` | Integer, Primary Key | Required | Unique listing identifier |
| `title` | String, 3–100 characters after trimming | Required | Listing title |
| `description` | String, 1–500 characters after trimming | Required | Listing description |
| `category` | Fixed list of predefined values | Required | One of: `Electronics`, `Documents`, `Clothing`, `Accessories`, `Other`. Each value is a fixed constant; implementations may store it as an enumeration, but the displayed label must match these names. |
| `type` | `LOST` or `FOUND` | Required | Distinguishes lost and found listings |
| `location` | String, 2–100 characters after trimming | Required | Campus location where the item was lost or found |
| `item_date` | Valid calendar date, less than or equal to current date | Required | Date the item was lost or found; distinct from `created_at` |
| `reporter_id` | Foreign Key → `User.id` | Required | Reference to the Student who created the listing |
| `status` | `ACTIVE` or `RETURNED` | Required | Listing status; defaults to `ACTIVE` |
| `is_deleted` | Boolean | Required | Soft-delete flag; defaults to `false` |
| `created_at` | Timestamp | Required | Automatically generated timestamp when the listing is created |

## 7. Business Rules and Listing Visibility

- **BR1 — Role Detection:** The user's role shall be read from the associated `User` record after successful login. Users cannot assign or change their own roles through the application.

- **BR2 — Listing Creation:** Only authenticated `STUDENT` accounts can create LOST and FOUND listings. New listings shall be saved with `status = ACTIVE`, `is_deleted = false`, and an automatically generated `created_at` timestamp.

- **BR3 — Listing Validation:** All required listing fields shall be validated according to the constraints defined in FR8. Leading and trailing whitespace shall be trimmed from required text fields before validation.

- **BR4 — Date Validation:** `item_date` represents the date the item was lost or found and must be a valid date on or before the current date. `created_at` records when the listing was submitted to the system.

- **BR5 — Contact Resolution:** The reporter's contact email shall be obtained from `User.university_email` through `reporter_id`. Contact information shall not be duplicated in the `Listing` entity.

- **BR6 — Soft Deletion:** Removing a listing shall perform a Soft Delete by setting `is_deleted = true`. The application shall retain the database record instead of permanently deleting it.

- **BR7 — Student Listing Status Management:** Only the Student who created a listing may change its status from `ACTIVE` to `RETURNED`. Students cannot change another user's listing or soft-delete any listing.

- **BR8 — Staff Listing Management:** Staff members can mark any active listing as returned and soft-delete inappropriate or invalid listings.

- **BR9 — Search Behavior:** Student search shall operate on `title` and `description` fields of active, non-deleted listings. Search matching shall be case-insensitive and ignore leading and trailing whitespace. An empty query shall display all active, non-deleted listings.

- **BR10 — Listing Visibility:** Listing visibility shall follow the following matrix:

### Listing Visibility Matrix

| Listing State | Student Browse & Search | Student Details View | Student Status Update | Staff Management View | Database Storage |
|---|---|---|---|---|---|
| `status = ACTIVE`, `is_deleted = false` | Visible | Viewable | Own listings only | Visible | Stored |
| `status = RETURNED`, `is_deleted = false` | Hidden | Blocked | Not allowed | Visible | Stored |
| `is_deleted = true` | Hidden | Blocked | Not allowed | Hidden | Stored |

- **BR11 — Offline Verification:** Ownership verification and physical item handover take place in person, outside the application.

- **BR12 — Management Request Check Order:** For Student and Staff management requests (status update or Soft Delete), the system shall evaluate the following conditions in this order and return the first applicable error:
  1. Unauthenticated request: HTTP `401 Unauthorized`.
  2. Authenticated user without the role required for the operation (a Student attempting a Staff-only operation): HTTP `403 Forbidden`.
  3. Listing does not exist or has `is_deleted = true`: HTTP `404 Not Found`.
  4. Student does not own the listing: HTTP `403 Forbidden`.
  5. Listing is already `RETURNED`: informative status error.

## 8. Out of Scope

The following features are not included in the current project scope:

- In-app messaging or chat.
- Phone number sharing.
- Automated item matching.
- Notifications through email, SMS, or push services.
- Online ownership verification, ownership claims, or dispute resolution.
- Physical item handover and ownership verification workflows inside the application.

## 9. Completion Criteria

The system shall be considered complete when all of the following conditions are satisfied:

1. Students and Staff can log in using registered university credentials, and their roles are automatically detected.

2. Invalid login attempts, including incorrect credentials and empty or whitespace-only fields, are rejected appropriately.

3. Students can create valid LOST and FOUND listings, and invalid submissions are rejected according to the defined validation rules.

4. New listings are stored with the correct `type`, `reporter_id`, `created_at`, `status = ACTIVE`, and `is_deleted = false` values.

5. Students can browse and search active listings, including both LOST and FOUND types, and the search behavior follows the defined matching and empty-query rules.

6. Students can view active listing details and the reporter's university email without access to private account information.

7. Students can mark their own active listings as `RETURNED`, but cannot change another Student's listing status.

8. Staff can view and search active and returned non-deleted listings, mark active listings as `RETURNED`, and soft-delete inappropriate or invalid listings.

9. Returned listings are hidden from Student browsing and search results but remain visible to Staff.

10. Soft-deleted listings are hidden from all Student and Staff views while their records remain stored in the database.

11. Authentication, role-based authorization, listing ownership restrictions, and the defined error responses are enforced correctly.
