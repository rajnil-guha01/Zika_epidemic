zika_data = load '/home/cloudera/Desktop/newzika.csv' using PigStorage(',') as (report_date:chararray, location:chararray, location_type:chararray, data_field:chararray, data_field_code:chararray, time_period:chararray, time_period_type:chararray, value:int, unit:chararray);

confirmed_cases = filter zika_data by data_field matches '^.*confirmed.*';

values_required = foreach confirmed_cases generate REGEX_EXTRACT(location, '^[A-Za-z]+', 0) as country, ((int)(SUBSTRING(report_date, 8, 10)) / 7) as week, value;

group_values_required = group values_required by (country, week);

total_group_week = foreach group_values_required generate flatten(group) as (country, week), SUM(values_required.value) as total_values;

group_values_country = order total_group_week by country, total_values desc;

store group_values_country into '/home/cloudera/Desktop/results/WeekCount';
