This project was made with Google Cloud, the VMservers come with gcloud commands, otherwise you have to install and authenticate it. 
gcloud auth login

The Data is from Kaggle (synthetic dataset): https://www.kaggle.com/datasets/ricgomes/global-fashion-retail-stores-dataset

Reconstructed the data and uploaded it to my github for easier access.
sep_data.sh to split the data and used git push to upload it.

I used Ubuntu on my VM so the codes reflects that.

#0 Copy ’de_project’ folder into your home directory.
Use chmod +x on_scripts.sh
Use chmod +x on: terrafrom/run

#1 Install docker-compose with: docker_install.sh
Logout and login, so you have the right permission to run docker

#2Run the bash script: create_gc_project.sh
It makes a new project, a service account with the needed roles and the json certificate than 2 files: variables.tf for terraform and gcp_kv.yaml for kestra. These are filled with the created variables.

#3Run docker-compose: docker-compose up –d
- create a Terraform server which will crate a bucket and a BigQuery dataset.
- copies the certificate to use it on your newly created project ID
- create Kestra server and copies the .yaml flow files to the right place

#4 Kestra (Couldnt Automatization it) so we have to run it manualy (ipaddress:8080)
- You have to allow the port 8080 on the Google Cloud firewall

Execute: gcp_kv 
- KV Store values

Backfill gcp_fashion_data_scheduled 
– Create BigQuery tables with all the data
Backfill storage 2023jan-2024dec
Backfill prodcuts 2024dec (We only need the latest)

Execute: gcp_fashion_filter 
– Create the a BigQuery table with filtered data for dataviz (fashion_work)

#5 Dataviz, fashion_work table used for dataviz link: 
https://lookerstudio.google.com/reporting/2f443960-111d-4a13-bd3b-07c1f204c892
Made a PDF from my Google Looker Studio incase delete (only 1 week until trial ends)

