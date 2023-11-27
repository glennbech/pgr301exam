ALL GITHUB SECRETS names:

AWS_ACCESS_KEY_ID

AWS_REGION

AWS_SECRET_ACCESS_KEY

ECR_REGISTRY_URL


1b
this should work, i had to incapulate keys with ""
docker build -t kjellpy . 
docker run -e AWS_ACCESS_KEY_ID=XXX -e AWS_SECRET_ACCESS_KEY=YYY -e BUCKET_NAME=kjellsimagebucket kjellpy

add /scan-ppe?bucketName=kjellsimagebucket to the url in browser to see json object after running mvn spring-boot:run

2a
this should also run, might need to encapsulate secrets with ""
docker build -t ppe . 
docker run -p 8080:8080 -e AWS_ACCESS_KEY_ID=XXX -e AWS_SECRET_ACCESS_KEY=YYY -e BUCKET_NAME=kjellsimagebucket ppe

