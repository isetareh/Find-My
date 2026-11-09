# Find My — User Stories

## Actors

- **Student:** Uses the system to report lost or found items, browse and search active listings, view listing details, and mark their own listings as returned.
- **Staff:** Views and searches all non-deleted listings (active and returned), marks any active listing as returned, and soft-deletes inappropriate listings.

## Validation and Boundary Standards

To maintain consistency across all user stories and test suites, listing reports enforce the following rules:

- **Title (`title`):** Required, 3 to 100 characters after trimming leading and trailing whitespace.
- **Description (`description`):** Required, 1 to 500 characters after trimming leading and trailing whitespace.
- **Category (`category`):** Required, selected from a fixed list: `Electronics`, `Documents`, `Clothing`, `Accessories`, `Other`.
- **Location (`location`):** Required, 2 to 100 characters after trimming leading and trailing whitespace.
- **Item Date (`item_date`):** Required, must be a valid calendar date on or before the current date. Future dates are rejected. It is separate from the automatically generated `created_at` listing timestamp.

---

### US1 — Log In

**User Story**

As a Student or Staff member,  
I want to log in with my university credentials,  
So that I can access the system according to my role.

**Acceptance Criteria**

1. **Success — Valid Credentials & Automatic Role Detection:** A Student or Staff member logging in with a registered `university_email` and matching password is authenticated. Their role (`STUDENT` or `STAFF`) is automatically detected from their account, and they are routed to the permitted view for their role.
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
So that other students can find my listing and contact me.

**Acceptance Criteria**

1. **Success — Valid Listing:** A logged-in Student submitting valid required fields (`title`, `description`, `category`, `location`, `item_date`) creates a listing saved with `type = LOST`, `status = ACTIVE`, `is_deleted = false`, `created_at` set to the current timestamp, and `reporter_id` linked to the logged-in user.
2. **Success — Immediate Visibility:** The new lost item listing immediately appears in active listings.
3. **Boundary — Character Limits:** The system accepts titles of 3 to 100 characters, descriptions of 1 to 500 characters, and locations of 2 to 100 characters. Inputs outside these limits are rejected, and the listing is not saved.
4. **Boundary — Invalid / Future Date:** The system accepts today's date or any past calendar date for `item_date` and rejects invalid calendar dates or dates in the future without saving the listing.
5. **Invalid Input — Missing Required Fields:** The system rejects submissions missing any required field (`title`, `description`, `category`, `location`, `item_date`) or containing only whitespace in required text fields. A validation error is displayed, and the listing is not saved.
6. **Invalid Input — Invalid Category:** The system rejects submissions with a category that is not included in the predefined list.
7. **Failure — Role & Authentication Restriction:** Unauthenticated users and Staff accounts cannot submit lost item listings.

---

### US3 — Report Found Item

**User Story**

As a Student,  
I want to report a found item,  
So that its owner can find my listing and contact me.

**Acceptance Criteria**

1. **Success — Valid Listing:** A logged-in Student submitting valid required fields (`title`, `description`, `category`, `location`, `item_date`) creates a listing saved with `type = FOUND`, `status = ACTIVE`, `is_deleted = false`, `created_at` set to the current timestamp, and `reporter_id` linked to the logged-in user.
2. **Success — Immediate Visibility:** The new found item listing immediately appears in active listings.
3. **Boundary — Character Limits:** The system accepts titles of 3 to 100 characters, descriptions of 1 to 500 characters, and locations of 2 to 100 characters. Inputs outside these limits are rejected, and the listing is not saved.
4. **Boundary — Invalid / Future Date:** The system accepts today's date or any past calendar date for `item_date` and rejects invalid calendar dates or dates in the future without saving the listing.
5. **Invalid Input — Missing Required Fields:** The system rejects submissions missing any required field (`title`, `description`, `category`, `location`, `item_date`) or containing only whitespace in required text fields. A validation error is displayed, and the listing is not saved.
6. **Invalid Input — Invalid Category:** The system rejects submissions with a category that is not included in the predefined list.
7. **Failure — Role & Authentication Restriction:** Unauthenticated users and Staff accounts cannot submit found item listings.

---

### US4 — Browse and Search Listings

**User Story**

As a Student,  
I want to browse and search active listings,  
So that I can find relevant lost or found items.

**Acceptance Criteria**

