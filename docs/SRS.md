# Find My — Software Requirements Specification (SRS)

## 1. Purpose

Find My is a university lost-and-found web application built for Khatam University. It enables Students to report lost and found items, browse and search active reports, and contact reporters via their university email address, while allowing Staff members to manage listings.

## 2. Scope

The system supports six core workflows:

- Role-based user login (with automatic role detection).
- Lost item reporting.
- Found item reporting.
- Browsing and keyword-searching listings across titles and descriptions.
- Viewing listing details and the reporter's university email.
- Staff listing management (marking items as `RETURNED` and soft-deleting via `is_deleted`).

Ownership verification and physical handover happen in person, outside the application.

## 3. Users, Permissions, and Account Creation

| Role        | Permitted Actions                                                                                                                                                                                                                                                                  | Prohibited Actions                                                                                                                                                             |
| ----------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Student** | Log in, create lost/found reports, browse/search active (`status = ACTIVE`, `is_deleted = false`) listings, view active item details and reporter email.   | Cannot view `RETURNED` or soft-deleted (`is_deleted = true`) listings; cannot manage listings. |
| **Staff**   | Log in, view and search all non-deleted (`is_deleted = false`) listings (both `ACTIVE` and `RETURNED`), view details, mark active items as `RETURNED`, soft-delete listings (`is_deleted = true`). | Cannot create student lost or found reports.                                                                                           |

**Account Creation Policy:**

- **Student Accounts:** Pre-seeded or provisioned in the database via the university's official student roster. Students authenticate using their issued credentials and cannot alter their assigned role.
- **Staff Accounts:** Created and assigned directly in the database by a system administrator. Students cannot register themselves as staff or elevate their own privileges.

## 4. Functional Requirements

- **FR1:** The system shall authenticate Students and Staff using their `university_email` and `password`, automatically detecting their role (`STUDENT` or `STAFF`) from their `User` record.
- **FR2:** The system shall allow authenticated Students to submit a lost item report (`type = LOST`) containing required fields (`title`, `description`, `category`, `location`, `item_date`) and an optional `image`.
- **FR3:** The system shall allow authenticated Students to submit a found item report (`type = FOUND`) containing required fields (`title`, `description`, `category`, `location`, `item_date`) and an optional `image`.
- **FR4:** The system shall validate all report inputs and save valid reports with `status = ACTIVE`, `is_deleted = false`, and `created_at` set to the current server timestamp; if any required field is missing or invalid, the system shall reject the request and display a validation error without saving.
- **FR5:** The system shall allow authenticated Students to browse active listings (`status = ACTIVE` and `is_deleted = false`).
- **FR6:** The system shall provide case-insensitive text search across the item `title` and `description` fields for active, non-deleted listings.
- **FR7:** The system shall allow authenticated Students to view item details only for listings where `status = ACTIVE` and `is_deleted = false`.
- **FR8:** The system shall display the reporter’s `university_email` on the item details page by reading it from the associated `User` record via `reporter_id` (without duplicating contact fields in the `Item` table).
- **FR9:** The system shall allow authenticated Staff to view and search all non-deleted listings (`is_deleted = false`), including both `ACTIVE` and `RETURNED` items.
- **FR10:** The system shall allow authenticated Staff to mark an `ACTIVE` listing as returned by updating `status` to `RETURNED`.
- **FR11:** The system shall allow authenticated Staff to remove inappropriate listings using Soft Delete by setting `is_deleted = true` (retaining the database record).
- **FR12:** The system shall restrict Staff-only operations to `STAFF` accounts and reject unauthorized requests with HTTP 401/403 errors.

## 5. Non-Functional Requirements

- **NFR1 — Security:** Passwords must be stored using cryptographic hashing (BCrypt). Password hashes and private credentials must never be exposed in API responses or UI views.
- **NFR2 — Access Control:** Role permissions (`STUDENT` vs. `STAFF`) must be enforced on the backend for every protected endpoint.
- **NFR3 — Usability:** Users must be able to submit a report or execute a search in 3 or fewer clicks after login.
- **NFR4 — Reliability:** All user and item records must be stored persistently in a relational database (PostgreSQL or MySQL).
- **NFR5 — Input Validation:** If a user submits incomplete, empty, out-of-range, or invalid data (such as a future `item_date`), the backend must reject the request, prevent database persistence, and return a clear error message.

## 6. Data Requirements

A single `Item` entity is used for both lost and found reports. Contact information is not stored directly on the `Item` entity; it is resolved dynamically through `reporter_id`.

### User Entity

