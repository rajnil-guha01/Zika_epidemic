zika_data = load '/home/cloudera/Desktop/newzika.csv' using PigStorage(',') as (report_date:chararray, location:chararray, location_type:chararray, data_field:chararray, data_field_code:chararray, time_period:chararray, time_period_type:chararray, value:int, unit:chararray);

confirmed_cases = filter zika_data by data_field matches '^.*confirmed.*';

extract_confirmed_values = foreach confirmed_cases generate REGEX_EXTRACT(location, '^[A-Za-z]+', 0) as country, value;

group_confirmed_values = group extract_confirmed_values by country;

total_confirmed = foreach group_confirmed_values generate group as country, SUM(extract_confirmed_values.value) as total_values;

order_total_confirmed = order total_confirmed by total_values desc;

store order_total_confirmed into '/home/cloudera/Desktop/results/ZikaConfirmedResults';
