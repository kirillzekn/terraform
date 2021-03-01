module "test" {
  source = "github.com/zealvora/tmp-repo"
}

module "test1" {
  source = "github.com/zealvora/tmp-repo?ref=development"
}
