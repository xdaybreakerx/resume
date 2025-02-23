# Resume

Previously I hosted a resume equivalent on Read.cv, which has [since announced they are winding down](https://read.cv/a-new-chapter) their product as they are joining the team at Perplexity.

As such, I've recreated the functionality I want with Astro.

This will be used as an extension of my portfolio site, which you can [find here.](https://xandersalathe.com)

The project design is based on the [Astro Resume Theme by srleom.](https://astro.build/themes/details/resume/)

This project is hosted on AWS following the high level guidelines from the [Cloud Resume Challenge.](https://cloudresumechallenge.dev/docs/the-challenge/aws/)

# Deployment and Infrastructure

## GitHub Actions

This project leverages GitHub Actions for continuous integration and deployment. The workflow builds the site and automatically pushes the output to an AWS S3 bucket, ensuring your resume is always up to date without manual intervention. It also invalidates the CloudFront cache to ensure the latest version is being displayed.

## Terraform

Terraform is used to provision and manage key AWS infrastructure components such as CloudFront distributions and S3 configurations. This infrastructure-as-code approach not only streamlines deployments but also keeps the setup consistent and easily maintainable. Future expansions would be to include the DynamoDB setup, and pushing the Python API script to the Lambda function. 

## AWS Services Used
### Account Configuration
- AWS IAM
- AWS Account Manager
- AWS Billing Center
---
### Hosting
- AWS S3
- AWS ACM
- AWS CloudFront
- AWS DynamoDB
- AWS Lambda
- AWS Route 52 (or Cloudflare)