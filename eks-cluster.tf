module "eks" {
    source  = "terraform-aws-modules/eks/aws"
    version = "21.18.0"
    name    = "myapp-eks-cluster"
    kubernetes_version = "1.35"
    endpoint_public_access = true
    vpc_id = module.myapp-vpc.vpc_id
    subnet_ids = module.myapp-vpc.private_subnets

    eks_managed_node_groups = {
        example = {
        # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
        ami_type       = "AL2023_x86_64_STANDARD"
        instance_types = ["m5.xlarge"]

        min_size     = 2
        max_size     = 10
        desired_size = 2
        }
    }

    tags = {
        environment = "development"
        application = "myapp"
    }
}