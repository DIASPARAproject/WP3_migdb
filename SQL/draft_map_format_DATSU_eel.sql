SELECT table_schema, table_name, column_name
  FROM information_schema.columns
 WHERE table_schema  ='dateel'
   AND table_name   in ('t_fish_fi' ,'t_group_gr' ,'t_grouptrait_grt' ,'t_indivtrait_int' ,'t_serannual_san' ,'t_series_ser'
)   ORDER BY table_name, ordinal_position;