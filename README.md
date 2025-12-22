# Flex Helm Chart

**Flex** - A flexible, universal Helm chart for deploying any Kubernetes workload with ease.

## 🎯 Overview

Deploy any workload type with a single, configurable chart:

| Category | Resources |
|----------|-----------|
| **Workloads** | Deployment, StatefulSet, DaemonSet, Job, CronJob |
| **Networking** | Service, Ingress, NetworkPolicy |
| **Configuration** | ConfigMap, Secret, ExternalSecret |
| **Storage** | PersistentVolumeClaim, Volumes |
| **Security** | ServiceAccount, Role, RoleBinding, ClusterRole, ClusterRoleBinding |
| **Scaling** | HorizontalPodAutoscaler, PodDisruptionBudget |
| **Monitoring** | ServiceMonitor, PrometheusRule |

## 🚀 Quick Start

### Installation

```bash
# Add the repo
helm repo add foushua https://foushua.github.io/flex
helm repo update

# Install with defaults (creates a nginx deployment)
helm install my-app foushua/flex

# Install with custom values
helm install my-app foushua/flex -f my-values.yaml

# Or install from local directory
helm install my-app . -f my-values.yaml
```

### Simple Example

```yaml
# my-values.yaml
global:
  nameOverride: "my-api"

workload:
  type: deployment
  replicaCount: 2

container:
  image:
    repository: myorg/my-api
    tag: "v1.0.0"
  ports:
    - name: http
      containerPort: 8080
  livenessProbe:
    enabled: true
    httpGet:
      path: /healthz
      port: http
  readinessProbe:
    enabled: true
    httpGet:
      path: /ready
      port: http

service:
  enabled: true
  ports:
    - name: http
      port: 80
      targetPort: http

ingress:
  enabled: true
  className: nginx
  hosts:
    - host: api.example.com
      paths:
        - path: /
          pathType: Prefix
```

## 📖 Configuration

### Global Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| `global.nameOverride` | Override chart name | `""` |
| `global.fullnameOverride` | Override full resource name | `""` |
| `global.imageRegistry` | Default image registry | `""` |
| `global.imagePullSecrets` | Global image pull secrets | `[]` |
| `global.namespace` | Override namespace | `""` |
| `global.commonLabels` | Labels added to all resources | `{}` |
| `global.commonAnnotations` | Annotations added to all resources | `{}` |

### Workload Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `workload.type` | Workload type: `deployment`, `statefulset`, `daemonset`, `job`, `cronjob` | `deployment` |
| `workload.replicaCount` | Number of replicas | `1` |
| `workload.revisionHistoryLimit` | Revision history limit | `10` |
| `workload.minReadySeconds` | Minimum ready seconds | `0` |

### Container Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `container.image.registry` | Image registry | `""` |
| `container.image.repository` | Image repository | `nginx` |
| `container.image.tag` | Image tag | `""` (uses appVersion) |
| `container.image.pullPolicy` | Pull policy | `IfNotPresent` |
| `container.command` | Container command | `[]` |
| `container.args` | Container args | `[]` |
| `container.ports` | Container ports | See values.yaml |
| `container.env` | Environment variables | `[]` |
| `container.resources` | Resource limits/requests | See values.yaml |

### Service & Networking

| Parameter | Description | Default |
|-----------|-------------|---------|
| `service.enabled` | Enable service | `true` |
| `service.type` | Service type | `ClusterIP` |
| `service.ports` | Service ports | See values.yaml |
| `ingress.enabled` | Enable ingress | `false` |
| `ingress.className` | Ingress class | `""` |
| `networkPolicy.enabled` | Enable NetworkPolicy | `false` |

### Storage & Persistence

| Parameter | Description | Default |
|-----------|-------------|---------|
| `persistence.enabled` | Enable persistence | `false` |
| `persistence.storageClass` | Storage class | `""` |
| `persistence.accessModes` | Access modes | `["ReadWriteOnce"]` |
| `persistence.size` | Volume size | `10Gi` |

### Autoscaling & High Availability

| Parameter | Description | Default |
|-----------|-------------|---------|
| `autoscaling.enabled` | Enable HPA | `false` |
| `autoscaling.minReplicas` | Minimum replicas | `1` |
| `autoscaling.maxReplicas` | Maximum replicas | `10` |
| `pdb.enabled` | Enable PodDisruptionBudget | `false` |

## 📁 Examples

| Example | Description |
|---------|-------------|
| `deployment-simple.yaml` | Basic web app deployment |
| `deployment-full.yaml` | Production-ready deployment with all features |
| `statefulset-database.yaml` | PostgreSQL-like database StatefulSet |
| `cronjob-cleanup.yaml` | Scheduled database cleanup job |
| `daemonset-agent.yaml` | Logging agent on all nodes |

```bash
# Use an example
helm install my-app . -f examples/deployment-simple.yaml
```

## 🧪 Testing

```bash
# Lint the chart
helm lint .

# Dry-run with default values
helm template test .

# Dry-run with custom values
helm template test . -f my-values.yaml

# Validate generated manifests
helm template test . | kubectl apply --dry-run=client -f -
```

## 📝 License

MIT License - feel free to use and modify as needed.
