Implementation Steps
====================

* Build a Candidate from a Trello::Card

* Build a Pipeline from a Trello::Board

  - Use the Trello API's /board/card/?filters=xxx route
  - Does this happen on demand? At application init? What's the simplest case?

* Filter a Pipeline by a date range

  - pipeline.candidates.starting(x).ending(y)

* Display a pipeline in tabular format

* Calculate metrics for a pipeline