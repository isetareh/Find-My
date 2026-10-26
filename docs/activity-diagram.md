
# Find My — Activity Diagram

## 1. Overview

This document describes the activity diagram for **Find My**, a university lost-and-found system. It represents the main workflows, decisions, and interactions between students/users, the Find My System, and authorized university staff.

The diagram covers the processes associated with use cases UC1–UC20 defined in the project's Use Case Diagram.

## 2. Actors and Responsibilities

- **Student / User:** Reports lost or found items, searches listings, views item details, manages personal reports, submits ownership claims, provides identifying evidence, receives status updates, contacts the finder, and participates in the item return process.
- **Find My System:** Stores reports, separates public information from confidential details, evaluates ownership claims, and sends status updates without revealing sensitive information.
- **Authorized University Staff:** Reviews reports, investigates unverified or disputed ownership claims, accesses confidential item details when authorized, and confirms completed item returns.

## 3. Activity Diagram

The following Mermaid diagram illustrates the main workflows of the Find My system.

```mermaid
flowchart TD
    Start([Start]) --> Access[Access Find My System]
    Access --> Choice{Select User Action}

    subgraph Reporting["Reporting and Managing Items"]
        Choice -->|Create Report| Type{Lost or Found?}
        Type -->|Lost| UC1[UC1: Report a Lost Item]
        Type -->|Found| UC2[UC2: Report a Found Item]
        UC1 --> UC3[UC3: Enter Item Details]
        UC2 --> UC3
        UC3 --> Save[System: Save Report and Separate Public and Confidential Details]
        Save --> UC15[UC15: Staff Review and Manage Reports]

        Choice -->|Manage Own Report| Manage{Edit or Delete?}
        Manage -->|Edit| UC8[UC8: Edit Own Report]
        Manage -->|Delete| UC9[UC9: Delete Own Report]
    end

    subgraph Discovery["Browsing and Searching"]
        Choice -->|Find an Item| Discover{Browse or Search?}
        Discover -->|Browse| UC4[UC4: Browse Item Listings]
        Discover -->|Search| UC5[UC5: Search for an Item]
        UC5 --> Filters{Apply Filters?}
        Filters -->|Yes| UC6[UC6: Filter Search Results]
        Filters -->|No| UC7[UC7: View Public Report Details]
        UC4 --> UC7
        UC6 --> UC7
        UC7 --> Suspicious{Is the Listing Suspicious?}
        Suspicious -->|Yes| UC14[UC14: Report Suspicious Listing]
        UC14 --> Review[UC15: Staff Review and Manage Reports]
        Suspicious -->|No| Match{Does the Item Match?}
        Match -->|No| EndBrowse([End])
    end

    subgraph Claim["Ownership Verification"]
        Match -->|Yes| UC16[UC16: Submit Ownership Claim]
        UC16 --> UC18[UC18: Provide Identifying Evidence]
        UC18 --> UC19[UC19: Evaluate Ownership Claim]
        UC19 --> Conclusive{Is the Evaluation Conclusive?}
        Conclusive -->|No: Disputed or Uncertain| UC17[UC17: Staff Review of Unverified or Disputed Claim]
        UC17 --> UC20[UC20: Access Confidential Item Details]
        UC20 --> Verified{Is Ownership Verified?}
        Conclusive -->|Yes| Verified
        Verified -->|No| Rejected[Claim Rejected]
        Rejected --> UC13R[UC13: Send Claim Status Update]
        UC13R --> UC12R[UC12: Check Report or Claim Status]
        Verified -->|Yes| Approved[Claim Approved]
        Approved --> UC13A[UC13: Send Approval Update]
        UC13A --> UC12A[UC12: Check Report or Claim Status]
        UC12A --> UC10[UC10: Contact the Item Finder]
        UC10 --> Handover[Complete Physical Item Return]
        Handover --> UC11[UC11: Confirm Item Return]
    end

    UC8 --> EndManage([End])
    UC9 --> EndManage
    UC15 --> EndReport([End])
    Review --> EndSuspicious([End])
    UC12R --> EndRejected([End: Claim Rejected])
    UC11 --> EndReturned([End: Item Returned])
```

## 4. Design Decisions and Rules

### 4.1 Report Creation

Creating a lost-item report (UC1) or a found-item report (UC2) is followed by entering item details (UC3). The system stores public information separately from confidential identifying details.

### 4.2 Report Management

Users can edit (UC8) or delete (UC9) only their own reports. These actions are separate from creating a new report.

### 4.3 Ownership Claims

Submitting an ownership claim (UC16) requires identifying evidence (UC18). The system evaluates the claim (UC19) using confidential item details.

### 4.4 Manual Review

When automated evaluation is inconclusive or a claim is disputed, authorized staff review it (UC17) and access confidential item details (UC20) as necessary.

### 4.5 Privacy and Status Updates

Public listing details must not expose confidential information. Claim updates (UC13) must not disclose sensitive details or reveal which individual fields matched.

### 4.6 Item Return

Only an approved ownership claim proceeds to contacting the finder (UC10), physical item handover, and return confirmation (UC11).

## 5. Rendering and Viewing

- GitHub supports Mermaid diagrams inside Markdown files and can display the diagram directly.
- To render the diagram using PlantUML, save the PlantUML source in a separate file named `activity-diagram.puml` and open it with a PlantUML-compatible renderer, such as the PlantUML extension in Visual Studio Code.
- Keep this document at `docs/activity-diagram.md` in the repository.

## 6. Scope

This is an initial activity model of the main Find My workflows. It is intended to clarify the system's behavior and decisions before implementation. The details should be reviewed against the team's final Use Case Diagram and requirements.

