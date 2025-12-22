# Generic Helm Chart

A **super generic, fully customizable** Helm chart for deploying any workload type on Kubernetes with maximum flexibility and minimal boilerplate.

## 🎯 Overview

This chart provides a single, universal template that can deploy:

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
# Add the repo (if published)
helm repo add foushua https://foushua.github.io/charts
helm repo update

# Install with defaults (creates a nginx deployment)
helm install my-app foushua/generic

# Install with custom values
helm install my-app foushua/generic -f my-values.yaml

# Or install from local directory
helm install my-app ./charts/generic -f my-values.yaml
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

#### Deployment Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| `workload.deployment.strategy.type` | Update strategy | `RollingUpdate` |
| `workload.deployment.strategy.rollingUpdate.maxSurge` | Max surge | `25%` |
| `workload.deployment.strategy.rollingUpdate.maxUnavailable` | Max unavailable | `25%` |

#### StatefulSet Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| `workload.statefulset.podManagementPolicy` | Pod management policy | `OrderedReady` |
| `workload.statefulset.updateStrategy.type` | Update strategy | `RollingUpdate` |
| `workload.statefulset.serviceName` | Headless service name | Auto-generated |
| `workload.statefulset.volumeClaimTemplates` | Volume claim templates | `[]` |

#### DaemonSet Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| `workload.daemonset.updateStrategy.type` | Update strategy | `RollingUpdate` |
| `workload.daemonset.updateStrategy.rollingUpdate.maxUnavailable` | Max unavailable | `1` |

#### Job Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| `workload.job.backoffLimit` | Backoff limit | `6` |
| `workload.job.completions` | Completions | `1` |
| `workload.job.parallelism` | Parallelism | `1` |
| `workload.job.activeDeadlineSeconds` | Active deadline | `null` |
| `workload.job.ttlSecondsAfterFinished` | TTL after finished | `null` |
| `workload.job.restartPolicy` | Restart policy | `Never` |

#### CronJob Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| `workload.cronjob.schedule` | Cron schedule | `"0 * * * *"` |
| `workload.cronjob.concurrencyPolicy` | Concurrency policy | `Forbid` |
| `workload.cronjob.suspend` | Suspend cronjob | `false` |
| `workload.cronjob.successfulJobsHistoryLimit` | Success history | `3` |
| `workload.cronjob.failedJobsHistoryLimit` | Failed history | `1` |

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
| `container.envFrom` | Environment from | `[]` |
| `container.resources` | Resource limits/requests | See values.yaml |
| `container.livenessProbe.enabled` | Enable liveness probe | `false` |
| `container.readinessProbe.enabled` | Enable readiness probe | `false` |
| `container.startupProbe.enabled` | Enable startup probe | `false` |
| `container.lifecycle` | Lifecycle hooks | `{}` |
| `container.volumeMounts` | Volume mounts | `[]` |
| `container.securityContext` | Container security context | `{}` |

### Sidecars & Init Containers

```yaml
# Sidecars run alongside main container
sidecars:
  log-shipper:
    image:
      repository: fluent/fluent-bit
      tag: "2.1"
    volumeMounts:
      - name: logs
        mountPath: /var/log

# Init containers run before main container
initContainers:
  wait-for-db:
    image:
      repository: busybox
      tag: latest
    command: ["sh", "-c", "until nc -z db 5432; do sleep 2; done"]
```

### Service Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `service.enabled` | Enable service | `true` |
| `service.type` | Service type | `ClusterIP` |
| `service.clusterIP` | Cluster IP | `""` |
| `service.ports` | Service ports | See values.yaml |
| `service.annotations` | Service annotations | `{}` |

### Ingress Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingress.enabled` | Enable ingress | `false` |
| `ingress.className` | Ingress class | `""` |
| `ingress.annotations` | Ingress annotations | `{}` |
| `ingress.hosts` | Ingress hosts | See values.yaml |
| `ingress.tls` | TLS configuration | `[]` |

### ConfigMaps & Secrets

```yaml
configMaps:
  app-config:
    enabled: true
    data:
      config.yaml: |
        key: value

secrets:
  db-creds:
    enabled: true
    stringData:
      username: admin
      password: secret
```

### External Secrets

```yaml
externalSecrets:
  aws-secrets:
    enabled: true
    refreshInterval: 1h
    secretStoreRef:
      name: aws-secrets-manager
      kind: ClusterSecretStore
    data:
      - secretKey: db-password
        remoteRef:
          key: prod/myapp/database
          property: password
```

### Persistence

| Parameter | Description | Default |
|-----------|-------------|---------|
| `persistence.enabled` | Enable persistence | `false` |
| `persistence.storageClass` | Storage class | `""` |
| `persistence.accessModes` | Access modes | `["ReadWriteOnce"]` |
| `persistence.size` | Volume size | `10Gi` |
| `persistence.existingClaim` | Use existing PVC | `""` |

### Service Account & RBAC

