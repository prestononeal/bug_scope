# SCOPE

This application was written to help triage large number of crashes found between different test runs across different builds. Scope works as-is, but is intended to be viewed as a prototype and has lots of room for improvement. 

This was written quickly over a short period of time to address an immediate need. Best practices, such as writing unit tests for the data models and API's, were unfortunately skipped and are todo items.

Scope keeps track of "issues" found while testing builds. These issues can include crashes or any other problems that can be defined with a "type" and a "signature".

The cumulative total of all issues across all builds can be viewed in aggregate, or the individual builds can be inspected to see which issues were found. Issues are sorted by number of occurrences to help find the most common issues to help prioritize the resolution of them.

Tickets can be attached to issues (eg. a scrum task), and duplicate issues can be merged together. When viewing a specific issue, similar issues based on the signature will be displayed to provide hints of possible duplicates in other builds.
