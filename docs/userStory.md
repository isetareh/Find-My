# Find My — User Stories

## Actors
* **Student:** Uses the system to report lost or found items, browse and search active listings, and view item details.
* **Staff:** Views all non-deleted listings (active and returned), marks active listings as returned, and soft-deletes inappropriate listings.

## Validation and Boundary Standards
To maintain consistency across all user stories and test suites, item reports enforce these rules:
* **Title (`title`):** Required, 3 to 100 characters after trimming leading/trailing whitespace.
* **Description (`description`):** Required, 1 to 500 characters after trimming whitespace.
* **Category (`category`):** Required, selected from a fixed list: `Electronics`, `Documents`, `Clothing`, `Accessories`, `Other`.
* **Location (`location`):** Required, 2 to 100 characters after trimming whitespace.
* **Item Date (`item_date`):** Required, valid calendar date on or before the current date (future dates are rejected; separate from the automatic `created_at` report timestamp).
* **Image (`image`):** Optional, JPG or PNG format, maximum file size of 5 MB.

---

### US1 — Log In
**User Story**  
As a Student or Staff member,  
I want to log in with my university credentials,  
So that I can access the system according to my role.

**Acceptance Criteria**
1. **Success — Valid Credentials & Automatic Role Detection:** A Student or Staff member logging in with a registered `university_email` and matching password is authenticated, their role (`STUDENT` or `STAFF`) is automatically detected from their account, and they are routed to the permitted view for their role.
2. **Invalid Input — Incorrect Credentials:** The system rejects logins with an unregistered email or incorrect password, returning an error message without specifying which field was invalid.
3. **Invalid Input — Empty Fields:** The system rejects login submissions where the email or password is empty or contains only whitespace.
4. **Boundary — Case Insensitivity:** Login email matching is case-insensitive and trims leading and trailing whitespace.
5. **Failure — Unauthenticated Access:** Unauthenticated requests to protected pages or endpoints are blocked and redirected to the login view.
6. **Failure — Unauthorized Role Access:** An authenticated Student attempting to access Staff-only management operations receives an HTTP 403 Forbidden error.

---

### US2 — Report Lost Item
**User Story**  
As a Student,  
I want to report a lost item,  
So that other students can find my report and contact me.

**Acceptance Criteria**
1. **Success — Valid Report:** A logged-in Student submitting valid required fields (`title`, `description`, `category`, `location`, `item_date`) with or without an optional `image` creates a report saved with `type = LOST`, `status = ACTIVE`, `is_deleted = false`, `created_at` set to the current timestamp, and `reporter_id` linked to the logged-in user.
2. **Success — Immediate Visibility:** The new lost item report immediately appears in active listings.
3. **Boundary — Character Limits:** The system accepts Titles of 3 to 100 characters, Descriptions of 1 to 500 characters, and Locations of 2 to 100 characters; inputs outside these limits are rejected and the report is not saved.
4. **Boundary — Invalid / Future Date:** The system accepts today's date or any past calendar date for `item_date`, and rejects invalid calendar dates or dates in the future without saving the report.
5. **Invalid Input — Missing Required Fields:** The system rejects submissions missing any required field (`title`, `description`, `category`, `location`, `item_date`) or containing only whitespace, displaying a validation error and preventing the report from being saved.
6. **Invalid Input — Invalid Category or Image:** The system rejects submissions with an unlisted Category, a non-JPG/PNG image, or a file exceeding 5 MB.
7. **Failure — Role & Auth Restriction:** Unauthenticated users and Staff accounts cannot submit lost item reports.

---

### US3 — Report Found Item
**User Story**  
As a Student,  
I want to report a found item,  
So that its owner can find my report and contact me.

**Acceptance Criteria**
1. **Success — Valid Report:** A logged-in Student submitting valid required fields (`title`, `description`, `category`, `location`, `item_date`) with or without an optional `image` creates a report saved with `type = FOUND`, `status = ACTIVE`, `is_deleted = false`, `created_at` set to the current timestamp, and `reporter_id` linked to the logged-in user.
2. **Success — Immediate Visibility:** The new found item report immediately appears in active listings.
3. **Boundary — Character Limits:** The system accepts Titles of 3 to 100 characters, Descriptions of 1 to 500 characters, and Locations of 2 to 100 characters; inputs outside these limits are rejected and the report is not saved.
4. **Boundary — Invalid / Future Date:** The system accepts today's date or any past calendar date for `item_date`, and rejects invalid calendar dates or dates in the future without saving the report.
5. **Invalid Input — Missing Required Fields:** The system rejects submissions missing any required field (`title`, `description`, `category`, `location`, `item_date`) or containing only whitespace, displaying a validation error and preventing the report from being saved.
6. **Invalid Input — Invalid Category or Image:** The system rejects submissions with an unlisted Category, a non-JPG/PNG image, or a file exceeding 5 MB.
7. **Failure — Role & Auth Restriction:** Unauthenticated users and Staff accounts cannot submit found item reports.

