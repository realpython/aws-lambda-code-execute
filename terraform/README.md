# howto
Deploy application with terraform 

### Table of Contents
**[Pre-deployment](#pre-deployment)**<br>
**[Deployment](#deployment)**<br>
**[Tests](#tests)**<br>


Pre-deployment
---

Zip your python code:

`zip python.zip lambda.py`

Create a aws s3 bucket with location constraint:

`aws s3api create-bucket --bucket=terraform-serverless-python --create-bucket-configuration LocationConstraint=eu-central-1` 

Upload your build artifact into newly created bucket:

`aws s3 cp python.zip s3://terraform-serverless-python/v1.0.0/python.zip`


Deployment
---

Deploy your application with your artifact already available in the s3 bucket

`terraform plan -var="app_version=1.0.0"`

`terraform apply -var="app_version=1.0.0"`

You should get an output of your API Gateway **base_url**:

```python
Outputs:
base_url = https://95q1xx0fol.execute-api.eu-central-1.amazonaws.com/v1
```

Tests
---
Test your lambda function via API Gateway with **curl**:

```python
curl -H "Content-Type: application/json" -X POST -d '{"answer":"def sum(x,y):\n    return x-y"}' base_url/pyexecute
```

Update your `assets/main.js` file with new **base_url**.
