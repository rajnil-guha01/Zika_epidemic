zika_data = load '/home/cloudera/Desktop/newzika.csv' using PigStorage(',') as (report_date:chararray, location:chararray, location_type:chararray, data_field:chararray, data_field_code:chararray, time_period:chararray, time_period_type:chararray, value:int, unit:chararray);

suspected_cases = filter zika_data by data_field matches '^.*suspected.*';

extract_suspected_values = foreach suspected_cases generate REGEX_EXTRACT(location, '^[A-Za-z]+', 0) as country, value;

group_suspected_values = group extract_suspected_values by country;

total_suspected = foreach group_suspected_values generate group as country, SUM(extract_suspected_values.value) as total_values;

order_total_suspected = order total_suspected by total_values desc;

store order_total_suspected into '/home/cloudera/Desktop/results/ZikaSuspectedResults';
