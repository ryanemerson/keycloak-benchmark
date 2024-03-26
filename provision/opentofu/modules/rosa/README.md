# ROSA OpenTofu Modules
In order to use the modules in this directory, it's necessary for the var `token` to be set. This is an OpenShift Cluster
Manager token, which can be accessed in the [Red Hat Hybrid Cloud Console](https://console.redhat.com/openshift/token).

Instead of providing the token as a variable everytime `tofu` is called, it's possible to set the value via the
`TF_VAR_token` environment variable.
