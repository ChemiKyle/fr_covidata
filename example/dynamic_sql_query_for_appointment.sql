-- using repeating instances
SELECT a.id, CONCAT(b.site_short_name, ' - ', from_unixtime(a.appointment_block, '%m/%d/%Y %W %h:%i %p')) FROM
    (
        (SELECT * FROM redcap_entity_fr_appointment
            WHERE ( record_id IS NULL OR
                (record_id = [record-name] AND encounter = [current-instance])
                )
            AND project_id = [project-id]
            -- If it is later than 4pm, only show appointments at least 2 days from today
            AND appointment_block > UNIX_TIMESTAMP( DATE( NOW() + INTERVAL IF(HOUR(NOW()) >= 16, 2, 1) DAY ) )
            ORDER BY appointment_block
        ) as a
    INNER JOIN redcap_entity_test_site as b ON a.site = b.id
    )
    ORDER BY a.appointment_block
    ;

-- using individual events
SELECT a.id, CONCAT(b.site_short_name, ' - ', from_unixtime(a.appointment_block, '%m/%d/%Y %W %h:%i %p')) FROM
    (
        (SELECT * FROM redcap_entity_fr_appointment
            WHERE ( record_id IS NULL OR
                (record_id = [record-name])
                )
            AND project_id = [project-id]
            -- If it is later than 4pm, only show appointments at least 2 days from today
            AND appointment_block > UNIX_TIMESTAMP( DATE( NOW() + INTERVAL IF(HOUR(NOW()) >= 16, 2, 1) DAY ) )
            ORDER BY appointment_block
        ) as a
    INNER JOIN redcap_entity_test_site as b ON a.site = b.id
    )
    ORDER BY a.appointment_block
    ;
