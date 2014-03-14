SET @starting_from = '2014-03-14'; SELECT 'gold_qa1' AS db_name, pb.created_at AS started_on, pb.description FROM gold_qa1.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_qa2' AS db_name, pb.created_at AS started_on, pb.description FROM gold_qa2.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_qa3' AS db_name, pb.created_at AS started_on, pb.description FROM gold_qa3.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_qa4' AS db_name, pb.created_at AS started_on, pb.description FROM gold_qa4.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_qa5' AS db_name, pb.created_at AS started_on, pb.description FROM gold_qa5.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_qa6' AS db_name, pb.created_at AS started_on, pb.description FROM gold_qa6.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_qa7' AS db_name, pb.created_at AS started_on, pb.description FROM gold_qa7.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_qa8' AS db_name, pb.created_at AS started_on, pb.description FROM gold_qa8.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_qa9' AS db_name, pb.created_at AS started_on, pb.description FROM gold_qa9.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_qa10' AS db_name, pb.created_at AS started_on, pb.description FROM gold_qa10.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_qa11' AS db_name, pb.created_at AS started_on, pb.description FROM gold_qa11.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_qa12' AS db_name, pb.created_at AS started_on, pb.description FROM gold_qa12.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_qa13' AS db_name, pb.created_at AS started_on, pb.description FROM gold_qa13.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_luca' AS db_name, pb.created_at AS started_on, pb.description FROM gold_luca.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_alex' AS db_name, pb.created_at AS started_on, pb.description FROM gold_alex.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_ae' AS db_name, pb.created_at AS started_on, pb.description FROM gold_ae.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_indrit' AS db_name, pb.created_at AS started_on, pb.description FROM gold_indrit.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_dario' AS db_name, pb.created_at AS started_on, pb.description FROM gold_dario.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_gregory' AS db_name, pb.created_at AS started_on, pb.description FROM gold_gregory.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_psingh' AS db_name, pb.created_at AS started_on, pb.description FROM gold_psingh.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_sumit' AS db_name, pb.created_at AS started_on, pb.description FROM gold_sumit.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_varun' AS db_name, pb.created_at AS started_on, pb.description FROM gold_varun.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_atif' AS db_name, pb.created_at AS started_on, pb.description FROM gold_atif.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_francesco' AS db_name, pb.created_at AS started_on, pb.description FROM gold_francesco.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_alessandra' AS db_name, pb.created_at AS started_on, pb.description FROM gold_alessandra.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_stefano' AS db_name, pb.created_at AS started_on, pb.description FROM gold_stefano.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_marco' AS db_name, pb.created_at AS started_on, pb.description FROM gold_marco.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_costajob' AS db_name, pb.created_at AS started_on, pb.description FROM gold_costajob.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_video' AS db_name, pb.created_at AS started_on, pb.description FROM gold_video.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_atul' AS db_name, pb.created_at AS started_on, pb.description FROM gold_atul.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_aayush' AS db_name, pb.created_at AS started_on, pb.description FROM gold_aayush.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_giuseppe' AS db_name, pb.created_at AS started_on, pb.description FROM gold_giuseppe.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_scandi' AS db_name, pb.created_at AS started_on, pb.description FROM gold_scandi.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_support' AS db_name, pb.created_at AS started_on, pb.description FROM gold_support.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_wiretransfer' AS db_name, pb.created_at AS started_on, pb.description FROM gold_wiretransfer.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_australia' AS db_name, pb.created_at AS started_on, pb.description FROM gold_australia.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_search' AS db_name, pb.created_at AS started_on, pb.description FROM gold_search.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_europe' AS db_name, pb.created_at AS started_on, pb.description FROM gold_europe.publishing_jobs pb WHERE pb.created_at >= @starting_from UNION SELECT 'gold_sopra' AS db_name, pb.created_at AS started_on, pb.description FROM gold_sopra.publishing_jobs pb WHERE pb.created_at >= @starting_from ORDER BY db_name, started_on DESC;