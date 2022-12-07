/*The client complained on performance degradation. The problem query was identified.
There is some unused space allocated in the index structure due to frequent 
INSERT/DELETE operations. So the index range scan operations were running slow.*/

/*Analyze index first*/analyze index {acc_rest_09_ind} validate structure;
select * from index_stats;

/*Options: 1. REBUILD, 2. COALESCE */
alter index {index_name} rebuild; --REBUILD statement is used to reorganize or compact an existing index
alter index
{
    index_name
}

coalesce; --COALESCE statement instructs Oracle to merge the contents of index blocks where possible to free blocks for reuse.
/*!!!COALESCE operation was much faster and improved query performance*/
