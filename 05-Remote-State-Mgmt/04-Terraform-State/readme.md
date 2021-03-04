#terraform state list
    list resources part of tfstate file

#terraform state move
    move items into tf state file. E.g. if you renamed resource from resource "aws_instance""A" --> "aws_instance""B" , TF will destroy A and recreate B. In order to avoid it , use move command.
    terraform state mv aws_instance.A aws_instance.B

#terraform state pull
    allow us pull data from remote state source. like s3. 

#terraform state push
    push local state file to remote location

#terraform state remove
    allow us remove from the state file particular resource. Resource itself will not be removed , but TF will not be longer manage it. But if you run terraform plan command, TF will try to create prevously removed from state file resource. 

#terraform state show XXXX
    show attributes related to particular resource (XXX)