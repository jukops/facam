/* top 100 */
select time, client_ip, request_processing_time, target_processing_time, response_processing_time, elb_status_code, target_status_code, request_verb, request_url from foobar_alb_logs order by target_processing_time desc limit 100;

/* group by */
select request_url, count(request_url) from foobar_alb_logs  where target_processing_time > 10 group by request_url;
