# Find My — Activity Diagram

The flowchart below illustrates the complete operational workflow of the Find My application. It incorporates the failed login loop, an explicit input validation step with an error loop, automatic role detection, and an isolated subgraph for external in-person interactions[span_187](start_span)[span_187](end_span)[span_188](start_span)[span_188](end_span).

```mermaid
flowchart TD
    A([Start]) --> B[Enter Login Credentials]
    B --> B1{Valid Credentials?}
    B1 -->|No: Show Error| B
    B1 -->|Yes| C{Account Role?}
    
    C -->|Student| D{Choose Action}
    C -->|Staff| S[View All Non-Deleted Listings]
    
    D -->|Report Lost or Found| E[Enter Item Details]
    E --> E1{Valid Input & item_date <= Today?}
    E1 -->|No: Show Validation Error| E
    E1 -->|Yes| F[Save Report: Status = ACTIVE, is_deleted = false]
    F --> G[Display in Active Listings]
    G --> Z([End])
    
    D -->|Find Item| H[Browse or Search Active Listings]
    H --> I[Select Active Listing]
    I --> J[View Details & Reporter Email]
    J --> K{Relevant Item?}
    K -->|No| H
    K -->|Yes| L
    
    subgraph External [Outside Application: In-Person Process]
        L[Contact Reporter via University Email] --> M[Arrange In-Person Meeting on Campus]
        M --> N[Verify Ownership & Hand Over Item]
        N --> O[Inform University Staff Item Was Returned]
    end
    
    O --> S
    S --> T{Staff Action}
    T -->|Mark Returned| U[Set status = RETURNED]
    T -->|Remove Listing| V[Soft Delete: Set is_deleted = true]
    T -->|No Action| Z
    U --> Z
    V --> Z