---

### US4 — Browse and Search Listings
**User Story**  
As a Student,  
I want to browse and search active listings,  
So that I can find relevant lost or found items.

**Acceptance Criteria**
1. **Success — Browse Active Listings:** A logged-in Student sees all reports where `status = ACTIVE` and `is_deleted = false` (both `LOST` and `FOUND` types).
2. **Success — Keyword Search on Title and Description:** Submitting a search term returns all active, non-deleted listings where the `title` or `description` field contains the keyword.
3. **Boundary — Case and Space Insensitivity:** Keyword matching on `title` and `description` is case-insensitive and trims leading and trailing whitespace from the query.
4. **Boundary — Empty Query:** Submitting an empty or whitespace-only search string displays all active, non-deleted listings.
5. **Boundary — No Matching Results:** If no active listings match the search query, the system displays an explicit empty-state message: `"No matching items found."`
6. **Failure — Hidden Records:** Listings with `status = RETURNED` or `is_deleted = true` never appear in Student browse or search results.

---

### US5 — View Item Details
**User Story**  
As a Student,  
I want to view a listing's details,  
So that I can evaluate the item and contact the reporter via university email.

**Acceptance Criteria**
1. **Success — View Active Listing & Reporter Email:** A logged-in Student opening an active listing sees its `title`, `description`, `category`, `type` (`LOST` / `FOUND`), `location`, `item_date`, `image` (if available), and the reporter’s `university_email` retrieved directly from the associated `User` account.
2. **Boundary — Missing Image:** If an item has no uploaded image, a default placeholder is shown without broken links.
3. **Security — Data Protection:** The system never exposes the reporter's password hash or private account fields.
4. **Failure — Deleted, Returned, or Non-Existent Listings Not Viewable:** If a Student requests a listing that does not exist, has `is_deleted = true` (soft-deleted), or has `status = RETURNED`, the listing is not viewable and the system displays a `"Listing not found or no longer available"` error.
5. **Failure — Unauthorized Controls:** Student views do not render Staff management controls, and direct requests by Students to Staff management endpoints are rejected with HTTP 403.

---

### US6 — Manage Listings
**User Story**  
As a Staff member,  
I want to manage listings,  
So that I can mark returned items and remove inappropriate reports.

**Acceptance Criteria**
1. **Success — View Active and Returned Listings:** An authenticated Staff member can view and search all non-deleted listings (`is_deleted = false`), which includes both `ACTIVE` and `RETURNED` listings.
2. **Success — Mark Returned (`RETURNED` Status Behavior):** Staff can mark an `ACTIVE` listing as returned, updating its `status` to `RETURNED`. Returned listings remain visible to Staff in the management view but no longer appear in Student active browse or search results.
3. **Success — Remove Listing (Soft Delete Behavior):** Staff can remove an inappropriate listing via Soft Delete, which sets `is_deleted = true` in the database without permanently deleting the row. Soft-deleted listings are hidden from all Student and Staff UI views and search results.
4. **Boundary — Already Returned Item:** Attempting to mark an already `RETURNED` listing as returned is rejected with an informative status error.
5. **Failure — Non-Existent or Already Soft-Deleted Target:** Attempting to mark as returned or remove a non-existent item ID or an item with `is_deleted = true` returns an HTTP 404 Not Found error.
6. **Failure — Unauthorized Role:** Any attempt by a Student or unauthenticated user to mark an item as returned or soft-delete an item is rejected with HTTP 403 Forbidden.

---

## Scope Restrictions
* No online ownership claims or dispute resolution workflows.
* No in-app messaging, chat, or phone number sharing.
* No automated matching algorithms or notifications (email, push, SMS).
* In-person verification and item handover occur outside the software.
