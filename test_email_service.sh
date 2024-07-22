#!/bin/bash

# Test sending an email via SES
aws ses send-email \
    --from "gaganjitsingh@13techs.com" \
    --destination "ToAddresses=gaganjitsingh@13techs.com" \
    --message "Subject={Data=Test Email,Charset=utf-8},Body={Text={Data=This is a test email.,Charset=utf-8}}"