| Attribute          | Type / Constraints         | Required? | Description                                                                                                                     |
| ------------------ | -------------------------- | --------- | ------------------------------------------------------------------------------------------------------------------------------- |
| `id`               | BIGINT, PK, Auto-increment | Required  | Unique user identifier                                                                                                          |
| `name`             | VARCHAR(100)               | Required  | User's full name                                                                                                                |
| `university_email` | VARCHAR(255), UNIQUE       | Required  | University email used for login and item contact                                      |
| `password`         | VARCHAR(255)               | Required  | Securely hashed password                                                              |
| `role`             | ENUM(`STUDENT`, `STAFF`)   | Required  | User role detected automatically upon login |

### Item Entity

| Attribute     | Type / Constraints         | Required? | Description                                                                                                          |
| ------------- | -------------------------- | --------- | -------------------------------------------------------------------------------------------------------------------- |
| `id`          | BIGINT, PK, Auto-increment | Required  | Unique item identifier                                                                                               |
| `title`       | VARCHAR(100), 3–100 chars  | Required  | Item title                                                                 |
| `description` | VARCHAR(500), 1–500 chars  | Required  | Item description                                                           |
| `category`    | VARCHAR(50)                | Required  | Fixed list: `Electronics`, `Documents`, `Clothing`, `Accessories`, `Other` |
| `type`        | ENUM(`LOST`, `FOUND`)      | Required  | Distinguishes lost vs. found reports                                                                                 |
| `location`    | VARCHAR(100), 2–100 chars  | Required  | Campus location where item was lost or found                               |
| `item_date`   | DATE ($\le$ current date)  | Required  | Date the item was lost or found (distinct from `created_at`)               |
| `image`       | VARCHAR(255)               | Optional  | Uploaded JPG/PNG image path (max 5 MB)                                     |
| `reporter_id` | BIGINT, FK -> `User.id`    | Required  | Reference to the Student who created the report                            |
| `status`      | ENUM(`ACTIVE`, `RETURNED`) | Required  | Defaults to `ACTIVE` when created                                          |
| `is_deleted`  | BOOLEAN                    | Required  | Soft-delete flag; defaults to `false`                                      |
| `created_at`  | TIMESTAMP                  | Required  | Automatic timestamp when the report was created in the system              |

## 7. Business Rules & Listing Visibility Matrix

- **BR1 (Account Provisioning):** `STUDENT` and `STAFF` accounts are pre-provisioned by the system administrator; role assignment is read directly from the `User` record at login.
- **BR2 (Report Creation):** Only logged-in `STUDENT` accounts can create reports. New reports are saved with `status = ACTIVE`, `is_deleted = false`, and an automatic `created_at` timestamp.
- **BR3 (Date Validation):** `item_date` represents the date the item was lost or found and cannot be in the future. `created_at` records when the report was submitted.
- **BR4 (Contact Resolution):** The reporter's contact email is obtained from `User.university_email` via `reporter_id` and displayed on the item details page without storing duplicate contact fields.
- **BR5 (Soft Deletion):** Removing a listing performs a Soft Delete (`is_deleted = true`). Records are never permanently deleted (`DELETE FROM`) via the application UI.
- **BR6 (Listing Visibility by Status and Role):**

| Item State (`status` & `is_deleted`)      | Student Browse & Search                                                                    | Student Item Details View                                                                                 | Staff Management View                                                                       | Database Storage                                            |
| ----------------------------------------- | ------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- | ----------------------------------------------------------- |
| `status = ACTIVE`, `is_deleted = false`   | Visible                                          | Viewable                                                        | Visible | Stored                                                      |
| `status = RETURNED`, `is_deleted = false` | Hidden | Blocked (Error shown) | Visible | Stored                                                      |
| `is_deleted = true` (Soft-Deleted)        | Hidden | Blocked (Error shown) | Hidden  | Stored (Archived) |

- **BR7 (Offline Verification):** Ownership verification and physical handover happen in person outside the application.

## 8. Out of Scope

The following features will not be implemented:

- Self-registration or public role elevation UI.
- Ownership claims, online verification, or dispute management.
- Automated item matching.
- In-app messaging or chat.
- Email, SMS, or push notifications.
- Advanced search filters, rewards, user ratings, or analytics dashboards.

## 9. Completion Criteria

The system is considered complete when:

1. Students and Staff can log in and their role is automatically detected from their account.
2. Students can submit valid lost and found reports (`item_date`, required fields, optional `image`), and invalid inputs are rejected with clear errors.
3. Reports persist in the database with `created_at`, `status = ACTIVE`, and `is_deleted = false`.
4. Students can browse and search active listings across `title` and `description` and view item details showing the reporter's `university_email`.
5. Staff can view active and returned non-deleted listings, mark active items as `RETURNED`, and soft-delete (`is_deleted = true`) inappropriate listings.
6. Visibility rules for `ACTIVE`, `RETURNED`, and `is_deleted = true` items work strictly according to the visibility matrix.
