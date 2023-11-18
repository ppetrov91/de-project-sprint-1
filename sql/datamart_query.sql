INSERT INTO analysis.dm_rfm_segments(user_id, recency, frequency, monetary_value)
SELECT rec.user_id
     , rec.recency
     , freq.frequency
     , mon.monetary_value
  FROM analysis.tmp_rfm_recency rec
  JOIN analysis.tmp_rfm_frequency freq
    ON freq.user_id = rec.user_id 
  JOIN analysis.tmp_rfm_monetary_value mon
    ON mon.user_id = rec.user_id;

ANALYZE analysis.dm_rfm_segments;

SELECT d.* FROM analysis.dm_rfm_segments d ORDER BY d.user_id;

/*
user_id recency frequency monetary_value
0	      1	      3	        4
1	      4	      3	        3
2	      2	      3	        5
3	      2	      3         3
4	      4	      3	        3
5	      4	      5	        5
6	      1	      3	        5
7	      4	      2	        2
8	      1	      1	        3
9	      1	      2	        2
*/