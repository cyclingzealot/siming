SELECT 'timeentry' AS type,
       issue_id,
       comments,
       updated_on  AS ts
FROM   time_entries
WHERE  issue_id = :issueId
AND     updated_on > to_timestamp(:ts, 'YY-mm-dd')
UNION
SELECT 'journal',
       journalized_id,
       notes,
       created_on AS ts
FROM   journals
WHERE  journalized_id = :issueId
AND     created_on > to_timestamp(:ts, 'YY-mm-dd')
ORDER  BY ts;
