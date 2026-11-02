# Find My — Software Requirements Specification (SRS)

## 1. Purpose

Find My is a university lost-and-found web application built for Khatam University. It enables Students to report lost and found items, browse and search active reports, and contact reporters via their university email address, while allowing Staff members to manage listings[span_75](start_span)[span_75](end_span)[span_76](start_span)[span_76](end_span).

## 2. Scope

The system supports six core workflows:

- Role-based user login (with automatic role detection)[span_77](start_span)[span_77](end_span)[span_78](start_span)[span_78](end_span).
- Lost item reporting[span_79](start_span)[span_79](end_span).
- Found item reporting[span_80](start_span)[span_80](end_span).
- Browsing and keyword-searching listings across titles and descriptions[span_81](start_span)[span_81](end_span)[span_82](start_span)[span_82](end_span).
- Viewing listing details and the reporter's university email[span_83](start_span)[span_83](end_span)[span_84](start_span)[span_84](end_span).
- Staff listing management (marking items as `RETURNED` and soft-deleting via `is_deleted`)[span_85](start_span)[span_85](end_span)[span_86](start_span)[span_86](end_span).

Ownership verification and physical handover happen in person, outside the application[span_87](start_span)[span_87](end_span).

## 3. Users, Permissions, and Account Creation

| Role        | Permitted Actions                                                                                                                                                                                                                                                                  | Prohibited Actions                                                                                                                                                             |
| ----------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Student** | Log in, create lost/found reports, browse/search active (`status = ACTIVE`, `is_deleted = false`) listings, view active item details and reporter email[span_88](start_span)[span_88](end_span)[span_89](start_span)[span_89](end_span)[span_90](start_span)[span_90](end_span).   | Cannot view `RETURNED` or soft-deleted (`is_deleted = true`) listings; cannot manage listings[span_91](start_span)[span_91](end_span)[span_92](start_span)[span_92](end_span). |
| **Staff**   | Log in, view and search all non-deleted (`is_deleted = false`) listings (both `ACTIVE` and `RETURNED`), view details, mark active items as `RETURNED`, soft-delete listings (`is_deleted = true`)[span_93](start_span)[span_93](end_span)[span_94](start_span)[span_94](end_span). | Cannot create student lost or found reports[span_95](start_span)[span_95](end_span).                                                                                           |

**Account Creation Policy:**

- **Student Accounts:** Pre-seeded or provisioned in the database via the university's official student roster[span_96](start_span)[span_96](end_span). Students authenticate using their issued credentials and cannot alter their assigned role[span_97](start_span)[span_97](end_span).
- **Staff Accounts:** Created and assigned directly in the database by a system administrator[span_98](start_span)[span_98](end_span). Students cannot register themselves as staff or elevate their own privileges[span_99](start_span)[span_99](end_span).

## 4. Functional Requirements

- **FR1:** The system shall authenticate Students and Staff using their `university_email` and `password`, automatically detecting their role (`STUDENT` or `STAFF`) from their `User` record[span_100](start_span)[span_100](end_span)[span_101](start_span)[span_101](end_span).
- **FR2:** The system shall allow authenticated Students to submit a lost item report (`type = LOST`) containing required fields (`title`, `description`, `category`, `location`, `item_date`) and an optional `image`[span_102](start_span)[span_102](end_span)[span_103](start_span)[span_103](end_span).
- **FR3:** The system shall allow authenticated Students to submit a found item report (`type = FOUND`) containing required fields (`title`, `description`, `category`, `location`, `item_date`) and an optional `image`[span_104](start_span)[span_104](end_span)[span_105](start_span)[span_105](end_span).
- **FR4:** The system shall validate all report inputs and save valid reports with `status = ACTIVE`, `is_deleted = false`, and `created_at` set to the current server timestamp; if any required field is missing or invalid, the system shall reject the request and display a validation error without saving[span_106](start_span)[span_106](end_span)[span_107](start_span)[span_107](end_span)[span_108](start_span)[span_108](end_span).
- **FR5:** The system shall allow authenticated Students to browse active listings (`status = ACTIVE` and `is_deleted = false`)[span_109](start_span)[span_109](end_span).
- **FR6:** The system shall provide case-insensitive text search across the item `title` and `description` fields for active, non-deleted listings[span_110](start_span)[span_110](end_span).
- **FR7:** The system shall allow authenticated Students to view item details only for listings where `status = ACTIVE` and `is_deleted = false`[span_111](start_span)[span_111](end_span).
- **FR8:** The system shall display the reporter’s `university_email` on the item details page by reading it from the associated `User` record via `reporter_id` (without duplicating contact fields in the `Item` table)[span_112](start_span)[span_112](end_span)[span_113](start_span)[span_113](end_span).
- **FR9:** The system shall allow authenticated Staff to view and search all non-deleted listings (`is_deleted = false`), including both `ACTIVE` and `RETURNED` items[span_114](start_span)[span_114](end_span)[span_115](start_span)[span_115](end_span).
- **FR10:** The system shall allow authenticated Staff to mark an `ACTIVE` listing as returned by updating `status` to `RETURNED`[span_116](start_span)[span_116](end_span).
- **FR11:** The system shall allow authenticated Staff to remove inappropriate listings using Soft Delete by setting `is_deleted = true` (retaining the database record)[span_117](start_span)[span_117](end_span).
- **FR12:** The system shall restrict Staff-only operations to `STAFF` accounts and reject unauthorized requests with HTTP 401/403 errors[span_118](start_span)[span_118](end_span).

