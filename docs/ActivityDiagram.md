# Find My — Activity Diagram

The flowchart below models the complete end-to-end workflow of the Find My application, aligned with `docs/SRS.md` and `docs/user-stories.md` (US1–US7).

```mermaid
flowchart TD
    A([Start]) --> B[Enter Login Credentials]
    B --> B1{Valid Credentials?}
    B1 -->|No: Show Error| B
    B1 -->|Yes| C{Account Role?}

    C -->|Student| D{Choose Student Action}
    C -->|Staff| S[View or Search Non-Deleted Listings]

    D -->|Create LOST or FOUND Listing| E[Enter Required Listing Details]
    E --> E1{Valid Input & item_date <= Today?}
    E1 -->|No: Show Validation Error| E
    E1 -->|Yes| F[Save Listing: ACTIVE, is_deleted = false]
    F --> G[Display in Active Listings]
    G --> Z([End])

    D -->|Browse or Search Listings| H[Browse or Search Active Listings]
    H --> I[Select Active Listing]
    I --> J[View Listing Details & Reporter Email]
    J --> K{Relevant Listing?}
    K -->|No| H
    K -->|Yes| L

    D -->|Mark Own Listing Returned| M1[Select Own Active Listing]
    M1 --> M2{Is Owner & Status = ACTIVE?}
    M2 -->|No: 403 or Error| Z
    M2 -->|Yes| U[Update status = RETURNED]

    subgraph External [Outside Application: In-Person Process]
        L[Contact Reporter via University Email] --> M[Arrange In-Person Meeting]
        M --> N[Verify Ownership & Hand Over Item]
    end

    N -->|Reporter Updates Status| M1
    N -->|Or Inform Staff| S

    S --> T{Select Staff Action}
    T -->|Mark Active Listing Returned| U
    T -->|Remove Listing| V[Soft Delete: is_deleted = true]
    T -->|No Action| Z
    U --> Z
    V --> Z
```

### Diagram Notes
* **Authentication & Role Detection (US1):** Failed logins loop back with a generic error; valid logins automatically route users based on their stored `STUDENT` or `STAFF` role.
* **Unified Listing Creation (US2 & US3):** Both `LOST` and `FOUND` listings pass through the same validation check (`E1`) before saving with `status = ACTIVE` and `is_deleted = false`.
* **Student Ownership Management (US7):** Students can mark their own `ACTIVE` listings as `RETURNED`, either directly from their menu or after an in-person handover.
* **Staff Moderation (US6):** Staff can view all non-deleted listings (`ACTIVE` and `RETURNED`), mark any active listing as `RETURNED`, or soft-delete inappropriate listings (`is_deleted = true`).
* **System Boundary:** Email communication, physical ownership verification, and item handover occur strictly outside the software.
