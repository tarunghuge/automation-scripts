#!/bin/bash

domain_list="/data/ssl_expiration_checker/domain.txt"
html_table="/data/ssl_expiration_checker/ssloutput.txt"
th_calibri="<th style='font-family: calibri;'>"
td_calibri="<td style='font-family: calibri;'>"
td_red_calibri="<td bgcolor="red" style='font-family: calibri;'>"
td_cyan_calibri="<td bgcolor="cyan" style='font-family: calibri;'>"
tb_border="<table border='1' style='border-collapse: collapse; border: 1px solid black;padding: 2px;'>"
tr_head="<tr height="25" style='background-color: #B2CF99;'>"
>${html_table}

echo "<table>" >> $html_table
echo -e "<br>${tb_border}" >> $html_table
echo -e "<tr height="30" style='background-color: #F7D631;'><th style='color: black; font-family: calibri;' colspan='3'>SSL Expiration Details</th></tr>" >> $html_table
echo -e "${tr_head}${th_calibri}S.no</th>${th_calibri}Domain Name</th>${th_calibri}Expiration Date</th></tr>" >> $html_table
count=1

for i in `cat ${domain_list}`;
do 
expire=`echo | openssl s_client -connect ${i}:443 2> /dev/null | openssl x509 -noout -enddate |cut -d "=" -f2`
echo -e "${tr_head}${th_calibri}$count</th>${th_calibri}$i</th>${th_calibri}$expire</th></tr>" >> $html_table
count=$(($count+1))
done
echo "</table>" >> $html_table

