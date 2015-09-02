#!/bin/bash
user=$(grep g_db_fulluser /usr/local/web/biocode/cgi/biocode_settings | awk -F\" '{print $(NF-1)}')
pass=$(grep g_db_fullpass /usr/local/web/biocode/cgi/biocode_settings | awk -F\" '{print $(NF-1)}')
location=$(grep g_db_location /usr/local/web/biocode/cgi/biocode_settings | awk -F\" '{print $(NF-1)}')

/usr/bin/mysqldump -p$pass -u$user -h $location --compress geneious > /data/biocode/database_backups/geneious_db.sql
/bin/gzip -f /data/biocode/database_backups/geneious_db.sql

/usr/bin/mysqldump -p$pass -u$user -h $location --compress biocode > /data/biocode/database_backups/biocode_db.sql
/bin/gzip -f /data/biocode/database_backups/biocode_db.sql
