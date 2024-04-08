resource "kubernetes_manifest" "customresourcedefinition_clusterloggings_logging_openshift_io" {
  manifest = {
    "apiVersion" = "apiextensions.k8s.io/v1"
    "kind" = "CustomResourceDefinition"
    "metadata" = {
      "annotations" = {
        "controller-gen.kubebuilder.io/version" = "v0.9.2"
        "operatorframework.io/installed-alongside-91d2c29f5faacca" = "openshift-logging/cluster-logging.v5.9.0"
      }
      "labels" = {
        "olm.managed" = "true"
        "operators.coreos.com/cluster-logging.openshift-logging" = ""
      }
      "name" = "clusterloggings.logging.openshift.io"
    }
    "spec" = {
      "conversion" = {
        "strategy" = "None"
      }
      "group" = "logging.openshift.io"
      "names" = {
        "categories" = [
          "logging",
        ]
        "kind" = "ClusterLogging"
        "listKind" = "ClusterLoggingList"
        "plural" = "clusterloggings"
        "shortNames" = [
          "cl",
        ]
        "singular" = "clusterlogging"
      }
      "scope" = "Namespaced"
      "versions" = [
        {
          "additionalPrinterColumns" = [
            {
              "jsonPath" = ".spec.managementState"
              "name" = "Management State"
              "type" = "string"
            },
          ]
          "name" = "v1"
          "schema" = {
            "openAPIV3Schema" = {
              "description" = "A Red Hat OpenShift Logging instance. ClusterLogging is the Schema for the clusterloggings API"
              "properties" = {
                "apiVersion" = {
                  "description" = "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
                  "type" = "string"
                }
                "kind" = {
                  "description" = "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
                  "type" = "string"
                }
                "metadata" = {
                  "type" = "object"
                }
                "spec" = {
                  "description" = "Specification of the desired behavior of ClusterLogging"
                  "properties" = {
                    "collection" = {
                      "description" = "Specification of the Collection component for the cluster"
                      "nullable" = true
                      "properties" = {
                        "fluentd" = {
                          "description" = "Fluentd represents the configuration for forwarders of type fluentd."
                          "nullable" = true
                          "properties" = {
                            "buffer" = {
                              "description" = <<-EOT
                              FluentdBufferSpec represents a subset of fluentd buffer parameters to tune the buffer configuration for all fluentd outputs. It supports a subset of parameters to configure buffer and queue sizing, flush operations and retry flushing. 
                               For general parameters refer to: https://docs.fluentd.org/configuration/buffer-section#buffering-parameters 
                               For flush parameters refer to: https://docs.fluentd.org/configuration/buffer-section#flushing-parameters 
                               For retry parameters refer to: https://docs.fluentd.org/configuration/buffer-section#retries-parameters
                              EOT
                              "properties" = {
                                "chunkLimitSize" = {
                                  "description" = "ChunkLimitSize represents the maximum size of each chunk. Events will be written into chunks until the size of chunks become this size."
                                  "pattern" = "^([0-9]+)([kmgtKMGT]{0,1})$"
                                  "type" = "string"
                                }
                                "flushInterval" = {
                                  "description" = "FlushInterval represents the time duration to wait between two consecutive flush operations. Takes only effect used together with `flushMode: interval`."
                                  "pattern" = "^([0-9]+)([smhd]{0,1})$"
                                  "type" = "string"
                                }
                                "flushMode" = {
                                  "description" = "FlushMode represents the mode of the flushing thread to write chunks. The mode allows lazy (if `time` parameter set), per interval or immediate flushing."
                                  "enum" = [
                                    "lazy",
                                    "interval",
                                    "immediate",
                                  ]
                                  "type" = "string"
                                }
                                "flushThreadCount" = {
                                  "description" = "FlushThreadCount reprents the number of threads used by the fluentd buffer plugin to flush/write chunks in parallel."
                                  "format" = "int32"
                                  "type" = "integer"
                                }
                                "overflowAction" = {
                                  "description" = "OverflowAction represents the action for the fluentd buffer plugin to execute when a buffer queue is full. (Default: block)"
                                  "enum" = [
                                    "throw_exception",
                                    "block",
                                    "drop_oldest_chunk",
                                  ]
                                  "type" = "string"
                                }
                                "retryMaxInterval" = {
                                  "description" = "RetryMaxInterval represents the maximum time interval for exponential backoff between retries. Takes only effect if used together with `retryType: exponential_backoff`."
                                  "pattern" = "^([0-9]+)([smhd]{0,1})$"
                                  "type" = "string"
                                }
                                "retryTimeout" = {
                                  "description" = "RetryTimeout represents the maximum time interval to attempt retries before giving up and the record is disguarded.  If unspecified, the default will be used"
                                  "pattern" = "^([0-9]+)([smhd]{0,1})$"
                                  "type" = "string"
                                }
                                "retryType" = {
                                  "description" = "RetryType represents the type of retrying flush operations. Flush operations can be retried either periodically or by applying exponential backoff."
                                  "enum" = [
                                    "exponential_backoff",
                                    "periodic",
                                  ]
                                  "type" = "string"
                                }
                                "retryWait" = {
                                  "description" = "RetryWait represents the time duration between two consecutive retries to flush buffers for periodic retries or a constant factor of time on retries with exponential backoff."
                                  "pattern" = "^([0-9]+)([smhd]{0,1})$"
                                  "type" = "string"
                                }
                                "totalLimitSize" = {
                                  "description" = "TotalLimitSize represents the threshold of node space allowed per fluentd buffer to allocate. Once this threshold is reached, all append operations will fail with error (and data will be lost)."
                                  "pattern" = "^([0-9]+)([kmgtKMGT]{0,1})$"
                                  "type" = "string"
                                }
                              }
                              "type" = "object"
                            }
                            "inFile" = {
                              "description" = <<-EOT
                              FluentdInFileSpec represents a subset of fluentd in-tail plugin parameters to tune the configuration for all fluentd in-tail inputs. 
                               For general parameters refer to: https://docs.fluentd.org/input/tail#parameters
                              EOT
                              "properties" = {
                                "readLinesLimit" = {
                                  "description" = "ReadLinesLimit represents the number of lines to read with each I/O operation"
                                  "type" = "integer"
                                }
                              }
                              "type" = "object"
                            }
                          }
                          "type" = "object"
                        }
                        "logs" = {
                          "description" = "Deprecated. Specification of Log Collection for the cluster See spec.collection"
                          "nullable" = true
                          "properties" = {
                            "fluentd" = {
                              "description" = "Specification of the Fluentd Log Collection component"
                              "properties" = {
                                "nodeSelector" = {
                                  "additionalProperties" = {
                                    "type" = "string"
                                  }
                                  "description" = "Define which Nodes the Pods are scheduled on."
                                  "nullable" = true
                                  "type" = "object"
                                }
                                "resources" = {
                                  "description" = "The resource requirements for the collector"
                                  "nullable" = true
                                  "properties" = {
                                    "claims" = {
                                      "description" = <<-EOT
                                      Claims lists the names of resources, defined in spec.resourceClaims, that are used by this container. 
                                       This is an alpha field and requires enabling the DynamicResourceAllocation feature gate. 
                                       This field is immutable. It can only be set for containers.
                                      EOT
                                      "items" = {
                                        "description" = "ResourceClaim references one entry in PodSpec.ResourceClaims."
                                        "properties" = {
                                          "name" = {
                                            "description" = "Name must match the name of one entry in pod.spec.resourceClaims of the Pod where this field is used. It makes that resource available inside a container."
                                            "type" = "string"
                                          }
                                        }
                                        "required" = [
                                          "name",
                                        ]
                                        "type" = "object"
                                      }
                                      "type" = "array"
                                      "x-kubernetes-list-map-keys" = [
                                        "name",
                                      ]
                                      "x-kubernetes-list-type" = "map"
                                    }
                                    "limits" = {
                                      "additionalProperties" = {
                                        "anyOf" = [
                                          {
                                            "type" = "integer"
                                          },
                                          {
                                            "type" = "string"
                                          },
                                        ]
                                        "pattern" = "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
                                        "x-kubernetes-int-or-string" = true
                                      }
                                      "description" = "Limits describes the maximum amount of compute resources allowed. More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/"
                                      "type" = "object"
                                    }
                                    "requests" = {
                                      "additionalProperties" = {
                                        "anyOf" = [
                                          {
                                            "type" = "integer"
                                          },
                                          {
                                            "type" = "string"
                                          },
                                        ]
                                        "pattern" = "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
                                        "x-kubernetes-int-or-string" = true
                                      }
                                      "description" = "Requests describes the minimum amount of compute resources required. If Requests is omitted for a container, it defaults to Limits if that is explicitly specified, otherwise to an implementation-defined value. Requests cannot exceed Limits. More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/"
                                      "type" = "object"
                                    }
                                  }
                                  "type" = "object"
                                }
                                "tolerations" = {
                                  "description" = "Define the tolerations the Pods will accept"
                                  "items" = {
                                    "description" = "The pod this Toleration is attached to tolerates any taint that matches the triple <key,value,effect> using the matching operator <operator>."
                                    "properties" = {
                                      "effect" = {
                                        "description" = "Effect indicates the taint effect to match. Empty means match all taint effects. When specified, allowed values are NoSchedule, PreferNoSchedule and NoExecute."
                                        "type" = "string"
                                      }
                                      "key" = {
                                        "description" = "Key is the taint key that the toleration applies to. Empty means match all taint keys. If the key is empty, operator must be Exists; this combination means to match all values and all keys."
                                        "type" = "string"
                                      }
                                      "operator" = {
                                        "description" = "Operator represents a key's relationship to the value. Valid operators are Exists and Equal. Defaults to Equal. Exists is equivalent to wildcard for value, so that a pod can tolerate all taints of a particular category."
                                        "type" = "string"
                                      }
                                      "tolerationSeconds" = {
                                        "description" = "TolerationSeconds represents the period of time the toleration (which must be of effect NoExecute, otherwise this field is ignored) tolerates the taint. By default, it is not set, which means tolerate the taint forever (do not evict). Zero and negative values will be treated as 0 (evict immediately) by the system."
                                        "format" = "int64"
                                        "type" = "integer"
                                      }
                                      "value" = {
                                        "description" = "Value is the taint value the toleration matches to. If the operator is Exists, the value should be empty, otherwise just a regular string."
                                        "type" = "string"
                                      }
                                    }
                                    "type" = "object"
                                  }
                                  "nullable" = true
                                  "type" = "array"
                                }
                              }
                              "type" = "object"
                            }
                            "type" = {
                              "description" = "The type of Log Collection to configure"
                              "type" = "string"
                            }
                          }
                          "required" = [
                            "type",
                          ]
                          "type" = "object"
                        }
                        "nodeSelector" = {
                          "additionalProperties" = {
                            "type" = "string"
                          }
                          "description" = "Define which Nodes the Pods are scheduled on."
                          "nullable" = true
                          "type" = "object"
                        }
                        "resources" = {
                          "description" = "The resource requirements for the collector"
                          "nullable" = true
                          "properties" = {
                            "claims" = {
                              "description" = <<-EOT
                              Claims lists the names of resources, defined in spec.resourceClaims, that are used by this container. 
                               This is an alpha field and requires enabling the DynamicResourceAllocation feature gate. 
                               This field is immutable. It can only be set for containers.
                              EOT
                              "items" = {
                                "description" = "ResourceClaim references one entry in PodSpec.ResourceClaims."
                                "properties" = {
                                  "name" = {
                                    "description" = "Name must match the name of one entry in pod.spec.resourceClaims of the Pod where this field is used. It makes that resource available inside a container."
                                    "type" = "string"
                                  }
                                }
                                "required" = [
                                  "name",
                                ]
                                "type" = "object"
                              }
                              "type" = "array"
                              "x-kubernetes-list-map-keys" = [
                                "name",
                              ]
                              "x-kubernetes-list-type" = "map"
                            }
                            "limits" = {
                              "additionalProperties" = {
                                "anyOf" = [
                                  {
                                    "type" = "integer"
                                  },
                                  {
                                    "type" = "string"
                                  },
                                ]
                                "pattern" = "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
                                "x-kubernetes-int-or-string" = true
                              }
                              "description" = "Limits describes the maximum amount of compute resources allowed. More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/"
                              "type" = "object"
                            }
                            "requests" = {
                              "additionalProperties" = {
                                "anyOf" = [
                                  {
                                    "type" = "integer"
                                  },
                                  {
                                    "type" = "string"
                                  },
                                ]
                                "pattern" = "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
                                "x-kubernetes-int-or-string" = true
                              }
                              "description" = "Requests describes the minimum amount of compute resources required. If Requests is omitted for a container, it defaults to Limits if that is explicitly specified, otherwise to an implementation-defined value. Requests cannot exceed Limits. More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/"
                              "type" = "object"
                            }
                          }
                          "type" = "object"
                        }
                        "tolerations" = {
                          "description" = "Define the tolerations the Pods will accept"
                          "items" = {
                            "description" = "The pod this Toleration is attached to tolerates any taint that matches the triple <key,value,effect> using the matching operator <operator>."
                            "properties" = {
                              "effect" = {
                                "description" = "Effect indicates the taint effect to match. Empty means match all taint effects. When specified, allowed values are NoSchedule, PreferNoSchedule and NoExecute."
                                "type" = "string"
                              }
                              "key" = {
                                "description" = "Key is the taint key that the toleration applies to. Empty means match all taint keys. If the key is empty, operator must be Exists; this combination means to match all values and all keys."
                                "type" = "string"
                              }
                              "operator" = {
                                "description" = "Operator represents a key's relationship to the value. Valid operators are Exists and Equal. Defaults to Equal. Exists is equivalent to wildcard for value, so that a pod can tolerate all taints of a particular category."
                                "type" = "string"
                              }
                              "tolerationSeconds" = {
                                "description" = "TolerationSeconds represents the period of time the toleration (which must be of effect NoExecute, otherwise this field is ignored) tolerates the taint. By default, it is not set, which means tolerate the taint forever (do not evict). Zero and negative values will be treated as 0 (evict immediately) by the system."
                                "format" = "int64"
                                "type" = "integer"
                              }
                              "value" = {
                                "description" = "Value is the taint value the toleration matches to. If the operator is Exists, the value should be empty, otherwise just a regular string."
                                "type" = "string"
                              }
                            }
                            "type" = "object"
                          }
                          "nullable" = true
                          "type" = "array"
                        }
                        "type" = {
                          "description" = "The type of Log Collection to configure"
                          "type" = "string"
                        }
                      }
                      "type" = "object"
                    }
                    "curation" = {
                      "description" = "Deprecated. Specification of the Curation component for the cluster This component was specifically for use with Elasticsearch and was replaced by index management spec"
                      "nullable" = true
                      "properties" = {
                        "curator" = {
                          "description" = "The specification of curation to configure"
                          "properties" = {
                            "nodeSelector" = {
                              "additionalProperties" = {
                                "type" = "string"
                              }
                              "description" = "Define which Nodes the Pods are scheduled on."
                              "nullable" = true
                              "type" = "object"
                            }
                            "resources" = {
                              "description" = "The resource requirements for Curator"
                              "nullable" = true
                              "properties" = {
                                "claims" = {
                                  "description" = <<-EOT
                                  Claims lists the names of resources, defined in spec.resourceClaims, that are used by this container. 
                                   This is an alpha field and requires enabling the DynamicResourceAllocation feature gate. 
                                   This field is immutable. It can only be set for containers.
                                  EOT
                                  "items" = {
                                    "description" = "ResourceClaim references one entry in PodSpec.ResourceClaims."
                                    "properties" = {
                                      "name" = {
                                        "description" = "Name must match the name of one entry in pod.spec.resourceClaims of the Pod where this field is used. It makes that resource available inside a container."
                                        "type" = "string"
                                      }
                                    }
                                    "required" = [
                                      "name",
                                    ]
                                    "type" = "object"
                                  }
                                  "type" = "array"
                                  "x-kubernetes-list-map-keys" = [
                                    "name",
                                  ]
                                  "x-kubernetes-list-type" = "map"
                                }
                                "limits" = {
                                  "additionalProperties" = {
                                    "anyOf" = [
                                      {
                                        "type" = "integer"
                                      },
                                      {
                                        "type" = "string"
                                      },
                                    ]
                                    "pattern" = "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
                                    "x-kubernetes-int-or-string" = true
                                  }
                                  "description" = "Limits describes the maximum amount of compute resources allowed. More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/"
                                  "type" = "object"
                                }
                                "requests" = {
                                  "additionalProperties" = {
                                    "anyOf" = [
                                      {
                                        "type" = "integer"
                                      },
                                      {
                                        "type" = "string"
                                      },
                                    ]
                                    "pattern" = "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
                                    "x-kubernetes-int-or-string" = true
                                  }
                                  "description" = "Requests describes the minimum amount of compute resources required. If Requests is omitted for a container, it defaults to Limits if that is explicitly specified, otherwise to an implementation-defined value. Requests cannot exceed Limits. More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/"
                                  "type" = "object"
                                }
                              }
                              "type" = "object"
                            }
                            "schedule" = {
                              "description" = "The cron schedule that the Curator job is run. Defaults to \"30 3 * * *\""
                              "type" = "string"
                            }
                            "tolerations" = {
                              "items" = {
                                "description" = "The pod this Toleration is attached to tolerates any taint that matches the triple <key,value,effect> using the matching operator <operator>."
                                "properties" = {
                                  "effect" = {
                                    "description" = "Effect indicates the taint effect to match. Empty means match all taint effects. When specified, allowed values are NoSchedule, PreferNoSchedule and NoExecute."
                                    "type" = "string"
                                  }
                                  "key" = {
                                    "description" = "Key is the taint key that the toleration applies to. Empty means match all taint keys. If the key is empty, operator must be Exists; this combination means to match all values and all keys."
                                    "type" = "string"
                                  }
                                  "operator" = {
                                    "description" = "Operator represents a key's relationship to the value. Valid operators are Exists and Equal. Defaults to Equal. Exists is equivalent to wildcard for value, so that a pod can tolerate all taints of a particular category."
                                    "type" = "string"
                                  }
                                  "tolerationSeconds" = {
                                    "description" = "TolerationSeconds represents the period of time the toleration (which must be of effect NoExecute, otherwise this field is ignored) tolerates the taint. By default, it is not set, which means tolerate the taint forever (do not evict). Zero and negative values will be treated as 0 (evict immediately) by the system."
                                    "format" = "int64"
                                    "type" = "integer"
                                  }
                                  "value" = {
                                    "description" = "Value is the taint value the toleration matches to. If the operator is Exists, the value should be empty, otherwise just a regular string."
                                    "type" = "string"
                                  }
                                }
                                "type" = "object"
                              }
                              "type" = "array"
                            }
                          }
                          "required" = [
                            "schedule",
                          ]
                          "type" = "object"
                        }
                        "type" = {
                          "description" = "The kind of curation to configure"
                          "type" = "string"
                        }
                      }
                      "required" = [
                        "type",
                      ]
                      "type" = "object"
                    }
                    "forwarder" = {
                      "description" = "Deprecated. Specification for Forwarder component for the cluster See spec.collection.fluentd"
                      "nullable" = true
                      "properties" = {
                        "fluentd" = {
                          "description" = "FluentdForwarderSpec represents the configuration for forwarders of type fluentd."
                          "properties" = {
                            "buffer" = {
                              "description" = <<-EOT
                              FluentdBufferSpec represents a subset of fluentd buffer parameters to tune the buffer configuration for all fluentd outputs. It supports a subset of parameters to configure buffer and queue sizing, flush operations and retry flushing. 
                               For general parameters refer to: https://docs.fluentd.org/configuration/buffer-section#buffering-parameters 
                               For flush parameters refer to: https://docs.fluentd.org/configuration/buffer-section#flushing-parameters 
                               For retry parameters refer to: https://docs.fluentd.org/configuration/buffer-section#retries-parameters
                              EOT
                              "properties" = {
                                "chunkLimitSize" = {
                                  "description" = "ChunkLimitSize represents the maximum size of each chunk. Events will be written into chunks until the size of chunks become this size."
                                  "pattern" = "^([0-9]+)([kmgtKMGT]{0,1})$"
                                  "type" = "string"
                                }
                                "flushInterval" = {
                                  "description" = "FlushInterval represents the time duration to wait between two consecutive flush operations. Takes only effect used together with `flushMode: interval`."
                                  "pattern" = "^([0-9]+)([smhd]{0,1})$"
                                  "type" = "string"
                                }
                                "flushMode" = {
                                  "description" = "FlushMode represents the mode of the flushing thread to write chunks. The mode allows lazy (if `time` parameter set), per interval or immediate flushing."
                                  "enum" = [
                                    "lazy",
                                    "interval",
                                    "immediate",
                                  ]
                                  "type" = "string"
                                }
                                "flushThreadCount" = {
                                  "description" = "FlushThreadCount reprents the number of threads used by the fluentd buffer plugin to flush/write chunks in parallel."
                                  "format" = "int32"
                                  "type" = "integer"
                                }
                                "overflowAction" = {
                                  "description" = "OverflowAction represents the action for the fluentd buffer plugin to execute when a buffer queue is full. (Default: block)"
                                  "enum" = [
                                    "throw_exception",
                                    "block",
                                    "drop_oldest_chunk",
                                  ]
                                  "type" = "string"
                                }
                                "retryMaxInterval" = {
                                  "description" = "RetryMaxInterval represents the maximum time interval for exponential backoff between retries. Takes only effect if used together with `retryType: exponential_backoff`."
                                  "pattern" = "^([0-9]+)([smhd]{0,1})$"
                                  "type" = "string"
                                }
                                "retryTimeout" = {
                                  "description" = "RetryTimeout represents the maximum time interval to attempt retries before giving up and the record is disguarded.  If unspecified, the default will be used"
                                  "pattern" = "^([0-9]+)([smhd]{0,1})$"
                                  "type" = "string"
                                }
                                "retryType" = {
                                  "description" = "RetryType represents the type of retrying flush operations. Flush operations can be retried either periodically or by applying exponential backoff."
                                  "enum" = [
                                    "exponential_backoff",
                                    "periodic",
                                  ]
                                  "type" = "string"
                                }
                                "retryWait" = {
                                  "description" = "RetryWait represents the time duration between two consecutive retries to flush buffers for periodic retries or a constant factor of time on retries with exponential backoff."
                                  "pattern" = "^([0-9]+)([smhd]{0,1})$"
                                  "type" = "string"
                                }
                                "totalLimitSize" = {
                                  "description" = "TotalLimitSize represents the threshold of node space allowed per fluentd buffer to allocate. Once this threshold is reached, all append operations will fail with error (and data will be lost)."
                                  "pattern" = "^([0-9]+)([kmgtKMGT]{0,1})$"
                                  "type" = "string"
                                }
                              }
                              "type" = "object"
                            }
                            "inFile" = {
                              "description" = <<-EOT
                              FluentdInFileSpec represents a subset of fluentd in-tail plugin parameters to tune the configuration for all fluentd in-tail inputs. 
                               For general parameters refer to: https://docs.fluentd.org/input/tail#parameters
                              EOT
                              "properties" = {
                                "readLinesLimit" = {
                                  "description" = "ReadLinesLimit represents the number of lines to read with each I/O operation"
                                  "type" = "integer"
                                }
                              }
                              "type" = "object"
                            }
                          }
                          "type" = "object"
                        }
                      }
                      "type" = "object"
                    }
                    "logStore" = {
                      "description" = "Specification of the Log Storage component for the cluster"
                      "nullable" = true
                      "properties" = {
                        "elasticsearch" = {
                          "description" = "Specification of the Elasticsearch Log Store component"
                          "properties" = {
                            "nodeCount" = {
                              "description" = "Number of nodes to deploy for Elasticsearch"
                              "format" = "int32"
                              "type" = "integer"
                            }
                            "nodeSelector" = {
                              "additionalProperties" = {
                                "type" = "string"
                              }
                              "description" = "Define which Nodes the Pods are scheduled on."
                              "nullable" = true
                              "type" = "object"
                            }
                            "proxy" = {
                              "description" = "Specification of the Elasticsearch Proxy component"
                              "properties" = {
                                "resources" = {
                                  "description" = "ResourceRequirements describes the compute resource requirements."
                                  "nullable" = true
                                  "properties" = {
                                    "claims" = {
                                      "description" = <<-EOT
                                      Claims lists the names of resources, defined in spec.resourceClaims, that are used by this container. 
                                       This is an alpha field and requires enabling the DynamicResourceAllocation feature gate. 
                                       This field is immutable. It can only be set for containers.
                                      EOT
                                      "items" = {
                                        "description" = "ResourceClaim references one entry in PodSpec.ResourceClaims."
                                        "properties" = {
                                          "name" = {
                                            "description" = "Name must match the name of one entry in pod.spec.resourceClaims of the Pod where this field is used. It makes that resource available inside a container."
                                            "type" = "string"
                                          }
                                        }
                                        "required" = [
                                          "name",
                                        ]
                                        "type" = "object"
                                      }
                                      "type" = "array"
                                      "x-kubernetes-list-map-keys" = [
                                        "name",
                                      ]
                                      "x-kubernetes-list-type" = "map"
                                    }
                                    "limits" = {
                                      "additionalProperties" = {
                                        "anyOf" = [
                                          {
                                            "type" = "integer"
                                          },
                                          {
                                            "type" = "string"
                                          },
                                        ]
                                        "pattern" = "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
                                        "x-kubernetes-int-or-string" = true
                                      }
                                      "description" = "Limits describes the maximum amount of compute resources allowed. More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/"
                                      "type" = "object"
                                    }
                                    "requests" = {
                                      "additionalProperties" = {
                                        "anyOf" = [
                                          {
                                            "type" = "integer"
                                          },
                                          {
                                            "type" = "string"
                                          },
                                        ]
                                        "pattern" = "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
                                        "x-kubernetes-int-or-string" = true
                                      }
                                      "description" = "Requests describes the minimum amount of compute resources required. If Requests is omitted for a container, it defaults to Limits if that is explicitly specified, otherwise to an implementation-defined value. Requests cannot exceed Limits. More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/"
                                      "type" = "object"
                                    }
                                  }
                                  "type" = "object"
                                }
                              }
                              "type" = "object"
                            }
                            "redundancyPolicy" = {
                              "description" = "The policy towards data redundancy to specify the number of redundant primary shards"
                              "enum" = [
                                "FullRedundancy",
                                "MultipleRedundancy",
                                "SingleRedundancy",
                                "ZeroRedundancy",
                              ]
                              "type" = "string"
                            }
                            "resources" = {
                              "description" = "The resource requirements for Elasticsearch"
                              "nullable" = true
                              "properties" = {
                                "claims" = {
                                  "description" = <<-EOT
                                  Claims lists the names of resources, defined in spec.resourceClaims, that are used by this container. 
                                   This is an alpha field and requires enabling the DynamicResourceAllocation feature gate. 
                                   This field is immutable. It can only be set for containers.
                                  EOT
                                  "items" = {
                                    "description" = "ResourceClaim references one entry in PodSpec.ResourceClaims."
                                    "properties" = {
                                      "name" = {
                                        "description" = "Name must match the name of one entry in pod.spec.resourceClaims of the Pod where this field is used. It makes that resource available inside a container."
                                        "type" = "string"
                                      }
                                    }
                                    "required" = [
                                      "name",
                                    ]
                                    "type" = "object"
                                  }
                                  "type" = "array"
                                  "x-kubernetes-list-map-keys" = [
                                    "name",
                                  ]
                                  "x-kubernetes-list-type" = "map"
                                }
                                "limits" = {
                                  "additionalProperties" = {
                                    "anyOf" = [
                                      {
                                        "type" = "integer"
                                      },
                                      {
                                        "type" = "string"
                                      },
                                    ]
                                    "pattern" = "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
                                    "x-kubernetes-int-or-string" = true
                                  }
                                  "description" = "Limits describes the maximum amount of compute resources allowed. More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/"
                                  "type" = "object"
                                }
                                "requests" = {
                                  "additionalProperties" = {
                                    "anyOf" = [
                                      {
                                        "type" = "integer"
                                      },
                                      {
                                        "type" = "string"
                                      },
                                    ]
                                    "pattern" = "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
                                    "x-kubernetes-int-or-string" = true
                                  }
                                  "description" = "Requests describes the minimum amount of compute resources required. If Requests is omitted for a container, it defaults to Limits if that is explicitly specified, otherwise to an implementation-defined value. Requests cannot exceed Limits. More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/"
                                  "type" = "object"
                                }
                              }
                              "type" = "object"
                            }
                            "storage" = {
                              "description" = "The storage specification for Elasticsearch data nodes"
                              "nullable" = true
                              "properties" = {
                                "size" = {
                                  "anyOf" = [
                                    {
                                      "type" = "integer"
                                    },
                                    {
                                      "type" = "string"
                                    },
                                  ]
                                  "description" = "The max storage capacity for the node to provision."
                                  "pattern" = "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
                                  "x-kubernetes-int-or-string" = true
                                }
                                "storageClassName" = {
                                  "description" = "The name of the storage class to use with creating the node's PVC. More info: https://kubernetes.io/docs/concepts/storage/storage-classes/"
                                  "type" = "string"
                                }
                              }
                              "type" = "object"
                            }
                            "tolerations" = {
                              "items" = {
                                "description" = "The pod this Toleration is attached to tolerates any taint that matches the triple <key,value,effect> using the matching operator <operator>."
                                "properties" = {
                                  "effect" = {
                                    "description" = "Effect indicates the taint effect to match. Empty means match all taint effects. When specified, allowed values are NoSchedule, PreferNoSchedule and NoExecute."
                                    "type" = "string"
                                  }
                                  "key" = {
                                    "description" = "Key is the taint key that the toleration applies to. Empty means match all taint keys. If the key is empty, operator must be Exists; this combination means to match all values and all keys."
                                    "type" = "string"
                                  }
                                  "operator" = {
                                    "description" = "Operator represents a key's relationship to the value. Valid operators are Exists and Equal. Defaults to Equal. Exists is equivalent to wildcard for value, so that a pod can tolerate all taints of a particular category."
                                    "type" = "string"
                                  }
                                  "tolerationSeconds" = {
                                    "description" = "TolerationSeconds represents the period of time the toleration (which must be of effect NoExecute, otherwise this field is ignored) tolerates the taint. By default, it is not set, which means tolerate the taint forever (do not evict). Zero and negative values will be treated as 0 (evict immediately) by the system."
                                    "format" = "int64"
                                    "type" = "integer"
                                  }
                                  "value" = {
                                    "description" = "Value is the taint value the toleration matches to. If the operator is Exists, the value should be empty, otherwise just a regular string."
                                    "type" = "string"
                                  }
                                }
                                "type" = "object"
                              }
                              "type" = "array"
                            }
                          }
                          "type" = "object"
                        }
                        "lokistack" = {
                          "description" = <<-EOT
                          LokiStack contains information about which LokiStack to use for log storage if Type is set to LogStoreTypeLokiStack. 
                           The cluster-logging-operator does not create or manage the referenced LokiStack.
                          EOT
                          "properties" = {
                            "name" = {
                              "description" = "Name of the LokiStack resource."
                              "type" = "string"
                            }
                          }
                          "required" = [
                            "name",
                          ]
                          "type" = "object"
                        }
                        "retentionPolicy" = {
                          "description" = "Retention policy defines the maximum age for an Elasticsearch index after which it should be deleted"
                          "nullable" = true
                          "properties" = {
                            "application" = {
                              "nullable" = true
                              "properties" = {
                                "diskThresholdPercent" = {
                                  "description" = "The threshold percentage of ES disk usage that when reached, old indices should be deleted (e.g. 75)"
                                  "format" = "int64"
                                  "type" = "integer"
                                }
                                "maxAge" = {
                                  "description" = "TimeUnit is a time unit like h,m,d"
                                  "pattern" = "^([0-9]+)([wdhHms]{0,1})$"
                                  "type" = "string"
                                }
                                "namespaceSpec" = {
                                  "description" = "The per namespace specification to delete documents older than a given minimum age"
                                  "items" = {
                                    "properties" = {
                                      "minAge" = {
                                        "description" = "Delete the records matching the namespaces which are older than this MinAge (e.g. 1d)"
                                        "pattern" = "^([0-9]+)([wdhHms]{0,1})$"
                                        "type" = "string"
                                      }
                                      "namespace" = {
                                        "description" = "Target Namespace to delete logs older than MinAge (defaults to 7d) Can be one namespace name or a prefix (e.g., \"openshift-\" covers all namespaces with this prefix)"
                                        "type" = "string"
                                      }
                                    }
                                    "required" = [
                                      "namespace",
                                    ]
                                    "type" = "object"
                                  }
                                  "type" = "array"
                                }
                                "pruneNamespacesInterval" = {
                                  "description" = "How often to run a new prune-namespaces job"
                                  "pattern" = "^([0-9]+)([wdhHms]{0,1})$"
                                  "type" = "string"
                                }
                              }
                              "type" = "object"
                            }
                            "audit" = {
                              "nullable" = true
                              "properties" = {
                                "diskThresholdPercent" = {
                                  "description" = "The threshold percentage of ES disk usage that when reached, old indices should be deleted (e.g. 75)"
                                  "format" = "int64"
                                  "type" = "integer"
                                }
                                "maxAge" = {
                                  "description" = "TimeUnit is a time unit like h,m,d"
                                  "pattern" = "^([0-9]+)([wdhHms]{0,1})$"
                                  "type" = "string"
                                }
                                "namespaceSpec" = {
                                  "description" = "The per namespace specification to delete documents older than a given minimum age"
                                  "items" = {
                                    "properties" = {
                                      "minAge" = {
                                        "description" = "Delete the records matching the namespaces which are older than this MinAge (e.g. 1d)"
                                        "pattern" = "^([0-9]+)([wdhHms]{0,1})$"
                                        "type" = "string"
                                      }
                                      "namespace" = {
                                        "description" = "Target Namespace to delete logs older than MinAge (defaults to 7d) Can be one namespace name or a prefix (e.g., \"openshift-\" covers all namespaces with this prefix)"
                                        "type" = "string"
                                      }
                                    }
                                    "required" = [
                                      "namespace",
                                    ]
                                    "type" = "object"
                                  }
                                  "type" = "array"
                                }
                                "pruneNamespacesInterval" = {
                                  "description" = "How often to run a new prune-namespaces job"
                                  "pattern" = "^([0-9]+)([wdhHms]{0,1})$"
                                  "type" = "string"
                                }
                              }
                              "type" = "object"
                            }
                            "infra" = {
                              "nullable" = true
                              "properties" = {
                                "diskThresholdPercent" = {
                                  "description" = "The threshold percentage of ES disk usage that when reached, old indices should be deleted (e.g. 75)"
                                  "format" = "int64"
                                  "type" = "integer"
                                }
                                "maxAge" = {
                                  "description" = "TimeUnit is a time unit like h,m,d"
                                  "pattern" = "^([0-9]+)([wdhHms]{0,1})$"
                                  "type" = "string"
                                }
                                "namespaceSpec" = {
                                  "description" = "The per namespace specification to delete documents older than a given minimum age"
                                  "items" = {
                                    "properties" = {
                                      "minAge" = {
                                        "description" = "Delete the records matching the namespaces which are older than this MinAge (e.g. 1d)"
                                        "pattern" = "^([0-9]+)([wdhHms]{0,1})$"
                                        "type" = "string"
                                      }
                                      "namespace" = {
                                        "description" = "Target Namespace to delete logs older than MinAge (defaults to 7d) Can be one namespace name or a prefix (e.g., \"openshift-\" covers all namespaces with this prefix)"
                                        "type" = "string"
                                      }
                                    }
                                    "required" = [
                                      "namespace",
                                    ]
                                    "type" = "object"
                                  }
                                  "type" = "array"
                                }
                                "pruneNamespacesInterval" = {
                                  "description" = "How often to run a new prune-namespaces job"
                                  "pattern" = "^([0-9]+)([wdhHms]{0,1})$"
                                  "type" = "string"
                                }
                              }
                              "type" = "object"
                            }
                          }
                          "type" = "object"
                        }
                        "type" = {
                          "default" = "lokistack"
                          "description" = <<-EOT
                          The Type of Log Storage to configure. The operator currently supports either using ElasticSearch managed by elasticsearch-operator or Loki managed by loki-operator (LokiStack) as a default log store. 
                           When using ElasticSearch as a log store this operator also manages the ElasticSearch deployment. 
                           When using LokiStack as a log store this operator does not manage the LokiStack, but only creates configuration referencing an existing LokiStack deployment. The user is responsible for creating and managing the LokiStack himself.
                          EOT
                          "enum" = [
                            "elasticsearch",
                            "lokistack",
                          ]
                          "type" = "string"
                        }
                      }
                      "required" = [
                        "type",
                      ]
                      "type" = "object"
                    }
                    "managementState" = {
                      "description" = "Indicator if the resource is 'Managed' or 'Unmanaged' by the operator"
                      "enum" = [
                        "Managed",
                        "Unmanaged",
                      ]
                      "type" = "string"
                    }
                    "visualization" = {
                      "description" = "Specification of the Visualization component for the cluster"
                      "nullable" = true
                      "properties" = {
                        "kibana" = {
                          "description" = "Specification of the Kibana Visualization component"
                          "nullable" = true
                          "properties" = {
                            "nodeSelector" = {
                              "additionalProperties" = {
                                "type" = "string"
                              }
                              "description" = "Define which Nodes the Pods are scheduled on."
                              "nullable" = true
                              "type" = "object"
                            }
                            "proxy" = {
                              "description" = "Specification of the Kibana Proxy component"
                              "properties" = {
                                "resources" = {
                                  "description" = "ResourceRequirements describes the compute resource requirements."
                                  "nullable" = true
                                  "properties" = {
                                    "claims" = {
                                      "description" = <<-EOT
                                      Claims lists the names of resources, defined in spec.resourceClaims, that are used by this container. 
                                       This is an alpha field and requires enabling the DynamicResourceAllocation feature gate. 
                                       This field is immutable. It can only be set for containers.
                                      EOT
                                      "items" = {
                                        "description" = "ResourceClaim references one entry in PodSpec.ResourceClaims."
                                        "properties" = {
                                          "name" = {
                                            "description" = "Name must match the name of one entry in pod.spec.resourceClaims of the Pod where this field is used. It makes that resource available inside a container."
                                            "type" = "string"
                                          }
                                        }
                                        "required" = [
                                          "name",
                                        ]
                                        "type" = "object"
                                      }
                                      "type" = "array"
                                      "x-kubernetes-list-map-keys" = [
                                        "name",
                                      ]
                                      "x-kubernetes-list-type" = "map"
                                    }
                                    "limits" = {
                                      "additionalProperties" = {
                                        "anyOf" = [
                                          {
                                            "type" = "integer"
                                          },
                                          {
                                            "type" = "string"
                                          },
                                        ]
                                        "pattern" = "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
                                        "x-kubernetes-int-or-string" = true
                                      }
                                      "description" = "Limits describes the maximum amount of compute resources allowed. More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/"
                                      "type" = "object"
                                    }
                                    "requests" = {
                                      "additionalProperties" = {
                                        "anyOf" = [
                                          {
                                            "type" = "integer"
                                          },
                                          {
                                            "type" = "string"
                                          },
                                        ]
                                        "pattern" = "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
                                        "x-kubernetes-int-or-string" = true
                                      }
                                      "description" = "Requests describes the minimum amount of compute resources required. If Requests is omitted for a container, it defaults to Limits if that is explicitly specified, otherwise to an implementation-defined value. Requests cannot exceed Limits. More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/"
                                      "type" = "object"
                                    }
                                  }
                                  "type" = "object"
                                }
                              }
                              "type" = "object"
                            }
                            "replicas" = {
                              "description" = "Number of instances to deploy for a Kibana deployment"
                              "format" = "int32"
                              "type" = "integer"
                            }
                            "resources" = {
                              "description" = "The resource requirements for Kibana"
                              "nullable" = true
                              "properties" = {
                                "claims" = {
                                  "description" = <<-EOT
                                  Claims lists the names of resources, defined in spec.resourceClaims, that are used by this container. 
                                   This is an alpha field and requires enabling the DynamicResourceAllocation feature gate. 
                                   This field is immutable. It can only be set for containers.
                                  EOT
                                  "items" = {
                                    "description" = "ResourceClaim references one entry in PodSpec.ResourceClaims."
                                    "properties" = {
                                      "name" = {
                                        "description" = "Name must match the name of one entry in pod.spec.resourceClaims of the Pod where this field is used. It makes that resource available inside a container."
                                        "type" = "string"
                                      }
                                    }
                                    "required" = [
                                      "name",
                                    ]
                                    "type" = "object"
                                  }
                                  "type" = "array"
                                  "x-kubernetes-list-map-keys" = [
                                    "name",
                                  ]
                                  "x-kubernetes-list-type" = "map"
                                }
                                "limits" = {
                                  "additionalProperties" = {
                                    "anyOf" = [
                                      {
                                        "type" = "integer"
                                      },
                                      {
                                        "type" = "string"
                                      },
                                    ]
                                    "pattern" = "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
                                    "x-kubernetes-int-or-string" = true
                                  }
                                  "description" = "Limits describes the maximum amount of compute resources allowed. More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/"
                                  "type" = "object"
                                }
                                "requests" = {
                                  "additionalProperties" = {
                                    "anyOf" = [
                                      {
                                        "type" = "integer"
                                      },
                                      {
                                        "type" = "string"
                                      },
                                    ]
                                    "pattern" = "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
                                    "x-kubernetes-int-or-string" = true
                                  }
                                  "description" = "Requests describes the minimum amount of compute resources required. If Requests is omitted for a container, it defaults to Limits if that is explicitly specified, otherwise to an implementation-defined value. Requests cannot exceed Limits. More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/"
                                  "type" = "object"
                                }
                              }
                              "type" = "object"
                            }
                            "tolerations" = {
                              "description" = "Define the tolerations the Pods will accept"
                              "items" = {
                                "description" = "The pod this Toleration is attached to tolerates any taint that matches the triple <key,value,effect> using the matching operator <operator>."
                                "properties" = {
                                  "effect" = {
                                    "description" = "Effect indicates the taint effect to match. Empty means match all taint effects. When specified, allowed values are NoSchedule, PreferNoSchedule and NoExecute."
                                    "type" = "string"
                                  }
                                  "key" = {
                                    "description" = "Key is the taint key that the toleration applies to. Empty means match all taint keys. If the key is empty, operator must be Exists; this combination means to match all values and all keys."
                                    "type" = "string"
                                  }
                                  "operator" = {
                                    "description" = "Operator represents a key's relationship to the value. Valid operators are Exists and Equal. Defaults to Equal. Exists is equivalent to wildcard for value, so that a pod can tolerate all taints of a particular category."
                                    "type" = "string"
                                  }
                                  "tolerationSeconds" = {
                                    "description" = "TolerationSeconds represents the period of time the toleration (which must be of effect NoExecute, otherwise this field is ignored) tolerates the taint. By default, it is not set, which means tolerate the taint forever (do not evict). Zero and negative values will be treated as 0 (evict immediately) by the system."
                                    "format" = "int64"
                                    "type" = "integer"
                                  }
                                  "value" = {
                                    "description" = "Value is the taint value the toleration matches to. If the operator is Exists, the value should be empty, otherwise just a regular string."
                                    "type" = "string"
                                  }
                                }
                                "type" = "object"
                              }
                              "nullable" = true
                              "type" = "array"
                            }
                          }
                          "type" = "object"
                        }
                        "nodeSelector" = {
                          "additionalProperties" = {
                            "type" = "string"
                          }
                          "description" = "Define which Nodes the Pods are scheduled on."
                          "nullable" = true
                          "type" = "object"
                        }
                        "ocpConsole" = {
                          "description" = "OCPConsole is the specification for the OCP console plugin"
                          "nullable" = true
                          "properties" = {
                            "logsLimit" = {
                              "description" = "LogsLimit is the max number of entries returned for a query."
                              "type" = "integer"
                            }
                            "timeout" = {
                              "description" = "Timeout is the max duration before a query timeout"
                              "pattern" = "^([0-9]+)([smhd]{0,1})$"
                              "type" = "string"
                            }
                          }
                          "type" = "object"
                        }
                        "tolerations" = {
                          "description" = "Define the tolerations the Pods will accept"
                          "items" = {
                            "description" = "The pod this Toleration is attached to tolerates any taint that matches the triple <key,value,effect> using the matching operator <operator>."
                            "properties" = {
                              "effect" = {
                                "description" = "Effect indicates the taint effect to match. Empty means match all taint effects. When specified, allowed values are NoSchedule, PreferNoSchedule and NoExecute."
                                "type" = "string"
                              }
                              "key" = {
                                "description" = "Key is the taint key that the toleration applies to. Empty means match all taint keys. If the key is empty, operator must be Exists; this combination means to match all values and all keys."
                                "type" = "string"
                              }
                              "operator" = {
                                "description" = "Operator represents a key's relationship to the value. Valid operators are Exists and Equal. Defaults to Equal. Exists is equivalent to wildcard for value, so that a pod can tolerate all taints of a particular category."
                                "type" = "string"
                              }
                              "tolerationSeconds" = {
                                "description" = "TolerationSeconds represents the period of time the toleration (which must be of effect NoExecute, otherwise this field is ignored) tolerates the taint. By default, it is not set, which means tolerate the taint forever (do not evict). Zero and negative values will be treated as 0 (evict immediately) by the system."
                                "format" = "int64"
                                "type" = "integer"
                              }
                              "value" = {
                                "description" = "Value is the taint value the toleration matches to. If the operator is Exists, the value should be empty, otherwise just a regular string."
                                "type" = "string"
                              }
                            }
                            "type" = "object"
                          }
                          "nullable" = true
                          "type" = "array"
                        }
                        "type" = {
                          "description" = "The type of Visualization to configure"
                          "enum" = [
                            "ocp-console",
                            "kibana",
                          ]
                          "type" = "string"
                        }
                      }
                      "required" = [
                        "type",
                      ]
                      "type" = "object"
                    }
                  }
                  "type" = "object"
                }
                "status" = {
                  "description" = "Status defines the observed state of ClusterLogging"
                  "properties" = {
                    "collection" = {
                      "description" = "Deprecated."
                      "nullable" = true
                      "properties" = {
                        "logs" = {
                          "properties" = {
                            "fluentdStatus" = {
                              "properties" = {
                                "clusterCondition" = {
                                  "additionalProperties" = {
                                    "description" = "`operator-sdk generate crds` does not allow map-of-slice, must use a named type."
                                    "items" = {
                                      "description" = <<-EOT
                                      Condition represents an observation of an object's state. Conditions are an extension mechanism intended to be used when the details of an observation are not a priori known or would not apply to all instances of a given Kind. 
                                       Conditions should be added to explicitly convey properties that users and components care about rather than requiring those properties to be inferred from other observations. Once defined, the meaning of a Condition can not be changed arbitrarily - it becomes part of the API, and has the same backwards- and forwards-compatibility concerns of any other part of the API.
                                      EOT
                                      "properties" = {
                                        "lastTransitionTime" = {
                                          "format" = "date-time"
                                          "type" = "string"
                                        }
                                        "message" = {
                                          "type" = "string"
                                        }
                                        "reason" = {
                                          "description" = "ConditionReason is intended to be a one-word, CamelCase representation of the category of cause of the current status. It is intended to be used in concise output, such as one-line kubectl get output, and in summarizing occurrences of causes."
                                          "type" = "string"
                                        }
                                        "status" = {
                                          "type" = "string"
                                        }
                                        "type" = {
                                          "description" = <<-EOT
                                          ConditionType is the type of the condition and is typically a CamelCased word or short phrase. 
                                           Condition types should indicate state in the "abnormal-true" polarity. For example, if the condition indicates when a policy is invalid, the "is valid" case is probably the norm, so the condition should be called "Invalid".
                                          EOT
                                          "type" = "string"
                                        }
                                      }
                                      "required" = [
                                        "status",
                                        "type",
                                      ]
                                      "type" = "object"
                                    }
                                    "type" = "array"
                                  }
                                  "type" = "object"
                                }
                                "daemonSet" = {
                                  "type" = "string"
                                }
                                "nodes" = {
                                  "additionalProperties" = {
                                    "type" = "string"
                                  }
                                  "type" = "object"
                                }
                                "pods" = {
                                  "additionalProperties" = {
                                    "items" = {
                                      "type" = "string"
                                    }
                                    "type" = "array"
                                  }
                                  "type" = "object"
                                }
                              }
                              "type" = "object"
                            }
                          }
                          "type" = "object"
                        }
                      }
                      "type" = "object"
                    }
                    "conditions" = {
                      "description" = "Conditions is a set of Condition instances."
                      "items" = {
                        "description" = <<-EOT
                        Condition represents an observation of an object's state. Conditions are an extension mechanism intended to be used when the details of an observation are not a priori known or would not apply to all instances of a given Kind. 
                         Conditions should be added to explicitly convey properties that users and components care about rather than requiring those properties to be inferred from other observations. Once defined, the meaning of a Condition can not be changed arbitrarily - it becomes part of the API, and has the same backwards- and forwards-compatibility concerns of any other part of the API.
                        EOT
                        "properties" = {
                          "lastTransitionTime" = {
                            "format" = "date-time"
                            "type" = "string"
                          }
                          "message" = {
                            "type" = "string"
                          }
                          "reason" = {
                            "description" = "ConditionReason is intended to be a one-word, CamelCase representation of the category of cause of the current status. It is intended to be used in concise output, such as one-line kubectl get output, and in summarizing occurrences of causes."
                            "type" = "string"
                          }
                          "status" = {
                            "type" = "string"
                          }
                          "type" = {
                            "description" = <<-EOT
                            ConditionType is the type of the condition and is typically a CamelCased word or short phrase. 
                             Condition types should indicate state in the "abnormal-true" polarity. For example, if the condition indicates when a policy is invalid, the "is valid" case is probably the norm, so the condition should be called "Invalid".
                            EOT
                            "type" = "string"
                          }
                        }
                        "required" = [
                          "status",
                          "type",
                        ]
                        "type" = "object"
                      }
                      "type" = "array"
                    }
                    "curation" = {
                      "properties" = {
                        "curatorStatus" = {
                          "items" = {
                            "properties" = {
                              "clusterCondition" = {
                                "additionalProperties" = {
                                  "description" = "`operator-sdk generate crds` does not allow map-of-slice, must use a named type."
                                  "items" = {
                                    "description" = <<-EOT
                                    Condition represents an observation of an object's state. Conditions are an extension mechanism intended to be used when the details of an observation are not a priori known or would not apply to all instances of a given Kind. 
                                     Conditions should be added to explicitly convey properties that users and components care about rather than requiring those properties to be inferred from other observations. Once defined, the meaning of a Condition can not be changed arbitrarily - it becomes part of the API, and has the same backwards- and forwards-compatibility concerns of any other part of the API.
                                    EOT
                                    "properties" = {
                                      "lastTransitionTime" = {
                                        "format" = "date-time"
                                        "type" = "string"
                                      }
                                      "message" = {
                                        "type" = "string"
                                      }
                                      "reason" = {
                                        "description" = "ConditionReason is intended to be a one-word, CamelCase representation of the category of cause of the current status. It is intended to be used in concise output, such as one-line kubectl get output, and in summarizing occurrences of causes."
                                        "type" = "string"
                                      }
                                      "status" = {
                                        "type" = "string"
                                      }
                                      "type" = {
                                        "description" = <<-EOT
                                        ConditionType is the type of the condition and is typically a CamelCased word or short phrase. 
                                         Condition types should indicate state in the "abnormal-true" polarity. For example, if the condition indicates when a policy is invalid, the "is valid" case is probably the norm, so the condition should be called "Invalid".
                                        EOT
                                        "type" = "string"
                                      }
                                    }
                                    "required" = [
                                      "status",
                                      "type",
                                    ]
                                    "type" = "object"
                                  }
                                  "type" = "array"
                                }
                                "type" = "object"
                              }
                              "cronJobs" = {
                                "type" = "string"
                              }
                              "schedules" = {
                                "type" = "string"
                              }
                              "suspended" = {
                                "type" = "boolean"
                              }
                            }
                            "type" = "object"
                          }
                          "type" = "array"
                        }
                      }
                      "type" = "object"
                    }
                    "logStore" = {
                      "properties" = {
                        "elasticsearchStatus" = {
                          "items" = {
                            "properties" = {
                              "cluster" = {
                                "properties" = {
                                  "activePrimaryShards" = {
                                    "description" = "The number of Active Primary Shards for the Elasticsearch Cluster"
                                    "format" = "int32"
                                    "type" = "integer"
                                  }
                                  "activeShards" = {
                                    "description" = "The number of Active Shards for the Elasticsearch Cluster"
                                    "format" = "int32"
                                    "type" = "integer"
                                  }
                                  "initializingShards" = {
                                    "description" = "The number of Initializing Shards for the Elasticsearch Cluster"
                                    "format" = "int32"
                                    "type" = "integer"
                                  }
                                  "numDataNodes" = {
                                    "description" = "The number of Data Nodes for the Elasticsearch Cluster"
                                    "format" = "int32"
                                    "type" = "integer"
                                  }
                                  "numNodes" = {
                                    "description" = "The number of Nodes for the Elasticsearch Cluster"
                                    "format" = "int32"
                                    "type" = "integer"
                                  }
                                  "pendingTasks" = {
                                    "format" = "int32"
                                    "type" = "integer"
                                  }
                                  "relocatingShards" = {
                                    "description" = "The number of Relocating Shards for the Elasticsearch Cluster"
                                    "format" = "int32"
                                    "type" = "integer"
                                  }
                                  "status" = {
                                    "description" = "The current Status of the Elasticsearch Cluster"
                                    "type" = "string"
                                  }
                                  "unassignedShards" = {
                                    "description" = "The number of Unassigned Shards for the Elasticsearch Cluster"
                                    "format" = "int32"
                                    "type" = "integer"
                                  }
                                }
                                "required" = [
                                  "activePrimaryShards",
                                  "activeShards",
                                  "initializingShards",
                                  "numDataNodes",
                                  "numNodes",
                                  "pendingTasks",
                                  "relocatingShards",
                                  "status",
                                  "unassignedShards",
                                ]
                                "type" = "object"
                              }
                              "clusterConditions" = {
                                "items" = {
                                  "properties" = {
                                    "lastTransitionTime" = {
                                      "description" = "Last time the condition transitioned from one status to another."
                                      "format" = "date-time"
                                      "type" = "string"
                                    }
                                    "message" = {
                                      "description" = "Human-readable message indicating details about last transition."
                                      "type" = "string"
                                    }
                                    "reason" = {
                                      "description" = "Unique, one-word, CamelCase reason for the condition's last transition."
                                      "type" = "string"
                                    }
                                    "status" = {
                                      "type" = "string"
                                    }
                                    "type" = {
                                      "description" = "ClusterConditionType is a valid value for ClusterCondition.Type"
                                      "type" = "string"
                                    }
                                  }
                                  "required" = [
                                    "lastTransitionTime",
                                    "status",
                                    "type",
                                  ]
                                  "type" = "object"
                                }
                                "type" = "array"
                              }
                              "clusterHealth" = {
                                "type" = "string"
                              }
                              "clusterName" = {
                                "type" = "string"
                              }
                              "deployments" = {
                                "items" = {
                                  "type" = "string"
                                }
                                "type" = "array"
                              }
                              "nodeConditions" = {
                                "additionalProperties" = {
                                  "items" = {
                                    "properties" = {
                                      "lastTransitionTime" = {
                                        "description" = "Last time the condition transitioned from one status to another."
                                        "format" = "date-time"
                                        "type" = "string"
                                      }
                                      "message" = {
                                        "description" = "Human-readable message indicating details about last transition."
                                        "type" = "string"
                                      }
                                      "reason" = {
                                        "description" = "Unique, one-word, CamelCase reason for the condition's last transition."
                                        "type" = "string"
                                      }
                                      "status" = {
                                        "type" = "string"
                                      }
                                      "type" = {
                                        "description" = "ClusterConditionType is a valid value for ClusterCondition.Type"
                                        "type" = "string"
                                      }
                                    }
                                    "required" = [
                                      "lastTransitionTime",
                                      "status",
                                      "type",
                                    ]
                                    "type" = "object"
                                  }
                                  "type" = "array"
                                }
                                "type" = "object"
                              }
                              "nodeCount" = {
                                "format" = "int32"
                                "type" = "integer"
                              }
                              "pods" = {
                                "additionalProperties" = {
                                  "additionalProperties" = {
                                    "items" = {
                                      "type" = "string"
                                    }
                                    "type" = "array"
                                  }
                                  "type" = "object"
                                }
                                "type" = "object"
                              }
                              "replicaSets" = {
                                "items" = {
                                  "type" = "string"
                                }
                                "type" = "array"
                              }
                              "shardAllocationEnabled" = {
                                "type" = "string"
                              }
                              "statefulSets" = {
                                "items" = {
                                  "type" = "string"
                                }
                                "type" = "array"
                              }
                            }
                            "type" = "object"
                          }
                          "type" = "array"
                        }
                      }
                      "type" = "object"
                    }
                    "visualization" = {
                      "properties" = {
                        "kibanaStatus" = {
                          "items" = {
                            "description" = "KibanaStatus defines the observed state of Kibana"
                            "properties" = {
                              "clusterCondition" = {
                                "additionalProperties" = {
                                  "items" = {
                                    "properties" = {
                                      "lastTransitionTime" = {
                                        "description" = "Last time the condition transitioned from one status to another."
                                        "format" = "date-time"
                                        "type" = "string"
                                      }
                                      "message" = {
                                        "description" = "Human-readable message indicating details about last transition."
                                        "type" = "string"
                                      }
                                      "reason" = {
                                        "description" = "Unique, one-word, CamelCase reason for the condition's last transition."
                                        "type" = "string"
                                      }
                                      "status" = {
                                        "type" = "string"
                                      }
                                      "type" = {
                                        "description" = "ClusterConditionType is a valid value for ClusterCondition.Type"
                                        "type" = "string"
                                      }
                                    }
                                    "required" = [
                                      "lastTransitionTime",
                                      "status",
                                      "type",
                                    ]
                                    "type" = "object"
                                  }
                                  "type" = "array"
                                }
                                "type" = "object"
                              }
                              "deployment" = {
                                "type" = "string"
                              }
                              "pods" = {
                                "additionalProperties" = {
                                  "items" = {
                                    "type" = "string"
                                  }
                                  "type" = "array"
                                }
                                "description" = "The status for each of the Kibana pods for the Visualization component"
                                "type" = "object"
                              }
                              "replicaSets" = {
                                "items" = {
                                  "type" = "string"
                                }
                                "type" = "array"
                              }
                              "replicas" = {
                                "format" = "int32"
                                "type" = "integer"
                              }
                            }
                            "type" = "object"
                          }
                          "type" = "array"
                        }
                      }
                      "type" = "object"
                    }
                  }
                  "type" = "object"
                }
              }
              "type" = "object"
            }
          }
          "served" = true
          "storage" = true
          "subresources" = {
            "status" = {}
          }
        },
      ]
    }
  }
}
