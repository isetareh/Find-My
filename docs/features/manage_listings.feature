Feature: Manage Listings
  As a Staff member
  I want to manage listings
  So that I can mark returned items and remove inappropriate reports

 Given the Staff member is authenticated

  Scenario: View active and returned listings
    Given active and returned non-deleted listings exist
    When the Staff member views all listings
    Then both active and returned listings should be visible
    And soft-deleted listings should not be visible

  Scenario: Mark an active listing as returned
    Given an active non-deleted listing exists
    When the Staff member marks the listing as returned
    Then the listing status should be "RETURNED"
    And the listing should remain visible to Staff
    And the listing should not appear in Student active listings

  Scenario: Soft-delete an inappropriate listing
    Given an active non-deleted listing exists
    When the Staff member removes the listing
    Then the listing should have is_deleted set to true
    And the listing should not be visible to Students or Staff

  Scenario: Reject marking an already returned listing
    Given a returned non-deleted listing exists
    When the Staff member marks the listing as returned
    Then the system should reject the operation
    And an informative status error should be returned

  Scenario: Reject operations on a non-existent or deleted listing
    Given the target listing does not exist or is soft-deleted
    When the Staff member tries to mark it as returned or remove it
    Then the system should return HTTP 404 Not Found

  Scenario: Reject unauthorized listing management
    Given the user is a Student or is unauthenticated
    When the user tries to mark a listing as returned or remove it
    Then the system should return HTTP 403 Forbidden