## 5. Non-Functional Requirements

- **NFR1 — Security:** Passwords must be stored using cryptographic hashing (BCrypt). Password hashes and private credentials must never be exposed in API responses or UI views[span_119](start_span)[span_119](end_span).
- **NFR2 — Access Control:** Role permissions (`STUDENT` vs. `STAFF`) must be enforced on the backend for every protected endpoint[span_120](start_span)[span_120](end_span).
- **NFR3 — Usability:** Users must be able to submit a report or execute a search in 3 or fewer clicks after login.
- **NFR4 — Reliability:** All user and item records must be stored persistently in a relational database (PostgreSQL or MySQL).
- **NFR5 — Input Validation:** If a user submits incomplete, empty, out-of-range, or invalid data (such as a future `item_date`), the backend must reject the request, prevent database persistence, and return a clear error message[span_121](start_span)[span_121](end_span)[span_122](start_span)[span_122](end_span).

## 6. Data Requirements

A single `Item` entity is used for both lost and found reports. Contact information is not stored directly on the `Item` entity; it is resolved dynamically through `reporter_id`[span_123](start_span)[span_123](end_span).

### User Entity

| Attribute          | Type / Constraints         | Required? | Description                                                                                                                     |
| ------------------ | -------------------------- | --------- | ------------------------------------------------------------------------------------------------------------------------------- |
| `id`               | BIGINT, PK, Auto-increment | Required  | Unique user identifier                                                                                                          |
| `name`             | VARCHAR(100)               | Required  | User's full name                                                                                                                |
| `university_email` | VARCHAR(255), UNIQUE       | Required  | University email used for login and item contact[span_124](start_span)[span_124](end_span)                                      |
| `password`         | VARCHAR(255)               | Required  | Securely hashed password[span_125](start_span)[span_125](end_span)                                                              |
| `role`             | ENUM(`STUDENT`, `STAFF`)   | Required  | User role detected automatically upon login[span_126](start_span)[span_126](end_span)[span_127](start_span)[span_127](end_span) |

### Item Entity

| Attribute     | Type / Constraints         | Required? | Description                                                                                                          |
| ------------- | -------------------------- | --------- | -------------------------------------------------------------------------------------------------------------------- |
| `id`          | BIGINT, PK, Auto-increment | Required  | Unique item identifier                                                                                               |
| `title`       | VARCHAR(100), 3–100 chars  | Required  | Item title[span_128](start_span)[span_128](end_span)                                                                 |
| `description` | VARCHAR(500), 1–500 chars  | Required  | Item description[span_129](start_span)[span_129](end_span)                                                           |
| `category`    | VARCHAR(50)                | Required  | Fixed list: `Electronics`, `Documents`, `Clothing`, `Accessories`, `Other`[span_130](start_span)[span_130](end_span) |
| `type`        | ENUM(`LOST`, `FOUND`)      | Required  | Distinguishes lost vs. found reports                                                                                 |
| `location`    | VARCHAR(100), 2–100 chars  | Required  | Campus location where item was lost or found[span_131](start_span)[span_131](end_span)                               |
| `item_date`   | DATE ($\le$ current date)  | Required  | Date the item was lost or found (distinct from `created_at`)[span_132](start_span)[span_132](end_span)               |
| `image`       | VARCHAR(255)               | Optional  | Uploaded JPG/PNG image path (max 5 MB)[span_133](start_span)[span_133](end_span)                                     |
| `reporter_id` | BIGINT, FK -> `User.id`    | Required  | Reference to the Student who created the report[span_134](start_span)[span_134](end_span)                            |
| `status`      | ENUM(`ACTIVE`, `RETURNED`) | Required  | Defaults to `ACTIVE` when created[span_135](start_span)[span_135](end_span)                                          |
| `is_deleted`  | BOOLEAN                    | Required  | Soft-delete flag; defaults to `false`[span_136](start_span)[span_136](end_span)                                      |
| `created_at`  | TIMESTAMP                  | Required  | Automatic timestamp when the report was created in the system[span_137](start_span)[span_137](end_span)              |

## 7. Business Rules & Listing Visibility Matrix

