# Homework for Module 5
-----
This module introduce to Cloud Computing.
-----

## Labs

1. I need to create free trial accounts in AWS/Azure, create Virtual Machine, config Security Groups(firewall), connect to Virtual Machine use SSH, create S3 bucket or Storage Account(Azure) and upload Superstore.xls. After that I need to draw architecture for solutions: VPC,Subnet, Internet Gateway, Route Table, Subnet.

* [AWS](#aws)
* [Azure](#azure)

<a name="aws"></a>AWS:

EC2_INSTANCES:
![ec2](./images/aws/ec2_instances.png)

VPC:
![vpc](./images/aws/vpc.png)

SUBNET:
![subnet](./images/aws/subnets.png)

ROUTE_TABLE:
![ec2](./images/aws/route_table.png)

INTERNET_GATEWAY:
![internet_gateway](./images/aws/internet_gateway.png)

ARCHITECTURE:
![architecture](./images/aws/AWS%20architecture.drawio.svg)

Connect to private and public ec2 by ssh:
![ssh_conn](./images/aws/ssh_conn.png)

<a name="azure"></a>AZURE:

VNET:
![vnet](./images/azure/VNet.png)

SUBNET:
![subnet](./images/azure/subnets.png)

ROUTE_TABLE:
![route_table](./images/azure/route_table.png)

NAT_GATEWAY:
![nat_gateway](./images/azure/nat_gateways.png)

ARCHITECTURE:
![architecture](./images/azure/Azure%20architecture.drawio.svg)

Connect to private and public ec2 by ssh:
![ssh_conn](./images/azure/ssh_conn.png)

-----

2. I need to create static web site on Amazon S3 and create and work with Azure Blob Storage.
The second part I need to create a Billing Alert in AWS Account. With AWS calculator I need to calculate cost of solutions. And tun template in AWS CloudFormation for any resource. Create two EC2, install apache web server for this servers and connect to Load Balancer. And draw architecture diagram.

- [AWS Static Web site](#aws_static_web_site)
- [Azure Bloc Storage](#azure_blob_storage)
- [AWS Billing Alert](#aws_billing_alert)
- [AWS Pricing Calculator](#aws_pricing_calculator)
- [First AWS CloudFormation Template](#fist_cloudfromation_template)
- [AWS EC2 Instances with Load Balancer](#ec2_instances_with_load_balancer)


<a name="aws_static_web_site"></a>AWS Static Web site

Bucket
![bucket](./images/aws/bucket.png)

Bucket Policy
![bucket_policy](./images/aws/bucket_policy.png)

Static Website settings
![static_website](./images/aws/static_website.png)

Website Index.html
![index](./images/aws/index_success.png)

Website Error.html
![error](./images/aws/error.png)


<a name="azure_blob_storage"></a>Azure Blob Storage

Storage
![storage](./images/azure/storage.png)

Container
![container](./images/azure/container.png)

Overview container
![overview_container](./images/azure/objects_in_container.png)

Public URI for file in container
![file_in_storage](./images/azure/url_for_file.png)

<a name="aws_billing_alert"></a>Billing Alert

![billing_alert](./images/aws/billing_alert.png)

![alarms](./images/aws/alarms.png)

![billing_alarm_1](./images/aws/billing_alarm_1.png)

![billing_alarm_2](./images/aws/billing_alarm_2.png)

<a name="aws_pricing_calculator"></a>Pricing Calculator

![pricinh_calculator](./images/aws/pricing_calculator.png)

<a name="fist_cloudfromation_template"></a>First AWS service created by cloudformation
TEMPLATE -> [HERE](./aws_template/first_temlapte.yaml)

CLOUDFORMATION PANEL
![cloud_formation1](./images/aws/cloudfromation1.png)

DEMO BUCKET
![demo_bucket](./images/aws/cf_bucket.png)

<a name="ec2_instances_with_load_balancer"></a>AWS 2 EC2 Instances with Load Balancer:
TEMPLATE -> [HERE](./aws_template/ec2_alb.yaml)

Infrastructure
![Infrastructure](./images/aws/ec2_alb/aws_ec2_instances_with_load_balancer.drawio.svg)

CloudFormation Stack
![Stack](./images/aws/ec2_alb/stack_demo_alb.png)

VPC
![VPC](./images/aws/ec2_alb/demo_vpc.png)

Subnets
![Subnets](./images/aws/ec2_alb/subnets.png)

Internet Gateway
![gateway](./images/aws/ec2_alb/gateways.png)

Route Tables
![route_tables](./images/aws/ec2_alb/route_tables.png)

Security Group
![security_group](./images/aws/ec2_alb/security_group.png)

EC2 Instances
![ec2](./images/aws/ec2_alb/ec2.png)

Load Balancer
![load_balancer](./images/aws/ec2_alb/load_balancer.png)

Example Website 1
![website1](./images/aws/ec2_alb/example_website1.png)

Example Website 2
![website2](./images/aws/ec2_alb/example_website2.png)

Stopped EC2 Instance2
![ec2](./images/aws/ec2_alb/stopped_ec2.png)

When I stopped the second instance EC2, Load Balancer use only EC2 Instance1 and response was:
Example Website 3
![website3](./images/aws/ec2_alb/exmaple_website3.png)