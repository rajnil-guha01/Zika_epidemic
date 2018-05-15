zika_data = load '/home/cloudera/Desktop/newzika.csv' using PigStorage(',') as (report_date:chararray, location:chararray, location_type:chararray, data_field:chararray, data_field_code:chararray, time_period:chararray, time_period_type:chararray, value:int, unit:chararray);

confirmed_cases = filter zika_data by data_field matches '^.*confirmed.*';

date_values_required = foreach confirmed_cases generate REGEX_EXTRACT(location, '^[A-Za-z]+', 0) as country, report_date, value;

group_date_values = group date_values_required by (country, report_date);

total_date_values = foreach group_date_values generate flatten(group) as (country, report_date), SUM(date_values_required.value) as total_values;

order_date_values = order total_date_values by country, report_date;

store order_date_values into '/home/cloudera/Desktop/results/CountryDateCount';