| Parameter | Description | Default |
|-----------|-------------|---------|
| `serviceAccount.create` | Create service account | `true` |
| `serviceAccount.name` | Service account name | Auto-generated |
| `serviceAccount.annotations` | SA annotations | `{}` |
| `rbac.create` | Create RBAC resources | `false` |
| `rbac.rules` | RBAC rules | `[]` |
| `rbac.clusterWide` | Create ClusterRole | `false` |

### Autoscaling

| Parameter | Description | Default |
|-----------|-------------|---------|
| `autoscaling.enabled` | Enable HPA | `false` |
| `autoscaling.minReplicas` | Minimum replicas | `1` |
| `autoscaling.maxReplicas` | Maximum replicas | `10` |
| `autoscaling.targetCPUUtilizationPercentage` | Target CPU | `80` |
| `autoscaling.targetMemoryUtilizationPercentage` | Target memory | `null` |
| `autoscaling.customMetrics` | Custom metrics | `[]` |
| `autoscaling.behavior` | Scaling behavior | `{}` |

### Pod Disruption Budget

| Parameter | Description | Default |
|-----------|-------------|---------|
| `pdb.enabled` | Enable PDB | `false` |
| `pdb.minAvailable` | Min available | `""` |
| `pdb.maxUnavailable` | Max unavailable | `""` |

### Network Policy

| Parameter | Description | Default |
|-----------|-------------|---------|
| `networkPolicy.enabled` | Enable NetworkPolicy | `false` |
| `networkPolicy.policyTypes` | Policy types | `["Ingress", "Egress"]` |
| `networkPolicy.ingress` | Ingress rules | `[]` |
| `networkPolicy.egress` | Egress rules | `[]` |

### Monitoring (Prometheus)

| Parameter | Description | Default |
|-----------|-------------|---------|
| `serviceMonitor.enabled` | Enable ServiceMonitor | `false` |
| `serviceMonitor.interval` | Scrape interval | `30s` |
| `serviceMonitor.endpoints` | Endpoints config | See values.yaml |
| `prometheusRule.enabled` | Enable PrometheusRule | `false` |
| `prometheusRule.groups` | Alert/recording rules | `[]` |

### Pod Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| `podAnnotations` | Pod annotations | `{}` |
| `podLabels` | Pod labels | `{}` |
| `podSecurityContext` | Pod security context | `{}` |
| `nodeSelector` | Node selector | `{}` |
| `tolerations` | Tolerations | `[]` |
| `affinity` | Affinity rules | `{}` |
| `topologySpreadConstraints` | Topology spread | `[]` |
| `priorityClassName` | Priority class | `""` |
| `terminationGracePeriodSeconds` | Termination grace | `30` |

## 📁 Examples

The `examples/` directory contains ready-to-use configurations:

| Example | Description |
|---------|-------------|
| `deployment-simple.yaml` | Basic web app deployment |
| `deployment-full.yaml` | Production-ready deployment with all features |
| `statefulset-database.yaml` | PostgreSQL-like database StatefulSet |
| `cronjob-cleanup.yaml` | Scheduled database cleanup job |
| `daemonset-agent.yaml` | Logging agent on all nodes |

```bash
# Use an example
helm install my-app ./charts/generic -f ./charts/generic/examples/deployment-simple.yaml
```

## 🔧 Advanced Usage

### Main Container with Sidecars

```yaml
# Main container configuration
container:
  image:
    repository: myapp/api
    tag: "1.0"
  ports:
    - name: http
      containerPort: 8080

# Additional sidecar containers
sidecars:
  nginx:
    image:
      repository: nginx
      tag: "1.25"
    ports:
      - name: proxy
        containerPort: 80
  
  metrics:
    image:
      repository: prom/statsd-exporter
      tag: "v0.24"
    ports:
      - name: metrics
        containerPort: 9102
```

### AWS IRSA Integration

```yaml
serviceAccount:
  create: true
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::123456789:role/my-app-role
```

### Custom HPA Metrics

```yaml
autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 20
  customMetrics:
    - type: Pods
      pods:
        metric:
          name: requests_per_second
        target:
          type: AverageValue
          averageValue: "1000"
```

### Network Isolation

```yaml
networkPolicy:
  enabled: true
  ingress:
    - from:
        - namespaceSelector:
            matchLabels:
              name: ingress-nginx
      ports:
        - protocol: TCP
          port: 8080
  egress:
    - to:
        - namespaceSelector:
            matchLabels:
              name: database
      ports:
        - protocol: TCP
          port: 5432
```

## 🧪 Testing

```bash
# Lint the chart
helm lint ./charts/generic

# Dry-run with default values
helm template test ./charts/generic

# Dry-run with custom values
helm template test ./charts/generic -f my-values.yaml

# Validate generated manifests
helm template test ./charts/generic | kubectl apply --dry-run=client -f -
```

## 📝 License

MIT License - feel free to use and modify as needed.
