zika_data = load '/home/cloudera/Desktop/newzika.csv' using PigStorage(',') as (report_date:chararray, location:chararray, location_type:chararray, data_field:chararray, data_field_code:chararray, time_period:chararray, time_period_type:chararray, value:int, unit:chararray);

confirmed_cases = filter zika_data by data_field matches '^.*confirmed.*';

month_data_field = foreach confirmed_cases generate SUBSTRING(report_date, 5, 7) as month, value;

group_by_months = group month_data_field by month;

months_count = foreach group_by_months generate group as month, SUM(month_data_field.value) as total_values;

order_month_count = order months_count by total_values desc;

store order_month_count into '/home/cloudera/Desktop/results/OrderedMonthResults';
