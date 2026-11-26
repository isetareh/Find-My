# Find My — Activity Diagram

This activity diagram models the end-to-end workflows of **Find My** in alignment with `docs/SRS.md` and `docs/user-stories.md` (US1–US7).

```mermaid
flowchart TD
    A([Start]) --> B["Enter university_email and password"]
    B --> B1{"Non-empty & valid credentials?"}
    B1 -->|"No: Show generic error"| B
    B1 -->|"Yes: Detect role (STUDENT or STAFF)"| C{"User Role?"}

    C -->|"STUDENT"| D{"Choose Student Action"}
    C -->|"STAFF"| S1["View or search non-deleted listings (is_deleted = false)"]

    %% Create LOST or FOUND Listing (US2, US3)
    D -->|"Create LOST or FOUND listing"| E1["Enter title, description, category, location, item_date"]
    E1 --> E2{"Valid fields & item_date <= today?"}
    E2 -->|"No: Show validation error"| E1
    E2 -->|"Yes"| E3["Save Listing (ACTIVE, is_deleted = false, created_at = now)"]
    E3 --> Z([End])

    %% Browse, Search & View Listing Details (US4, US5)
    D -->|"Browse or search active listings"| F1["Query ACTIVE & non-deleted listings"]
    F1 --> F2{"Any matching listings?"}
    F2 -->|"No: Show 'No matching items found.' & retry"| F1
    F2 -->|"Yes"| F3["Select a listing to view details"]
    F3 --> F4{"Exists, status = ACTIVE & is_deleted = false?"}
    F4 -->|"No: Show 'Listing not found or no longer available'"| F1
    F4 -->|"Yes: Show details & reporter university_email"| F5{"Relevant listing?"}
    F5 -->|"No"| F1
    F5 -->|"Yes"| G1

    %% Student Mark Own Listing as RETURNED (US7)
    D -->|"Mark own active listing as RETURNED"| H1["Select own listing & request RETURNED"]
    H1 --> H2{"Listing exists & is_deleted = false?"}
    H2 -->|"No: HTTP 404 Not Found"| Z
    H2 -->|"Yes"| H3{"Current user is reporter_id?"}
    H3 -->|"No: HTTP 403 Forbidden"| Z
    H3 -->|"Yes"| H4{"status == ACTIVE?"}
    H4 -->|"No (Already RETURNED): Show status error"| Z
    H4 -->|"Yes: Set status = RETURNED"| Z

    %% Offline In-Person Process
    subgraph Offline ["Outside Application: In-Person Process"]
        G1["Contact reporter via university_email"] --> G2["Arrange in-person meeting"]
        G2 --> G3["Verify ownership & hand over item"]
    end

    G3 -->|"Student marks own listing RETURNED"| H1
    G3 -->|"Or inform Staff"| S1

    %% Staff Management Flow (US6)
    S1 --> S2{"Select Staff management action"}
    S2 -->|"No action"| Z
    S2 -->|"Mark active listing as RETURNED"| T1["Select target listing"]
    T1 --> T2{"Listing exists & is_deleted = false?"}
    T2 -->|"No: HTTP 404 Not Found"| S1
    T2 -->|"Yes"| T3{"status == ACTIVE?"}
    T3 -->|"No (Already RETURNED): Show status error"| S1
    T3 -->|"Yes: Set status = RETURNED"| S1

    S2 -->|"Soft-delete listing"| U1["Select target listing"]
    U1 --> U2{"Listing exists & is_deleted = false?"}
    U2 -->|"No: HTTP 404 Not Found"| S1
    U2 -->|"Yes: Set is_deleted = true (keep record)"| S1
