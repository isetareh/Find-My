
# Find My — Software Requirements Specification (SRS)

## 1. Purpose

Find My is a university lost-and-found web application built for Khatam University. It enables Students to report lost and found items, browse and search active listings, and contact reporters via their university email address, while allowing Staff members to manage listings.

## 2. Scope

The system supports seven core workflows:

- Role-based login for pre-registered Student and Staff accounts, with automatic role detection.
- Lost listing creation by Students.
- Found listing creation by Students.
- Browsing and keyword-searching active listings across titles and descriptions.
- Viewing listing details and the reporter's university email.
- Student management of their own active listings by marking them as `RETURNED`.
- Staff listing management (marking any active listing as `RETURNED` and soft-deleting via `is_deleted`).

Ownership verification and physical handover happen in person, outside the application.

## 3. Users, Permissions, and Account Creation

| Role | Permitted Actions | Prohibited Actions |
|---|---|---|
| **Student** | Log in, create lost/found listings, browse/search active (`status = ACTIVE`, `is_deleted = false`) listings, view active listing details and reporter email, mark their own active listings as `RETURNED`. | Cannot view `RETURNED` or soft-deleted (`is_deleted = true`) listings; cannot change the status of another Student's listing or soft-delete listings. |
| **Staff** | Log in, view and search all non-deleted (`is_deleted = false`) listings (both `ACTIVE` and `RETURNED`), view details, mark any active listing as `RETURNED`, soft-delete listings (`is_deleted = true`). | Cannot create Student lost or found listings. |

**Account Creation Policy:**

- **Student Accounts:** Pre-seeded or provisioned in the database via the university's official student roster. Students authenticate using their issued credentials and cannot alter their assigned role.
- **Staff Accounts:** Created and assigned directly in the database by a system administrator. Students cannot register themselves as Staff or elevate their own privileges.

## 4. Functional Requirements

- **FR1:** The system shall authenticate Students and Staff using their `university_email` and `password`, automatically detecting their role (`STUDENT` or `STAFF`) from their `User` record.

- **FR2:** The system shall allow authenticated Students to submit a lost listing (`type = LOST`) containing the required fields (`title`, `description`, `category`, `location`, `item_date`).

- **FR3:** The system shall allow authenticated Students to submit a found listing (`type = FOUND`) containing the required fields (`title`, `description`, `category`, `location`, `item_date`).

- **FR4:** The system shall validate all listing inputs and save valid listings with `status = ACTIVE`, `is_deleted = false`, and `created_at` set to the current server timestamp; if any required field is missing or invalid, the system shall reject the request and display a validation error without saving.

- **FR5:** The system shall allow authenticated Students to browse active listings (`status = ACTIVE` and `is_deleted = false`).

- **FR6:** The system shall provide case-insensitive text search across the listing `title` and `description` fields for active, non-deleted listings.

- **FR7:** The system shall allow authenticated Students to view listing details only for listings where `status = ACTIVE` and `is_deleted = false`.

- **FR8:** The system shall display the reporter's `university_email` on the listing details page by reading it from the associated `User` record via `reporter_id` (without duplicating contact fields in the `Listing` table).

- **FR9:** The system shall allow authenticated Staff to view and search all non-deleted listings (`is_deleted = false`), including both `ACTIVE` and `RETURNED` listings.

- **FR10:** The system shall allow authenticated Staff to mark an `ACTIVE` listing as returned by updating `status` to `RETURNED`.

- **FR11:** The system shall allow authenticated Staff to remove inappropriate listings using Soft Delete by setting `is_deleted = true` (retaining the database record).

- **FR12:** The system shall restrict Staff-only operations to `STAFF` accounts. Unauthenticated requests to Staff-only operations shall receive HTTP 401 Unauthorized, while authenticated users without the `STAFF` role shall receive HTTP 403 Forbidden.

- **FR13:** The system shall allow an authenticated Student to change the status of their own `ACTIVE` listing to `RETURNED`. A Student attempting to change another Student's listing shall receive HTTP 403 Forbidden. Attempts to update a non-existent, already returned, or soft-deleted listing shall be rejected; non-existent and soft-deleted listings shall return HTTP 404 Not Found.

## 5. Non-Functional Requirements

- **NFR1 — Security:** Passwords must be stored using cryptographic hashing (BCrypt). Password hashes and private credentials must never be exposed in API responses or UI views.

- **NFR2 — Access Control:** Role permissions (`STUDENT` vs. `STAFF`) must be enforced on the backend for every protected endpoint.

- **NFR3 — Usability:** Users must be able to submit a listing or execute a search in 3 or fewer clicks after login.

- **NFR4 — Reliability:** All User and Listing records must be stored persistently in a relational database. The specific database technology shall be determined during implementation.

