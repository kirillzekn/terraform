1. Export AWS credentials
export AWS_SECRET_ACCESS_KEY=""
export AWS_ACCESS_KEY_ID=""

2. Mount drive
sudo mount -t fuse.vmhgfs-fuse -o allow_other .host:/share ~/share

3. Debug
export TF_LOG=TRACE or DEBUG or INFO or ERROR or WARN
export TF_LOG_PATH=/path     

4. Terraform commands
  init
  plan
  plan -out=path
  apply
  apply filename
  refresh - refresh tfstate file
  validate  - validate syntax
  fmt - format
  taint
  graph
  output NAME_OF_OUTPUT_COMMAND