1. **Success — Browse Active Listings:** A logged-in Student sees all listings where `status = ACTIVE` and `is_deleted = false`, including both `LOST` and `FOUND` types.
2. **Success — Keyword Search on Title and Description:** Submitting a search term returns all active, non-deleted listings where the `title` or `description` field contains the keyword.
3. **Boundary — Case and Space Insensitivity:** Keyword matching on `title` and `description` is case-insensitive and trims leading and trailing whitespace from the query.
4. **Boundary — Empty Query:** Submitting an empty or whitespace-only search string displays all active, non-deleted listings.
5. **Boundary — No Matching Results:** If no active listings match the search query, the system displays the following message: `"No matching items found."`
6. **Failure — Hidden Records:** Listings with `status = RETURNED` or `is_deleted = true` never appear in Student browse or search results.

---

### US5 — View Listing Details

**User Story**

As a Student,  
I want to view a listing's details,  
So that I can evaluate the item and contact the reporter via university email.

**Acceptance Criteria**

1. **Success — View Active Listing & Reporter Email:** A logged-in Student opening an active listing sees its `title`, `description`, `category`, `type` (`LOST` / `FOUND`), `location`, and `item_date`. The reporter's `university_email` is retrieved directly from the associated `User` account through `reporter_id`.
2. **Security — Data Protection:** The system never exposes the reporter's password hash or other private account fields.
3. **Failure — Deleted, Returned, or Non-Existent Listings Not Viewable:** If a Student requests a listing that does not exist, has `is_deleted = true` (soft-deleted), or has `status = RETURNED`, the listing is not viewable, and the system displays the following error: `"Listing not found or no longer available"`.
4. **Failure — Unauthorized Controls:** Student views do not render Staff management controls, and direct requests by Students to Staff management endpoints are rejected with HTTP 403.

---

### US6 — Manage Listings

**User Story**

As a Staff member,  
I want to manage listings,  
So that I can mark returned items and remove inappropriate listings.

**Acceptance Criteria**

1. **Success — View Active and Returned Listings:** An authenticated Staff member can view and search all non-deleted listings (`is_deleted = false`), including both `ACTIVE` and `RETURNED` listings.
2. **Success — Mark Any Active Listing as Returned:** Staff can mark any `ACTIVE` listing as returned, updating its `status` to `RETURNED`. Returned listings remain visible to Staff in the management view but no longer appear in Student active browse or search results.
3. **Success — Remove Listing (Soft Delete Behavior):** Staff can remove an inappropriate listing via Soft Delete, which sets `is_deleted = true` in the database without permanently deleting the record. Soft-deleted listings are hidden from all Student and Staff UI views and search results.
4. **Boundary — Already Returned Listing:** Attempting to mark an already `RETURNED` listing as returned is rejected with an informative status error.
5. **Failure — Non-Existent or Already Soft-Deleted Listing:** Attempting to update the status of or soft-delete a non-existent listing ID or a listing with `is_deleted = true` returns an HTTP 404 Not Found error. Such listings cannot be viewed or managed, even if their IDs are known.
6. **Failure — Unauthorized Access:** An unauthenticated user attempting to mark a listing as returned or soft-delete a listing receives HTTP 401 Unauthorized. An authenticated Student attempting the same Staff-only operations receives HTTP 403 Forbidden.

---

### US7 — Mark Own Listing as Returned

**User Story**

As a Student,  
I want to mark my own listing as returned after the lost or found item has been handed over,  
So that the listing is no longer displayed as an active item.

**Acceptance Criteria**

1. **Success — Mark Own Active Listing as Returned:** A logged-in Student can change the status of their own `ACTIVE` listing to `RETURNED`.
2. **Success — Immediate Removal from Student Listings:** After the status is changed to `RETURNED`, the listing no longer appears in Student browse or search results.
3. **Failure — Unauthorized Ownership Access:** A Student attempting to change the status of another Student's listing receives an HTTP 403 Forbidden error.
4. **Boundary — Already Returned Listing:** Attempting to mark an already `RETURNED` listing as returned is rejected with an informative status error.
5. **Failure — Non-Existent or Soft-Deleted Listing:** Attempting to change the status of a non-existent listing or a listing with `is_deleted = true` returns an HTTP 404 Not Found error.

---

## Scope Restrictions

- No online ownership claims or dispute resolution workflows.
- No in-app messaging, chat, or phone number sharing.
- No automated matching algorithms or notifications (email, push, SMS).
- In-person ownership verification and item handover occur outside the software.