- **NFR5 — Input Validation:** If a user submits incomplete, empty, out-of-range, or invalid data (such as a future `item_date`), the backend must reject the request, prevent database persistence, and return a clear error message.

## 6. Data Requirements

A single `Listing` entity is used for both lost and found listings. Contact information is not stored directly on the `Listing` entity; it is resolved dynamically through `reporter_id`.

### User Entity

| Attribute | Type / Constraints | Required? | Description |
|---|---|---|---|
| `id` | Integer, Primary Key | Required | Unique user identifier |
| `name` | String, maximum 100 characters | Required | User's full name |
| `university_email` | String, Unique, maximum 255 characters | Required | University email used for login and listing contact |
| `password` | String, maximum 255 characters | Required | Securely hashed password |
| `role` | `STUDENT` or `STAFF` | Required | User role detected automatically upon login |

### Listing Entity

| Attribute | Type / Constraints | Required? | Description |
|---|---|---|---|
| `id` | Integer, Primary Key | Required | Unique listing identifier |
| `title` | String, 3–100 characters | Required | Listing title |
| `description` | String, 1–500 characters | Required | Listing description |
| `category` | String, maximum 50 characters | Required | Fixed list: `Electronics`, `Documents`, `Clothing`, `Accessories`, `Other` |
| `type` | `LOST` or `FOUND` | Required | Distinguishes lost vs. found listings |
| `location` | String, 2–100 characters | Required | Campus location where the item was lost or found |
| `item_date` | Date (less than or equal to current date) | Required | Date the item was lost or found (distinct from `created_at`) |
| `reporter_id` | Foreign Key → `User.id` | Required | Reference to the Student who created the listing |
| `status` | `ACTIVE` or `RETURNED` | Required | Defaults to `ACTIVE` when created |
| `is_deleted` | Boolean | Required | Soft-delete flag; defaults to `false` |
| `created_at` | Timestamp | Required | Automatic timestamp when the listing was created in the system |

## 7. Business Rules & Listing Visibility Matrix

- **BR1 (Account Provisioning):** Student accounts are pre-seeded or provisioned using the university's official student roster, while Staff accounts are created by the system administrator. Role assignment is read directly from the `User` record at login.

- **BR2 (Listing Creation):** Only logged-in `STUDENT` accounts can create listings. New listings are saved with `status = ACTIVE`, `is_deleted = false`, and an automatic `created_at` timestamp.

- **BR3 (Date Validation):** `item_date` represents the date the item was lost or found and cannot be in the future. `created_at` records when the listing was submitted.

- **BR4 (Contact Resolution):** The reporter's contact email is obtained from `User.university_email` via `reporter_id` and displayed on the listing details page without storing duplicate contact fields.

- **BR5 (Soft Deletion):** Removing a listing performs a Soft Delete (`is_deleted = true`). Records are never permanently deleted (`DELETE FROM`) via the application UI.

- **BR6 (Listing Visibility by Status and Role):**

| Listing State (`status` & `is_deleted`) | Student Browse & Search | Student Listing Details View | Student Status Update | Staff Management View | Database Storage |
|---|---|---|---|---|---|
| `status = ACTIVE`, `is_deleted = false` | Visible | Viewable | Own listings only | Visible | Stored |
| `status = RETURNED`, `is_deleted = false` | Hidden | Blocked (Error shown) | Not allowed | Visible | Stored |
| `is_deleted = true` (Soft-Deleted) | Hidden | Blocked (Error shown) | Not allowed | Hidden | Stored (Archived) |

- **BR7 (Student Listing Status Management):** Only the Student who created a listing may change its status from `ACTIVE` to `RETURNED`. Students cannot change another user's listing or soft-delete any listing.

- **BR8 (Offline Verification):** Ownership verification and physical handover happen in person outside the application.

## 8. Out of Scope

The following features will not be implemented:

- Self-registration or public role elevation UI.
- Ownership claims, online verification, or dispute management.
- Automated listing matching.
- In-app messaging or chat.
- Email, SMS, or push notifications.
- Advanced search filters, rewards, user ratings, or analytics dashboards.

## 9. Completion Criteria

The system is considered complete when:

1. Students and Staff can log in and their role is automatically detected from their account.

2. Students can submit valid lost and found listings (`item_date` and all required fields), and invalid inputs are rejected with clear errors.

3. Listings persist in the database with `created_at`, `status = ACTIVE`, and `is_deleted = false`.

4. Students can browse and search active listings across `title` and `description`, view listing details showing the reporter's `university_email`, and mark their own active listings as `RETURNED`.

5. Staff can view active and returned non-deleted listings, mark active listings as `RETURNED`, and soft-delete (`is_deleted = true`) inappropriate listings.

6. Visibility rules for `ACTIVE`, `RETURNED`, and `is_deleted = true` listings work strictly according to the visibility matrix.
