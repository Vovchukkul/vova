##### REQUIRED #######
project_name           = "vova"                                         # Name of your project
region                 = "eu-west-1"                                      # Region where resources should be created
cloudfront_price_class = "PriceClass_100" # Select one from a list 
root_domain_name       = "vova-project.pp.ua"                                     # Your root domain name, don't use subdomain here
db_engine_version      = "16.10"
db_instance_class      = "db.t4g.micro"
db_storage             = 20
db_max_storage         = 30
db_username              = "qa_vova"
db_name                  = "qa_vova"
db_engine                = "postgres"

app_port               = "8000"
health_check_url       = "/health-check/"

task_cpu               = 512
task_memory            = 1024
task_desired_count     = 1



##### OPTIONAL #######
vpc_cidr_block             = "10.0.0.0/16"
subnet_a_cidr_block        = "10.0.1.0/24"
subnet_b_cidr_block        = "10.0.2.0/24"
subnet_c_cidr_block        = "10.0.3.0/24"
