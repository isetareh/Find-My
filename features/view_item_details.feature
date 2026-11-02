Feature: View Item Details

  As a Student,
  I want to view the details of an active listing,
  So that I can identify relevant lost or found items and contact the reporter.

  Scenario: Student views an active listing successfully
    Given the Student is logged in
    And an active listing exists with valid public information
    And the listing has an associated reporter with a university email
    When the Student opens the listing details page
    Then the system displays the title, description, category, type, location, and item date
    And the system displays the reporter's university email
    And the system displays the uploaded image if available
    And confidential identifying details are not displayed
    And private account information such as the password hash is not exposed

  Scenario: Student views a listing without an image
    Given the Student is logged in
    And an active listing exists without an uploaded image
    When the Student opens the listing details page
    Then the system displays a default placeholder image
    And no broken image or invalid image link is displayed

  Scenario Outline: Student cannot view an unavailable listing
    Given the Student is logged in
    And the requested listing <condition>
    When the Student requests the listing details
    Then the system does not display the listing details
    And the system displays "Listing not found or no longer available"

    Examples:
      | condition                 |
      | does not exist            |
      | has been soft-deleted     |
      | has a RETURNED status     |

  Scenario: Unauthenticated user cannot view listing details
    Given the user is not logged in
    And an active listing exists
    When the user requests the listing details
    Then the system denies access or redirects the user to the login page
    And the system does not return the listing details

  Scenario: Student does not see Staff management controls
    Given the Student is logged in
    When the Student opens a listing details page
    Then Staff management controls are not displayed

  Scenario: Student cannot access Staff management endpoints
    Given the Student is logged in
    When the Student sends a request to a Staff-only management endpoint
    Then the system rejects the request with HTTP 403 Forbidden