- **BR1 (Account Provisioning):** `STUDENT` and `STAFF` accounts are pre-provisioned by the system administrator; role assignment is read directly from the `User` record at login[span_138](start_span)[span_138](end_span).
- **BR2 (Report Creation):** Only logged-in `STUDENT` accounts can create reports[span_139](start_span)[span_139](end_span). New reports are saved with `status = ACTIVE`, `is_deleted = false`, and an automatic `created_at` timestamp[span_140](start_span)[span_140](end_span)[span_141](start_span)[span_141](end_span).
- **BR3 (Date Validation):** `item_date` represents the date the item was lost or found and cannot be in the future[span_142](start_span)[span_142](end_span)[span_143](start_span)[span_143](end_span). `created_at` records when the report was submitted[span_144](start_span)[span_144](end_span).
- **BR4 (Contact Resolution):** The reporter's contact email is obtained from `User.university_email` via `reporter_id` and displayed on the item details page without storing duplicate contact fields[span_145](start_span)[span_145](end_span)[span_146](start_span)[span_146](end_span).
- **BR5 (Soft Deletion):** Removing a listing performs a Soft Delete (`is_deleted = true`)[span_147](start_span)[span_147](end_span). Records are never permanently deleted (`DELETE FROM`) via the application UI[span_148](start_span)[span_148](end_span).
- **BR6 (Listing Visibility by Status and Role):**

| Item State (`status` & `is_deleted`)      | Student Browse & Search                                                                    | Student Item Details View                                                                                 | Staff Management View                                                                       | Database Storage                                            |
| ----------------------------------------- | ------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- | ----------------------------------------------------------- |
| `status = ACTIVE`, `is_deleted = false`   | Visible[span_149](start_span)[span_149](end_span)                                          | Viewable[span_150](start_span)[span_150](end_span)                                                        | Visible[span_151](start_span)[span_151](end_span)[span_152](start_span)[span_152](end_span) | Stored                                                      |
| `status = RETURNED`, `is_deleted = false` | Hidden[span_153](start_span)[span_153](end_span)[span_154](start_span)[span_154](end_span) | Blocked (Error shown)[span_155](start_span)[span_155](end_span)[span_156](start_span)[span_156](end_span) | Visible[span_157](start_span)[span_157](end_span)[span_158](start_span)[span_158](end_span) | Stored                                                      |
| `is_deleted = true` (Soft-Deleted)        | Hidden[span_159](start_span)[span_159](end_span)[span_160](start_span)[span_160](end_span) | Blocked (Error shown)[span_161](start_span)[span_161](end_span)[span_162](start_span)[span_162](end_span) | Hidden[span_163](start_span)[span_163](end_span)[span_164](start_span)[span_164](end_span)  | Stored (Archived)[span_165](start_span)[span_165](end_span) |

- **BR7 (Offline Verification):** Ownership verification and physical handover happen in person outside the application[span_166](start_span)[span_166](end_span).

## 8. Out of Scope

The following features will not be implemented:

- Self-registration or public role elevation UI[span_167](start_span)[span_167](end_span).
- Ownership claims, online verification, or dispute management[span_168](start_span)[span_168](end_span).
- Automated item matching[span_169](start_span)[span_169](end_span).
- In-app messaging or chat[span_170](start_span)[span_170](end_span).
- Email, SMS, or push notifications[span_171](start_span)[span_171](end_span).
- Advanced search filters, rewards, user ratings, or analytics dashboards[span_172](start_span)[span_172](end_span).

## 9. Completion Criteria

The system is considered complete when:

1. Students and Staff can log in and their role is automatically detected from their account[span_173](start_span)[span_173](end_span)[span_174](start_span)[span_174](end_span).
2. Students can submit valid lost and found reports (`item_date`, required fields, optional `image`), and invalid inputs are rejected with clear errors[span_175](start_span)[span_175](end_span)[span_176](start_span)[span_176](end_span)[span_177](start_span)[span_177](end_span).
3. Reports persist in the database with `created_at`, `status = ACTIVE`, and `is_deleted = false`[span_178](start_span)[span_178](end_span)[span_179](start_span)[span_179](end_span).
4. Students can browse and search active listings across `title` and `description` and view item details showing the reporter's `university_email`[span_180](start_span)[span_180](end_span)[span_181](start_span)[span_181](end_span)[span_182](start_span)[span_182](end_span).
5. Staff can view active and returned non-deleted listings, mark active items as `RETURNED`, and soft-delete (`is_deleted = true`) inappropriate listings[span_183](start_span)[span_183](end_span)[span_184](start_span)[span_184](end_span).
6. Visibility rules for `ACTIVE`, `RETURNED`, and `is_deleted = true` items work strictly according to the visibility matrix[span_185](start_span)[span_185](end_span)[span_186](start_span)[span_186](end_span).
