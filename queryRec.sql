WITH RECURSIVE subcat AS (
	SELECT has_other_category, has_other_super_category
       		FROM has_other WHERE has_other_super_category = 'Perishable'
       	
	UNION ALL
		SELECT h.has_other_category, h.has_other_super_category 
		FROM has_other h, subcat s
	       	WHERE h.has_other_super_category = s.has_other_category	

) SELECT has_other_category FROM subcat;
