select
   i.id,
   p.identifier,            -- project identifier
   priority_id as prity,    -- Ticket priority
   round(cast (estimated_hours as numeric), 2) estimateHrs,
   subject,
   done_ratio,
   lastUpdate
from
   (
      select
         i.id,
         max(greatest(i.updated_on, j.created_on, t.updated_on)) as lastUpdate
      from
         issues i,
         journals j,
         time_entries t
      where
         t.issue_id = i.id
         and j.journalized_id = i.id
      group by i.id
   )
   lastUpdate,
   issues i,
   projects p
where i.project_id = p.id
   and p.status = 1
   -- and p.identifier = ':projectIdentifier'
   and i.status_id in
   (
      1,
      2,
      4,
      7
   )
   and i.id = lastUpdate.id
   and lastUpdate > to_timestamp(:ts, 'YY-mm-dd')
order by
   priority_id desc,
   p.identifier,
   i.id
